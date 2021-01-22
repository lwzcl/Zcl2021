{******************************************************************************}
{*                                                                            *}
{*             NTFS磁盘恢复工具  蓝网数据恢复中心     18112338818                            *}
{*                                                                            *}
{******************************************************************************}

unit uScanThread;

interface

uses
 Classes,Windows,SysUtils,uNTFS;

type
  TScanThread = class(TThread)
  private
    { Private declarations }
    FcurDrive : string;
    diskInfo  : TDISK_INFORMATION;
    FLocation : string;
    FFileName : string;
    FFileExt  : string;
    FFileSize : string;
    FCreateTime : string;
    FLastTime : string;
    procedure UpdateListView;
  protected
    procedure Execute; override;
  public
    constructor Create(suspended: boolean; curDrive: string);
  end;

implementation

uses uMain;

function Int64TimeToDateTime(aFileTime: Int64): TDateTime;
var
  UTCTime, LocalTime: TSystemTime;
begin
  FileTimeToSystemTime( TFileTime(aFileTime), UTCTime);
  SystemTimeToTzSpecificLocalTime(nil, UTCTime, LocalTime);
  result := SystemTimeToDateTime(LocalTime);
end;

constructor TScanThread.Create(suspended: Boolean; curDrive: string);
begin
  inherited Create(suspended);
  FCurDrive := curDrive;
end;

procedure TScanThread.UpdateListView;
begin
  with MainForm.ListView1.Items.Add do
  begin
    caption := '0x'+ FLocation;
    subitems.Add(FFileName);
    subitems.Add(FFileExt);
    subitems.Add(FFileSize);
    subitems.Add(FCreateTime);
    subItems.Add(FLastTime);
  end;
  MainForm.DeleteFileCount.Caption := '删除的文件数：'+inttostr(MainForm.ListView1.Items.Count);
end;

procedure TScanThread.Execute;
var
  hDevice, hDest : THandle;
  BootData: array[1..512] of Char;
  MFTData: TDynamicCharArray;
  MFTAttributeData: TDynamicCharArray;
  StandardInformationAttributeData: TDynamicCharArray;
  FileNameAttributeData: TDynamicCharArray;
  DataAttributeHeader: TDynamicCharArray;
  dwread: LongWord;
  dwwritten: LongWord;
  pBootSequence: ^TBOOT_SEQUENCE;
  pFileRecord: ^TFILE_RECORD;
  pMFTNonResidentAttribute : ^TNONRESIDENT_ATTRIBUTE;
  pStandardInformationAttribute : ^TSTANDARD_INFORMATION;
  pFileNameAttribute : ^TFILENAME_ATTRIBUTE;
  pDataAttributeHeader: ^TRECORD_ATTRIBUTE;
  CurrentRecordCounter: integer;
  CurrentRecordLocator: Int64;
  FileName: WideString;
  FileCreationTime, FileChangeTime: TDateTime;
  FileParentDirectoryRecordNumber: Int64;
  FileSize: Int64;
  FileSizeArray : TDynamicCharArray;
  i: integer;

begin

  isSearching := true;
  hDevice := CreateFile( PChar('\\.\'+FcurDrive),
                         GENERIC_READ,
                         FILE_SHARE_READ or FILE_SHARE_WRITE,
                         nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);
  if (hDevice = INVALID_HANDLE_VALUE) then
  begin
    CloseHandle(hDevice);
    isSearching := false;
    exit;
  end;
  New(PBootSequence);
  ZeroMemory(PBootSequence, SizeOf(TBOOT_SEQUENCE));
  SetFilePointer(hDevice, 0, nil, FILE_BEGIN);
  ReadFile(hDevice,PBootSequence^, 512,dwread,nil);
  MainForm.DriveName.Caption := '名称: '+ GetVolumeLabel(FcurDrive[1]);
  MainForm.DriveSerial.Caption := '序号: ' + IntToHex(PBootSequence.VolumeSerialNumber,8);
  with PBootSequence^ do
  begin
    //if  (cOEMID[1]+cOEMID[2]+cOEMID[3]+cOEMID[4] = 'NTFS') then
    if (cOEMID[1] <> $4E)and (cOEMID[2] <> $54)and (cOEMID[3]<>$46)and (cOEMID[4]<>$53) then
    begin
      Dispose(PBootSequence);
      Closehandle(hDevice);
      isSearching := false;
      exit;
    end
  end;

  diskInfo.BytesPerSector := PBootSequence^.wBytesPerSector;
  diskInfo.SectorsPerCluster := PBootSequence^.bSectorsPerCluster;
  diskInfo.BytesPerCluster := diskInfo.BytesPerSector *
                              diskInfo.SectorsPerCluster;
  MainForm.DriveSize.Caption := '大小 : '+IntToStr(PBootSequence.TotalSectors *
                                          diskInfo.BytesPerSector)+' 字节';
  if (PBootSequence^.ClustersPerFileRecord < $80) then
      diskInfo.BytesPerFileRecord := PBootSequence^.ClustersPerFileRecord *
                                     diskInfo.BytesPerCluster
  else
      diskInfo.BytesPerFileRecord := 1 shl ($100 - PBootSequence^.ClustersPerFileRecord);

  MFT_Location := PBootSequence^.MftStartLcn * PBootSequence^.wBytesPerSector
                                * PBootSequence^.bSectorsPerCluster;
  MainForm.DriveMFTLocation.Caption := 'MFT位置 : 0x'+IntToHex(MFT_Location,2);
  MainForm.DiskInfo.BytesPerFileRecord := diskInfo.BytesPerFileRecord;
  MainForm.DiskInfo.BytesPerCluster    := diskInfo.BytesPerCluster;
  MainForm.DiskInfo.BytesPerSector     := diskInfo.BytesPerSector;
  MainForm.DiskInfo.SectorsPerCluster  := diskInfo.SectorsPerCluster;


  SetLength(MFTData,diskInfo.BytesPerFileRecord);
  SetFilePointer(hDevice, Int64Rec(MFT_Location).Lo,
                 @Int64Rec(MFT_Location).Hi, FILE_BEGIN);
  Readfile(hDevice, PChar(MFTData)^, diskInfo.BytesPerFileRecord, dwread, nil);

  //**** 获取主记录 ************************************************************
  if not FixupUpdateSequence(MFTData,diskInfo) then
  begin
    Closehandle(hDevice);
    Dispose(PBootSequence);
    IsSearching := false;
    exit;
  end;

  MFTAttributeData := FindAttributeByType(MFTData,AttributeData);
  New(pMFTNonResidentAttribute);
  ZeroMemory(pMFTNonResidentAttribute, SizeOf(TNONRESIDENT_ATTRIBUTE));
  CopyMemory(pMFTNonResidentAttribute, MFTAttributeData, SizeOf(TNONRESIDENT_ATTRIBUTE));
  if (pMFTNonResidentAttribute^.Attribute.Flags = $8000)
     or (pMFTNonResidentAttribute^.Attribute.Flags = $4000)
     or (pMFTNonResidentAttribute^.Attribute.Flags = $0001) then
  begin
    Dispose(pMFTNonResidentAttribute);
    Closehandle(hDevice);
    Dispose(PBootSequence);
    IsSearching := false;
    exit;
  end;

  MFT_Size := pMFTNonResidentAttribute^.HighVCN - pMFTNonResidentAttribute^.LowVCN;

  Dispose(pMFTNonResidentAttribute);

  MFT_END := MFT_LOCATION + MFT_SIZE;
  MFT_RECORD_COUNT := (MFT_SIZE * diskInfo.BytesPerCluster) div diskInfo.BytesPerFileRecord;
  MainForm.DriveMFTSize.Caption := 'MFT大小 : '+IntToStr(MFT_SIZE * diskInfo.BytesPerCluster)+' 字节';
  MainForm.DriveMFTRecordsCount.Caption := '文件数 : '+IntToStr(MFT_RECORD_COUNT);


  MainForm.listview1.Items.Clear;
  MainForm.PB.Max := MFT_RECORD_COUNT - 16;
  MainForm.PB.Min := 0;
  MainForm.PB.Position := 0;
  MainForm.btnScan.Caption := '停止扫描';
  MainForm.btnRecover.Enabled := false;
  for CurrentRecordCounter := 16 to MFT_RECORD_COUNT-1 do
  begin
    if StopScan then
    begin
      break;
    end;
    MainForm.PB.Position := MainForm.PB.Position + 1;
    CurrentRecordLocator := MFT_LOCATION + CurrentRecordCounter * diskInfo.BytesPerFileRecord;
    SetLength(MFTData, diskInfo.BytesPerFileRecord);
    SetFilePointer(hDevice, Int64Rec(CurrentRecordLocator).Lo,
                   @Int64Rec(CurrentRecordLocator).Hi, FILE_BEGIN);
    Readfile(hDevice, PChar(MFTData)^, diskInfo.BytesPerFileRecord, dwread, nil);
    if not FixupUpdateSequence(MFTData,diskInfo) then
    begin
      continue;
    end;
    New(pFileRecord);
    ZeroMemory(pFileRecord, SizeOf(TFILE_RECORD));
    CopyMemory(pFileRecord, MFTData, SizeOf(TFILE_RECORD));

    if pFileRecord^.Flags=$0 then
    begin
      StandardInformationAttributeData := FindAttributeByType(MFTData, AttributeStandardInformation);
      if StandardInformationAttributeData<>nil then
      begin
        New(pStandardInformationAttribute);
        ZeroMemory(pStandardInformationAttribute, SizeOf(TSTANDARD_INFORMATION));
        CopyMemory(pStandardInformationAttribute, StandardInformationAttributeData,
                   SizeOf(TSTANDARD_INFORMATION));

        FileCreationTime := Int64TimeToDateTime(pStandardInformationAttribute^.CreationTime);
        FileChangeTime := Int64TimeToDateTime(pStandardInformationAttribute^.ChangeTime);
        Dispose(pStandardInformationAttribute);
      end
      else
      begin
        continue;
      end;

      FileNameAttributeData := FindAttributeByType(MFTData, AttributeFileName, true);
      if FileNameAttributeData<>nil then
      begin
        New(pFileNameAttribute);
        ZeroMemory(pFileNameAttribute, SizeOf(TFILENAME_ATTRIBUTE));
        CopyMemory(pFileNameAttribute, FileNameAttributeData, SizeOf(TFILENAME_ATTRIBUTE));
        FileName := WideString(Copy(FileNameAttributeData, $5A, pFileNameAttribute^.NameLength*2));
        Dispose(pFileNameAttribute);
      end
      else
      begin
        continue;
      end;

      DataAttributeHeader := FindAttributeByType(MFTData, AttributeData);
      if DataAttributeHeader<>nil then
      begin
        New(pDataAttributeHeader);
        ZeroMemory(pDataAttributeHeader, SizeOf(TRECORD_ATTRIBUTE));
        CopyMemory(pDataAttributeHeader, DataAttributeHeader, SizeOf(TRECORD_ATTRIBUTE));
        FileSizeArray := Copy(DataAttributeHeader, $10+(pDataAttributeHeader^.NonResident)*$20,
                                 (pDataAttributeHeader^.NonResident+$1)*$4 );
        FileSize := 0;
        for i:=Length(FileSizeArray)-1 downto 0 do
          FileSize := (FileSize shl 8)+Ord(FileSizeArray[i]);
        Dispose(pDataAttributeHeader);
      end
      else
      begin
        continue;
      end;
      FLocation := IntToHex(CurrentRecordLocator,2);
      FFileName := FileName;
      FFileExt  := ExtractFileExt(FileName);
      FFileSize := IntToStr(FileSize);
      FCreateTime := FormatDateTime('c',FileCreationTime);
      FLastTime := FormatDateTime('c',FileChangeTime);
      Synchronize(UpdateListView);
    end;
    Dispose(pFileRecord);
  end;
  Dispose(PBootSequence);
  Closehandle(hDevice);
  isSearching := false;
  MainForm.btnScan.Caption := '扫描磁盘';
  MainForm.btnRecover.Enabled := true;
end;

end.
