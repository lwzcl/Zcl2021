{******************************************************************************}
{*                                                                            *}
{*             NTFS磁盘恢复工具  不赖猴  QQ:35927925                          *}
{*                                                                            *}
{******************************************************************************}

unit uNTFS;

interface

uses Windows;

type
  TDynamicCharArray = array of Char;

type
  TBOOT_SEQUENCE = packed record        // 引导扇区数据结构
    _jmpcode : array[1..3] of Byte;
   	//cOEMID: array[1..4] of Char;
    cOEMID: array[1..8] of Byte;
 	  wBytesPerSector: Word;
 	  bSectorsPerCluster: Byte;
    wSectorsReservedAtBegin: Word;
 	  Mbz1: Byte;
 	  Mbz2: Word;
 	  Reserved1: Word;
 	  bMediaDescriptor: Byte;
 	  Mbz3: Word;
 	  wSectorsPerTrack: Word;
 	  wSides: Word;
 	  dwSpecialHiddenSectors: DWord;
 	  Reserved2: DWord;
 	  Reserved3: DWord;
 	  TotalSectors: Int64;
 	  MftStartLcn: Int64;
 	  Mft2StartLcn: Int64;
 	  ClustersPerFileRecord: DWord;
 	  ClustersPerIndexBlock: DWord;
 	  VolumeSerialNumber: Int64;
 	  _loadercode: array[1..430] of Byte;
 	  wSignature: Word;
  end;

type
  TNTFS_RECORD_HEADER = packed record
    Identifier: array[1..4] of Byte; // 固定值'FILE'
    UsaOffset : Word;                // 更新序列号偏移,与操作系统有关
    UsaCount : Word;                 // 固定列表大小
    LSN : Int64;                     // 日志文件序列号
  end;

type
  TFILE_RECORD = packed record            // MFT文件记录属性头结构
    Header: TNTFS_RECORD_HEADER;          // 头属性
	  SequenceNumber : Word;                // 序列号(用于记录文件被反复使用的次数)
	  ReferenceCount : Word;                // 硬连接数,跟目录中的项目关联
	  AttributesOffset : Word;              // 第一个属性的偏移
	  Flags : Word;                         // 0=删除 1=普通文件 2=目录被删除 3=普通目录
	  BytesInUse : DWord;                   // 文件记录的实际大小(字节)
	  BytesAllocated : DWord;               // 文件记录分配的大小(字节)
	  BaseFileRecord : Int64;               // 基础记录
	  NextAttributeID : Word;               // 下一个属性ID
    Pading : Word;                // Align to 4 Bytes boundary (XP)
    MFTRecordNumber : DWord;      // Number of this MFT Record (XP)
  end;

type
  TRECORD_ATTRIBUTE = packed record    //各种属性的共有部分
    AttributeType : DWord;             // 类型
    Length : DWord;                    // 长度
    NonResident : Byte;                // 非常驻标志(0x00: 常驻属性; 0x01: 非常驻属性)
    NameLength : Byte;                 // 名称长度
    NameOffset : Word;                 // 名称偏移
    Flags : Word;                      // 标识
    AttributeNumber : Word;            // 标识
  end;

type
  TRESIDENT_ATTRIBUTE = packed record       // 常驻属性
    Attribute : TRECORD_ATTRIBUTE;
    ValueLength : DWord;
    ValueOffset : Word;
    Flags : Word;
  end;

type
  TNONRESIDENT_ATTRIBUTE = packed record    // 非常驻属性
    Attribute: TRECORD_ATTRIBUTE;
    LowVCN: Int64;
    HighVCN: Int64;
    RunArrayOffset : Word;
    CompressionUnit : Byte;
    Padding : array[1..5] of Byte;
    AllocatedSize: Int64;
    DataSize: Int64;
    InitializedSize: Int64;
    CompressedSize: Int64;
  end;

type
  TFILENAME_ATTRIBUTE = packed record       // 文件名属性
	  Attribute: TRESIDENT_ATTRIBUTE;
    DirectoryFileReferenceNumber: Int64;
    CreationTime: Int64;
    ChangeTime: Int64;
    LastWriteTime: Int64;
    LastAccessTime: Int64;
    AllocatedSize: Int64;
    DataSize: Int64;
    FileAttributes: DWord;
    AlignmentOrReserved: DWord;
    NameLength: Byte;
    NameType: Byte;
	  Name: Word;
  end;

type
  TSTANDARD_INFORMATION = packed record      //标准属性
	  Attribute: TRESIDENT_ATTRIBUTE;  //常驻
	  CreationTime: Int64;
	  ChangeTime: Int64;
	  LastWriteTime: Int64;
	  LastAccessTime: Int64;
	  FileAttributes: DWord;
	  Alignment: array[1..3] of DWord;
	  QuotaID: DWord;
	  SecurityID: DWord;
	  QuotaCharge: Int64;
	  USN: Int64;
  end;

type
  TDISK_INFORMATION = packed record
      BytesPerFileRecord: Word;
      BytesPerCluster: Word;
      BytesPerSector: Word;
      SectorsPerCluster: Word;
  end;

const
  // MFT属性
  AttributeStandardInformation = $10;
  AttributeAttributeList = $20;
  AttributeFileName = $30;
  AttributeObjectId = $40;
  AttributeSecurityDescriptor = $50;
  AttributeVolumeName	= $60;
  AttributeVolumeInformation = $70;
  AttributeData = $80;
  AttributeIndexRoot = $90;
  AttributeIndexAllocation = $A0;
  AttributeBitmap = $B0;
  AttributeReparsePoint	= $C0;
  AttributeEAInformation = $D0;
  AttributeEA = $E0;
  AttributePropertySet = $F0;
  AttributeLoggedUtilityStream = $100;

function GetVolumeLabel(Drive: Char): string;
function FixupUpdateSequence(var RecordData: TDynamicCharArray; diskInfo: TDISK_INFORMATION):boolean;
function FindAttributeByType(RecordData: TDynamicCharArray; AttributeType: DWord;       //修正更新序列
                                      FindSpecificFileNameSpaceValue: boolean=false) : TDynamicCharArray;
//查找属性类型


implementation
uses SysUtils;

function GetVolumeLabel(Drive: Char): string;
var
  unused, flags: DWord;
  buffer: array [0..MAX_PATH] of Char;
begin
  buffer[0] := #$00;
  if GetVolumeInformation(PChar(Drive + ':\'), buffer, DWord(sizeof(buffer)),nil,unused,flags,nil,0) then
     SetString(result, buffer, StrLen(buffer))
  else
     result := '';
end;
 /// <code>
 /// 查找属性类型
 /// </code>
function FindAttributeByType(RecordData: TDynamicCharArray; AttributeType: DWord;
                                      FindSpecificFileNameSpaceValue: boolean=false) : TDynamicCharArray;
var
  pFileRecord: ^TFILE_RECORD;
  pRecordAttribute: ^TRECORD_ATTRIBUTE;
  NextAttributeOffset: Word;
  TmpRecordData: TDynamicCharArray;
  TotalBytes: Word;
begin
  New(pFileRecord);
  ZeroMemory(pFileRecord, SizeOf(TFILE_RECORD));
  CopyMemory(pFileRecord, RecordData, SizeOf(TFILE_RECORD));
  if  (pFileRecord.Header.Identifier[1] <> $46)and ( pFileRecord.Header.Identifier[2]<>$49)
     and (pFileRecord.Header.Identifier[3]<>$4C) and ( pFileRecord.Header.Identifier[4]<>$45) then begin
    NextAttributeOffset := 0;
  end else begin
    NextAttributeOffset := pFileRecord^.AttributesOffset;
  end;

  TotalBytes := Length(RecordData);
  Dispose(pFileRecord);

  New(pRecordAttribute); //申请一个通用属性
  ZeroMemory(pRecordAttribute, SizeOf(TRECORD_ATTRIBUTE)); //开内存空间

  SetLength(TmpRecordData,TotalBytes-(NextAttributeOffset-1)); //动态数组设置长度
  TmpRecordData := Copy(RecordData,NextAttributeOffset,TotalBytes-(NextAttributeOffset-1));
  CopyMemory(pRecordAttribute, TmpRecordData, SizeOf(TRECORD_ATTRIBUTE));

  while (pRecordAttribute^.AttributeType <> $FFFFFFFF) and
        (pRecordAttribute^.AttributeType <> AttributeType) do begin
    NextAttributeOffset := NextAttributeOffset + pRecordAttribute^.Length;
    SetLength(TmpRecordData,TotalBytes-(NextAttributeOffset-1));
    TmpRecordData := Copy(RecordData,NextAttributeOffset,TotalBytes-(NextAttributeOffset-1));
    CopyMemory(pRecordAttribute, TmpRecordData, SizeOf(TRECORD_ATTRIBUTE));
  end;

  if pRecordAttribute^.AttributeType = AttributeType then begin

    if (FindSpecificFileNameSpaceValue) and (AttributeType=AttributeFileName)  then begin
      if (TmpRecordData[$59]=Char($0)) {POSIX} or (TmpRecordData[$59]=Char($1)) {Win32}
         or (TmpRecordData[$59]=Char($3)) {Win32&DOS} then begin
        SetLength(result,pRecordAttribute^.Length);
        result := Copy(TmpRecordData,0,pRecordAttribute^.Length);
      end else begin
        NextAttributeOffset := NextAttributeOffset + pRecordAttribute^.Length;
        SetLength(TmpRecordData,TotalBytes-(NextAttributeOffset-1));
        TmpRecordData := Copy(RecordData,NextAttributeOffset,TotalBytes-(NextAttributeOffset-1));
        result := FindAttributeByType(TmpRecordData,AttributeType,true);
      end;

    end else begin
      SetLength(result,pRecordAttribute^.Length);
      result := Copy(TmpRecordData,0,pRecordAttribute^.Length);
    end;

  end else begin
    result := nil;
  end;
  Dispose(pRecordAttribute);
end;

/// <code>
///    //修正更新序列
/// </code>
function FixupUpdateSequence(var RecordData: TDynamicCharArray; diskInfo: TDISK_INFORMATION):boolean;
var
  pFileRecord: ^TFILE_RECORD;
  UpdateSequenceOffset, UpdateSequenceCount: Word;
  UpdateSequenceNumber: array[1..2] of Char;
  i: integer;
  tmp:integer;
begin
  result := false;
  New(pFileRecord);
  ZeroMemory(pFileRecord, SizeOf(TFILE_RECORD));
  CopyMemory(pFileRecord, RecordData, SizeOf(TFILE_RECORD));

  with pFileRecord^.Header do
  begin
    if (Identifier[1] <> $46)and (Identifier[2] <> $49) and (Identifier[3] <> $4C)and (Identifier[4]<> $45)  then
    begin
      Dispose(pFileRecord);
      exit;
    end;
  end;

  UpdateSequenceOffset := pFileRecord^.Header.UsaOffset;
  UpdateSequenceCount := pFileRecord^.Header.UsaCount;
  Dispose(pFileRecord);
  UpdateSequenceNumber[1] := RecordData[UpdateSequenceOffset];
  UpdateSequenceNumber[2] := RecordData[UpdateSequenceOffset+1];
  tmp:=  UpdateSequenceCount;

  for  I:= 1 to tmp -1 do
  begin
    if (RecordData[i * diskInfo.BytesPerSector-2] = UpdateSequenceNumber[1]) and (RecordData[i * diskInfo.BytesPerSector-1] = UpdateSequenceNumber[2]) then
    begin
       exit;
    end;
    RecordData[i * diskInfo.BytesPerSector-2] := RecordData[UpdateSequenceOffset+2*i];
    RecordData[i * diskInfo.BytesPerSector-1] := RecordData[UpdateSequenceOffset+1+2*i];

  end;
  result := true;
end;


end.
