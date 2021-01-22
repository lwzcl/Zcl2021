unit Ujixi;

interface
uses
System.Classes, Winapi.Windows, System.SysUtils,System.SyncObjs,Umain,Generics.Collections,Vcl.ComCtrls;

type
  Mydatabases_jixi = class
  private
    { private declarations }
    State: Boolean;
    jindu: PLONG64;
  protected

  public
   procedure jiexi (filename:string;mysize:LONG64);
   property myState: Boolean read state write state;
   property myjindu: PLONG64 read jindu write jindu;
   constructor Create; overload;
   procedure AddIDList();
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
 var
 myQueue: TQueue<TRec>;

{ Mydatabases_jixi }

procedure Mydatabases_jixi.AddIDList();
var
  i: Integer;

  tmp: string;
  rec: TRec;
begin
  try

    FMain.Ed_filepath.Text := '数据库文件解析中！';
    while True do
    begin
      if (myQueue.Count >0) then
      begin
        System.TMonitor.Enter(myQueue);
        rec := myQueue.Dequeue;
        System.TMonitor.Exit(myQueue);
        tmp := IntToStr(rec.index)+'-'+ IntToStr(rec.StartPage)+'页';
        FMain.Memo1.Lines.Add(tmp);
      end;
    end;
  finally
    FMain.Ed_filepath.Text := '己完成！！';
    FMain.Timer2.Enabled := False;

  end;
end;



constructor Mydatabases_jixi.Create;
begin

end;

procedure Mydatabases_jixi.jiexi(filename:string;mysize:LONG64);
var
  post, tmp: Int64;
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

      SetLength(p, 8192);
      hDeviceHandle := CreateFile(PWideChar(filename), GENERIC_ALL, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
      THDeviceHandle := THandleStream.Create(hDeviceHandle);
      post := 0;
      page := 0;
      FMain.Memo1.Lines.Append('数据库碎片扫描中！！！！！！！！！！！！！');
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
          TThread.Sleep(100);
          end;
        post := post + 8192;
        jindu := @post;
      end;
      FMain.Memo1.Lines.Append('数据库碎片扫描完毕！！！！！！！！！！！');

    except
      on E: Exception do
        FMain.Memo1.Lines.Append('数据库扫描出错！！！！！！！！！！！');

    end;

  finally
    THDeviceHandle.Free;
    CloseHandle(hDeviceHandle);
    FMain.PageControl1.ActivePageIndex := 2;
    //FreeMemory(p);

    FMain.Timer1.Enabled := False;

  end;

end;
 initialization
 myQueue := TQueue<TRec>.Create;

finalization
  myQueue.Free;


end.

