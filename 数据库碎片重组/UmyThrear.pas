unit UmyThrear;

interface

uses
  System.Classes, Winapi.Windows, System.SysUtils,System.SyncObjs;

type
  myThread = class(TThread)
  private
    { Private declarations }
    State: Boolean;
    jindu: PLONG64;
    function UpperCaseAnsi(const S: AnsiString): AnsiString;
    function GetFileSize(const fName: AnsiString): Int64;
  protected
    procedure Execute; override;
  public
    procedure jiexi();
    property myState: Boolean read state write state;
    procedure AddIDList();
    procedure DBcheck();
    procedure ClearIDList;
    property myjindu: PLONG64 read jindu write jindu;
  end;

type
  TRec = record
    index: LONG64;
    StartPage: LONG64;
    EndPage: LONG64;
    DatabaseName: string;
    DatabasePath: string;
    Status: string;
  end;

implementation

uses
  Generics.Collections, Umain;

var
  myQueue: TQueue<TRec>;
  CriticalSection : TCriticalSection;

procedure myThread.AddIDList;

begin


end;

procedure myThread.ClearIDList;

begin


end;

procedure myThread.DBcheck;
begin

end;

procedure myThread.Execute;
begin
  { Place thread code here }

  FMain.Memo1.Lines.Clear;
  FMain.Memo1.Lines.Append('���ݿ⿪ʼɨ�裡������������������������');
  FMain.ListView1.Items.Clear;
  ClearIDList;
  AddIDList();

end;

function myThread.GetFileSize(const fName: AnsiString): Int64;
var
  hFile: THandle;
begin
  hFile := _lopen(PAnsiChar(fName), OF_READ);
  Result := FileSeek(hFile, Int64(0), 2);
  _lclose(hFile);

end;

procedure myThread.jiexi();
var
  post, tmp: Int64;
  mysize: Int64;
  p: TBytes;
  bs: array[0..3] of Byte;
  page: Int64;
  hDeviceHandle: Thandle;
  THDeviceHandle: THandleStream;
  rec: TRec;
  StartPage: LONG64;
  Startoffsec: LONG64;
  EndPage: LONG64;
begin

  try
    try
      mysize := StrToInt64(FMain.StatusBar1.Panels[2].Text) * 512;
      SetLength(p, 8192);
      hDeviceHandle := CreateFile(PWideChar(FMain.StatusBar1.Panels[5].Text), GENERIC_ALL, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
      THDeviceHandle := THandleStream.Create(hDeviceHandle);
      post := 0;
      page := 0;
      FMain.Memo1.Lines.Append('���ݿ���Ƭɨ���У�������������������������');
      myState := True;
      FMain.Timer1.Enabled := True;
      while post <= mysize do
      begin
        if not myState then
        begin
          Break;
        end;
        THDeviceHandle.Seek(post, soBeginning);
        THDeviceHandle.Read(p[0], 8192);
        CopyMemory(@bs[0], @p[32], 4);
        if ((p[0] = $1)) then
        begin
          rec.index := post;
          rec.StartPage := Integer(bs);
          System.TMonitor.Enter(myQueue);
          myQueue.Enqueue(rec);
          System.TMonitor.Exit(myQueue);
          tmp := page;
          page := Integer(bs);
          end;
        post := post + 8192;
        jindu := @post;
      end;
      FMain.Memo1.Lines.Append('���ݿ���Ƭɨ����ϣ���������������������');

    except
      on E: Exception do
        FMain.Memo1.Lines.Append('���ݿ�ɨ���������������������������');

    end;

  finally
    THDeviceHandle.Free;
    CloseHandle(hDeviceHandle);
    FMain.PageControl1.ActivePageIndex := 2;
    //FreeMemory(p);
    Sleep(100);
    FMain.Timer1.Enabled := False;

  end;

end;

function myThread.UpperCaseAnsi(const S: AnsiString): AnsiString;
var
  Ch: AnsiChar;
  L, I: Integer;
  Source, Dest: PAnsiChar;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
  begin
    SetLength(Result, L);
    Source := Pointer(S);
    Dest := Pointer(Result);
    for I := 1 to L do
    begin
      Ch := Source^;
      if Ch in ['a'..'z'] then
        Dec(Ch, 32);
      Dest^ := Ch;
      Inc(Source);
      Inc(Dest);
    end;
  end;

end;

initialization
  myQueue := TQueue<TRec>.Create;
  CriticalSection := TCriticalSection.Create;

finalization
  myQueue.Free;
  CriticalSection.Free;


end.

