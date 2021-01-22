{*------------------------------------------------------------------------------
  if (p[510] = $55) and (p[511] = $AA) then
          begin

            bs[0] := p[454];
            bs[1] := p[455];
            bs[2] := p[456];
            bs[3] := p[457];

            i := LongInt(bs);
            ShowMessage(i.ToString);
            bs[0] := p[460];
            bs[1] := p[461];
            bs[2] := p[462];
            bs[3] := p[463];
            i := LongInt(bs);
            ShowMessage(i.ToString);
          end;

  @author  zcl
  @version 2020/04/19 1.0 Initial revision.
  @todo
  @comment
-------------------------------------------------------------------------------}
unit UdiskIo;

interface

uses
  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants;

type
  diskio = class
  private
    DeviceHandle: THandle;
    _SectorLength: LONG64;
    zhuangtai: Boolean;
    THDeviceHandle : THandleStream;
  public
    constructor Create(DiskName: string); overload;//构造方法
    constructor Create(); overload;
    property DiskHandle: Thandle read DeviceHandle write DeviceHandle;
    property SectorLength: LONG64 read _SectorLength write _SectorLength;
    procedure ReadSector(SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
    procedure WriteSector(SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
    function GetSectorCount(SectorIndex: Int64; ReturnByte: TBytes; size: Integer): LONG64;
    procedure myCloseHandle();
    function binToDec(Value: string): integer; //二进制转为 10进制
    function reverse(s: string): string; //取反串
    function DecTobin(Value: Integer): string; //十进制转化二进制
    function HexToChar(Str: string): string;     //十六转 char
    function CharToHex(Str: string): string; //char 转 十六进制
    function hextoint(s: string): Integer; //16进制转十进制
    function conertde(s: string): string; //数据转换成二进制
    function BytearrToDec(myByte: array of byte; Item: Integer): LONG64;
    procedure FileReadSector(myfilename: string; SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
    procedure FileWritSector(filestr: TFileStream; SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
    procedure DiskToDisk();
    procedure DiskToFile();
    property myzhangtai: Boolean read zhuangtai write zhuangtai;
    function FindDiskP(HddSize: LONG64; size: Integer): Boolean;
  end;

implementation

{ diskio }
uses
  uFrmMain, UFrmSTratr, Vcl.Dialogs, UFrmFindPartition, Vcl.ComCtrls, Vcl.Forms;
   //NTFS_DBR分区信息
  type
  _NTFSDBR_INFORMATION = record
    Bytes_per_secto :LARGE_INTEGER;//每扇区字节数
    Sectors_per_cluster:LARGE_INTEGER;// 每族扇区数
    ReservedSectors: Cardinal;      // 保留扇区数
    TotalSectors: Cardinal;    // 总扇区数
    PartitionType: Byte;          // 分区类型
    StartMFT: Cardinal;       // MFT起始位
    StartMFTMirr: Cardinal; // MFT备份
  end;
  NTFSDBR_INFORMATION =  _NTFSDBR_INFORMATION;
  PNTFSDBR_INFORMATION = ^_NTFSDBR_INFORMATION;




procedure diskio.myCloseHandle();
begin
  if CloseHandle(DeviceHandle) then
  begin

  end
  else
  begin

  end;

end;

function diskio.binToDec(Value: string): integer;
var
  str: string;
  i: integer;
begin
  str := UpperCase(Value);
  result := 0;
  for i := 1 to Length(str) do
    result := result * 2 + ORD(str[i]) - 48;

end;

function diskio.BytearrToDec(myByte: array of byte; Item: Integer): LONG64;
var
  bs: array[0..3] of Byte;
  i: LongInt;
begin
  bs[0] := myByte[0];
  bs[1] := myByte[1];
  bs[2] := myByte[2];
  bs[3] := myByte[3];
  i := LongInt(bs);
  Result := i;
end;

function diskio.CharToHex(Str: string): string;
var
  i: integer;
  ch: char;
begin
  for i := 1 to (length(Str)) do
  begin
    ch := Str[i];
    Result := Result + inttohex(byte(ch), 2);
  end;

end;

function diskio.conertde(s: string): string;
var //数据都是以二进制的形式保存
  i: integer;
begin
  for i := 1 to length(s) do
    result := result + inttohex(ord(s[i]), 2);

end;

constructor diskio.Create;
begin
  inherited;
end;

function diskio.DecTobin(Value: Integer): string;
var
  ST: string;
  N: Integer;
begin
  ST := '';
  N := Value;
  while N >= 2 do
  begin
    //ST := ST + IntToStr(mod_num(N, 2));
    N := N div 2;
  end;
  ST := ST + IntToStr(N);
  Result := reverse(ST);

end;

procedure diskio.DiskToDisk;
var
  Shddsize: LONG64;
  Thddsize: LONG64;
  p: TBytes;
  index: LONG64;
  dataitem: Integer;
  starTime: TTime;
  endTime: TTime;
  endsize: LONG64;
  kedu: LONG64;
begin

  try
    dataitem := 0;
    Shddsize := StrToInt64(Form2.lbl_yuan_szie.Caption) * 512;
    index := StrToInt64(Form2.lbl_start.Caption) * 512;
    dataitem := 32768;
    SetLength(p, dataitem);
    myzhangtai := False;
    endsize := StrToInt64(Form2.lbl_end.Caption) * 512;
    kedu := (StrToInt64(Form2.lbl_yuan_szie.Caption) * 512) div 100;

    try

      starTime := Now();
      Form2.tmr_jishi.Enabled := True;
      while (index < endsize) do
      begin
        if myzhangtai <> true then
        begin
          ReadSector(index, p, dataitem);
          WriteSector(index, p, dataitem);
          index := index + dataitem;
          FrmSTratr.cxProgressBar1.Position := Integer(index div kedu);
        end;
      end;

    except
      on E: Exception do
      begin
        ShowMessage(e.Message);

      end;

    end;

  finally
    begin
      endTime := Now();
      Form2.tmr_jishi.Enabled := False;
      myCloseHandle();
      myCloseHandle();

    end;

  end;

end;

procedure diskio.DiskToFile;
var
  Shddsize: LONG64;
  p: TBytes;
  index: LONG64;
  dataitem: Integer;
  starTime: TTime;
  endTime: TTime;
  endsize: LONG64;
  kedu: LONG64;
  filestr: TFileStream;
begin
  try
    try
      dataitem := 0;
      Shddsize := StrToInt64(Form2.lbl_yuan_szie.Caption) * 512;
      index := StrToInt64(Form2.lbl_start.Caption) * 512;
      dataitem := 32768;
      SetLength(p, dataitem);
      myzhangtai := False;
      endsize := StrToInt64(Form2.lbl_end.Caption) * 512;
      kedu := (StrToInt64(Form2.lbl_yuan_szie.Caption) * 512) div 100;
      filestr := TFileStream.Create(Form2.dxStatusBar1.Panels[3].Text, fmCreate, fmShareDenyNone);
      starTime := Now();
      Form2.tmr_jishi.Enabled := True;
      while (index < endsize) do
      begin
        if myzhangtai <> true then
        begin
          ReadSector(index, p, dataitem);
          FileWritSector(filestr, index, p, dataitem);
          index := index + dataitem;
              //dataitem := index;
          FrmSTratr.cxProgressBar1.Position := Integer(index div kedu);
        end
        else
        begin
          Break;
        end;

      end;

    except
      on E: Exception do
      begin
        ShowMessage(e.Message);

      end;

    end;
  finally
    begin
      endTime := Now();
      Form2.tmr_jishi.Enabled := False;
      myCloseHandle();
      myCloseHandle();
      filestr.Free;

    end;
  end;

end;

procedure diskio.FileReadSector(myfilename: string; SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
begin

end;

procedure diskio.FileWritSector(filestr: TFileStream; SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
begin
  filestr.Seek(SectorIndex, 0);
  filestr.Write(ReturnByte, size);

end;

{*------------------------------------------------------------------------------
  此方法用于查找磁盘分区，NTFS分区，从后面往前面判断

  @author  zcl
  @version 2020/04/23 1.0 Initial revision.
  @todo
  @comment
-------------------------------------------------------------------------------}

function diskio.FindDiskP(HddSize: LONG64; size: Integer): Boolean;
var
  index: LONG64;
  ReturnByte: TBytes;
  bs: array[0..7] of Byte;
  bk: array[0..2] of Byte;
  i: LONG64;
  startsec: LONG64;
  endsec: LONG64;
  Titem: Tlistitem; //此处一定要预定义临时记录存储变量.
  findsize: PWideChar;
  no: Integer;
begin
  index := HddSize;
  SetLength(ReturnByte, 512);
  no := 1;
  while (index <= HddSize) do
  begin
    if index <= 0 then
    begin
      ShowMessage('完成！');
      Exit;
    end;
    ReadSector(index, ReturnByte, 512);

    if (ReturnByte[0] = $EB) and (ReturnByte[1] = $52) and (ReturnByte[2] = $90) and (ReturnByte[3] = $4E) and (ReturnByte[510] = $55) and (ReturnByte[511] = $AA) then
    begin
      CopyMemory(@bs[0], @ReturnByte[40], 8);
      i := LONG64(bs);
      ReadSector(index - i, ReturnByte, 512);
      if (ReturnByte[0] = $EB) and (ReturnByte[1] = $52) and (ReturnByte[2] = $90) then
      begin
        startsec := index - i;
        endsec := index;
        ReadSector(startsec + 6291456, ReturnByte, 512);
        if (ReturnByte[0] = $46) and (ReturnByte[1] = $49) and (ReturnByte[2] = $4C) and (ReturnByte[3] = $45) then
        begin
          with FrmFindPartition. listview1.items.add do
          begin
            caption := (i div 1024 div 1024 div 2).ToString;
            subitems.add(startsec.ToString);
            subitems.add(endsec.ToString);
          end;
          case Application.MessageBox('以上分区正确吗？', '提示', MB_OKCANCEL) of
            IDOK:
              begin
                index := index - i;
              end;
            IDCANCEL:
              begin

              end;
          end;
          Inc(no);
        end;

      end;

    end;
    FrmFindPartition.Label3.Caption := index.ToString;

    Dec(index);
  end;

end;

{*------------------------------------------------------------------------------
   用于获取扇区大小

 -------------------------------------------------------------------------------}

function diskio.GetSectorCount(SectorIndex: Int64; ReturnByte: TBytes; size: Integer): LONG64;
//const
//NTFS64 : array[0..3] of Byte = ($FF,$D8,$FF,$D9);
//NTFS32 : array[0..3] of Byte = ($EB,$58)
begin
//  if (DeviceHandle = INVALID_HANDLE_VALUE) then
//  begin
//    Exit;
//  end;
//
//  FileSeek(DeviceHandle, SectorIndex, 0);
//  FileRead(DeviceHandle, ReturnByte, size); //获取第1扇区
//  if (ReturnByte[0] = $EB) and (ReturnByte[1] = $58) then
//  begin
//           //DOS
//           // _SectorLength = (array of Integer { ReturnByte[32], ReturnByte[33], ReturnByte[34], ReturnByte[35] }, 0);
//  end;       //
//
////
////
////
////
////
  if (ReturnByte[0] = $EB) and (ReturnByte[1] = $52) then        //NTFS好象是64位

  begin
          //_SectorLength = BitConverter.ToInt64(new byte[] { ReturnByte[40], ReturnByte[41], ReturnByte[42], ReturnByte[43], ReturnByte[44], ReturnByte[45], ReturnByte[46], ReturnByte[47] }, 0);
  end;

end;

function diskio.HexToChar(Str: string): string;
var
  i: integer;
  buf1: array[0..100] of byte;
begin
  for i := 0 to (length(Str) div 2 - 1) do
  begin
    buf1[i] := strtoint('$' + copy(Str, i * 2 + 1, 2));
    Result := Result + char(buf1[i]);
  end;

end;

function diskio.hextoint(s: string): Integer;
begin          //$代表16进制
  Result := StrToInt('$' + s);

end;

procedure diskio.ReadSector(SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
begin
  if DeviceHandle <> INVALID_HANDLE_VALUE then
  begin
    FileSeek(DeviceHandle, SectorIndex * 512, 0);

    FileRead(DeviceHandle, ReturnByte[0], size); //获取扇区
  end;

end;

function diskio.reverse(s: string): string;
var
  i, num: Integer;
  st: string;
begin
  num := Length(s);
  st := '';
  for i := num downto 1 do
  begin
    st := st + s[i];
  end;
  Result := st;

end;

procedure diskio.WriteSector(SectorIndex: Int64; ReturnByte: TBytes; size: Integer);
begin
  if (Length(ReturnByte) <> size) and (DeviceHandle = INVALID_HANDLE_VALUE) then
  begin
    Exit;
  end;

  FileSeek(DeviceHandle, SectorIndex, 0);
  FileWrite(DeviceHandle, ReturnByte[0], size); //写入扇区
            //if (SectorIndex > _SectorLength) return;

end;

constructor diskio.Create(DiskName: string);
begin
  try

    if (DiskName.Trim <> '') and (DiskName.Trim.Length <> 0) then
    begin
      DeviceHandle := CreateFile(PWideChar(DiskName.trim), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
        FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
        THDeviceHandle := THandleStream.Create(DeviceHandle);

    end;

  except
    on E: Exception do


  end;
end;

end.

