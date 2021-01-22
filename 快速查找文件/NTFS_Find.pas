

unit NTFS_Find;

interface


uses
  System.Classes;

function SearchNTFS(ADiskName: PWideChar;  AFiles: TStrings):Boolean;


implementation

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Generics.Collections, Vcl.Dialogs;


type
  _PARTITION_INFORMATION = record
    StartingOffset :LARGE_INTEGER;// ָ��������ʼ���������ϵ��ֽ�ƫ����
    PartitionLength:LARGE_INTEGER;// ָ�������ĳ��ȣ����ֽ�Ϊ��λ��
    HiddenSectors: Cardinal;      // ָ����������������
    PartitionNumber: Cardinal;    // ָ��������
    PartitionType: Byte;          // ��������
    BootIndicator: Boolean;       // TRUEʱ��ָʾ�˷����Ǹ��豸�Ŀ����������������ΪFALSEʱ���÷�����������
    RecognizedPartition: Boolean; // TRUEʱ����ʾϵͳʶ����������͡�ΪFALSEʱ��ϵͳ�޷�ʶ�����������
    RewritePartition: Boolean;    // TRUEʱ������������Ϣ�Ѹ��ġ�ΪFALSEʱ��������Ϣδ����
  end;
  PARTITION_INFORMATION  =  _PARTITION_INFORMATION;
  PPARTITION_INFORMATION = ^_PARTITION_INFORMATION;

  // ����USN��¼�ṹ��Ϣ�ṹ
  _USN_RECORD = record
    RecordLength: DWORD;                 // ����USN��¼����
    MajorVersion: WORD;                  // ���汾
    MinorVersion: WORD;                  // �ΰ汾
    FileReferenceNumber: DWORDLONG;      // �ļ�������
    ParentFileReferenceNumber: DWORDLONG;// ���ļ�������
    Usn: Int64;                          // USN��һ��Ϊint64���ͣ�
    TimeStamp: LARGE_INTEGER;            // ʱ���
    Reason: DWORD;                       // ԭ��
    SourceInfo: DWORD;                   // Դ��Ϣ
    SecurityId: DWORD;                   // ��ȫ
    FileAttributes: DWORD;               // �ļ����ԣ��ļ���Ŀ¼��
    FileNameLength: WORD;                // �ļ�������
    FileNameOffset: WORD;                // �ļ���ƫ����
    FileName: PWideChar;                 // �ļ�����һλ��ָ��
  end;
  USN_RECORD = _USN_RECORD;
  PUSN_RECORD=^_USN_RECORD;

  // USN��־��Ϣ�ṹ
  _USN_JOURNAL_DATA=  record
    UsnJournalID: DWORDLONG;   // USN��־ID
    FirstUsn: Int64;           // ��һ��USN��¼��λ��
    NextUsn: Int64;            // ��һ��USN��¼��Ҫд���λ��
    LowestValidUsn: Int64;     // ��С����Ч��USN��FistUSNС�ڸ�ֵ��
    MaxUsn: Int64;             // USN���ֵ
    MaximumSize: DWORDLONG;    // USN��־����С����Byte�㣩
    AllocationDelta: DWORDLONG;// USN��־ÿ�δ������ͷŵ��ڴ��ֽ���
  end;
  USN_JOURNAL_DATA  = _USN_JOURNAL_DATA;
  PUSN_JOURNAL_DATA =^_USN_JOURNAL_DATA;

  // ����USN��־�Ľṹ
  _CREATE_USN_JOURNAL_DATA = record
    MaximumSize: DWORDLONG;    // NTFS�ļ�ϵͳ�����USN��־������С���ֽڣ�
    AllocationDelta: DWORDLONG;// USN��־ÿ�δ������ͷŵ��ڴ��ֽ���
  end;
  CREATE_USN_JOURNAL_DATA  =  _CREATE_USN_JOURNAL_DATA;
  PCREATE_USN_JOURNAL_DATA = ^_CREATE_USN_JOURNAL_DATA;

  // ɾ��USN��־�Ľṹ
  _DELETE_USN_JOURNAL_DATA = record
    UsnJournalID: DWORDLONG;// USN��־ID
    DeleteFlags: DWORD;     // ɾ����־
  end;
  DELETE_USN_JOURNAL_DATA  =  _DELETE_USN_JOURNAL_DATA;
  PDELETE_USN_JOURNAL_DATA = ^_DELETE_USN_JOURNAL_DATA;

  // ����USN��¼ʱ�Ľṹ
  _MFT_ENUM_DATA = record
    StartFileReferenceNumber: DWORDLONG;// ��ʼ�ļ�����������һ�ε��ñ���Ϊ0
    LowUsn: Int64;  // ��СUSN����һ�ε��ã����Ϊ0
    HighUsn: Int64; // ���USN
  end;
  MFT_ENUM_DATA  =  _MFT_ENUM_DATA;
  PMFT_ENUM_DATA = ^_MFT_ENUM_DATA;

  // ��ȡUSN��־����Ľṹ
  _READ_USN_JOURNAL_DATA= record
    StartUsn: Int64;           // �����USN��¼��ʼλ�ã�����һ�ζ�ȡUSN��־��LastUsnֵ��
    ReasonMask: DWORD;         // ԭ���ʶ
    ReturnOnlyOnClose: DWORD;  // ֻ���ڼ�¼�ر�ʱ�ŷ���
    Timeout: DWORDLONG;        // �ӳ�ʱ��
    BytesToWaitFor: DWORDLONG; // ��USN��־��С���ڸ�ֵʱ����
    UsnJournalID: DWORDLONG;   // USN��־ID
  end;
  READ_USN_JOURNAL_DATA  =  _READ_USN_JOURNAL_DATA;
  PREAD_USN_JOURNAL_DATA = ^_READ_USN_JOURNAL_DATA;

  // �ļ�����
  _FileInfo = record
    FileName: String; // �ļ�����
    FileId: UInt64;   // �ļ���ID
    ParentId: UInt64; // �ļ��ĸ�ID
  end;
  TFileInfo =  _FileInfo;
  PFileInfo = ^_FileInfo;


// TStringList ����ֵ������
function MySort(List: TStringList; Index1, Index2: Integer): Integer;
var
  L, R: Int64;
begin
  L := PFileInfo(List.Objects[Index1])^.FileId;
  R := PFileInfo(List.Objects[Index2])^.FileId;
  if L < R then begin
    Result := -1
  end
  else if L = R then begin
    Result := 0
  end else begin
    Result := 1;
  end;
end;


// ��ȡ�ļ�ȫ·��������·�����ļ���
procedure GetFullFileName(DiskName: PWideChar; Files: TStringList);
var
  ArrU64: TArray<UInt64>;
  Idx     : Integer;
  ParentId: UInt64;
  Item: Integer;
begin
  // �� FileList �� FileReferenceNumber ��ֵ����
  Files.Sorted := False;
  Files.CustomSort(MySort);

  // ������õ� FileReferenceNumber ���Ƶ� UInt64 �����б��У�����������п��ٲ��� <TArray.BinarySearch Ϊ��Ч���۰����>
  SetLength(ArrU64, Files.Count);
  for Idx := 0 to Files.Count - 1 do begin
    ArrU64[Idx] := PFileInfo(Files.Objects[Idx])^.FileId;
  end;

  // ��ȡÿһ���ļ�ȫ·������
  for Idx := 0 to Files.Count - 1 do begin
    ParentId := PFileInfo(Files.Objects[Idx])^.ParentId;
    while TArray.BinarySearch(ArrU64, ParentId, Item) do begin
      ParentId  := PFileInfo(Files.Objects[Item])^.ParentId;
      Files.Strings[Idx] := PFileInfo(Files.Objects[Item])^.FileName + '\' + Files.Strings[Idx];
    end;
    Files.Strings[Idx] := (DiskName + ':\' + Files.Strings[Idx]);
  end;
end;


function SearchNTFS( ADiskName: PWideChar;  AFiles: TStrings): Boolean;
const
  Len_Buf        = 440 * 1024; // 500
  PARTITION_IFS  = $07;
  USN_DeleteFlags= $00000001;
var
  lpMaxiLen, lpFileFlags: DWORD;
  Path: Array [0..MAX_PATH-1] of WideChar;

  ErrStr : String;

  hTmp : THandle;
  hFile: THandle;

  pInfo : PARTITION_INFORMATION;
  dwRet: DWORD;

  CUSN : CREATE_USN_JOURNAL_DATA; //����
  USN  : USN_JOURNAL_DATA;
  DUSN : DELETE_USN_JOURNAL_DATA; //ɾ��

  MEnum  : MFT_ENUM_DATA;
  Int64SZ: UInt;
  Buf : array[0 .. Len_Buf-1] of WideChar;
  UsnRecord: PUSN_RECORD;
  AFileName: String;

  pFile: PFileInfo;
  Idx: Integer;
begin
  Result := False;
  // 1.�Ƿ���NTFS���̸�ʽ
  GetVolumeInformation(PWideChar(ADiskName+':\') // ���������������ַ���
                      , nil        // �����������������
                      , 0          // ����������������Ƴ���
                      , nil        // ����������������к�
                      , lpMaxiLen  // ϵͳ���������ļ�������
                      , lpFileFlags// �ļ�ϵͳ��ʶ
                      , Path       // �ļ�����ϵͳ����
                      , MAX_PATH   // �ļ�����ϵͳ���Ƴ���
                      );

  if SameText(Path, 'NTFS') then begin
    // 2.�򿪾� (��Ҫ����ԱȨ��) ����ԱȨ���������� ��ο�  http://delphifmx.com/zh-hans/node/6
    hTmp := 0;
    hFile:= Winapi.Windows.CreateFile(PWideChar('\\.\'+ ADiskName+':')
                                      , Generic_Read + Generic_Write      // �򿪾� ������ʽ(����д)
                                      , File_Share_Read + File_Share_Write// ����ʽ
                                      , nil
                                      , Open_Existing                     // �ļ���������
                                      , File_Attribute_ReadOnly           // �ļ�����
                                      , hTmp);
    if hFile = INVALID_HANDLE_VALUE then begin
      ErrStr := SysErrorMessage(GetLastError());
      Vcl.Dialogs.ShowMessage(ErrStr);
      Exit;
    end;
    // 3.��ʼ��USN��־�ļ�
    if not DeviceIoControl(hFile, FSCTL_CREATE_USN_JOURNAL, @CUSN, Sizeof(CUSN), nil, 0, dwRet, nil) then begin
      ErrStr := SysErrorMessage(GetLastError());
      Vcl.Dialogs.ShowMessage(ErrStr);
      Exit;
    end;
    // 4.��ȡUSN��־������Ϣ
    if not DeviceIoControl(hFile, FSCTL_QUERY_USN_JOURNAL, nil, 0, @USN, Sizeof(USN), dwRet, nil) then begin
      ErrStr := SysErrorMessage(GetLastError());
      Vcl.Dialogs.ShowMessage(ErrStr);
      Exit;
    end;
    // 5.ö��USN��־�ļ��е����м�¼
    MEnum.StartFileReferenceNumber := 0;
    MEnum.LowUsn  := 0;
    MEnum.HighUsn := USN.NextUsn;
    Int64SZ:= Sizeof(Int64);
    while DeviceIoControl(hFile, FSCTL_ENUM_USN_DATA, @MEnum, Sizeof(MEnum), @Buf, Len_Buf, dwRet, nil) do begin
      // �ҵ���һ�� USN ��¼
      UsnRecord := PUSN_RECORD( Integer(@Buf) + Int64SZ );
      while dwRet > 60 do begin
        // ��ȡ�ļ�����
        AFileName := PWideChar(Integer(UsnRecord) + UsnRecord^.FileNameOffset);
        AFileName := Copy(AFileName, 1, UsnRecord^.FileNameLength div 2);
        // ���ļ���Ϣ��ӵ��б���
        pFile           := AllocMem(Sizeof(TFileInfo)); // ע��Ҫ�ͷ��ڴ�
        pFile^.FileName := AFileName;
        pFile^.FileId   := UsnRecord^.FileReferenceNumber;
        pFile^.ParentId := UsnRecord^.ParentFileReferenceNumber;
        AFiles.AddObject(AFileName, TObject(pFile));
        // ��ȡ��һ�� USN ��¼
        if UsnRecord.RecordLength > 0 then begin
          Dec(dwRet, UsnRecord.RecordLength)
        end else begin
          Break;
        end;
        UsnRecord := PUSN_RECORD(Cardinal(UsnRecord) + UsnRecord.RecordLength);
      end;
      Move(Buf, MEnum, Int64SZ);
    end;
    // 7.��ȡ�ļ�ȫ·��������·�����ļ���
    GetFullFileName(ADiskName, TStringList(AFiles));
    // 8.�ͷ��ڴ�
    for Idx := AFiles.Count - 1 Downto 0 do begin
      FreeMem(PFileInfo(AFiles.Objects[Idx]));
    end;
    // 9.ɾ��USN��־�ļ���Ϣ
    DUSN.UsnJournalID := USN.UsnJournalID;
    DUSN.DeleteFlags  := USN_DeleteFlags;
    DeviceIoControl(hFile, FSCTL_DELETE_USN_JOURNAL, @DUSN, Sizeof(DUSN), nil, 0, dwRet, nil);
    CloseHandle(hFile);
    Result := True;
  end;

end;

end.
