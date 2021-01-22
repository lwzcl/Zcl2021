unit UMyThread;

interface

uses
  System.Classes, Umain, XLSSheetData5, XLSReadWriteII5, Vcl.ComCtrls,
  cxProgressBar, Vcl.Dialogs;

type
  MyThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    function myxlsread(filename, filepath, fileext: string; index: Integer; start: Boolean;XLS: TXLSReadWriteII5): string;
    function MakeFileList(Path, FileExt: string): TStringList;
    procedure mystart();
    procedure startdemo(ListView1: TListView; cxProgressBar1: TcxProgressBar);
    procedure ClearIDList;
    procedure jiexi(files: TStringList);
    procedure AddIDList;
  end;

type
  TRec = record
    filename: string;
    filepath: string;
  end;

implementation

uses
  System.SysUtils, Vcl.Forms, System.StrUtils, Generics.Collections, Xc12Utils5;

var
  myQueue: TQueue<TRec>;

procedure MyThread.AddIDList;
var
  i: Integer;
  ShellItem: PShellItem;
  tmp: string;
  rec: TRec;
begin
  for i := 0 to myQueue.Count - 1 do
  begin
    ShellItem := New(PShellItem);
    rec := myQueue.Dequeue;
    ShellItem.ID := i;
    ShellItem.UserName := rec.filename;
    ShellItem.TypeName := rec.filepath;
    FIDList.Add(ShellItem);

  end
end;

procedure MyThread.ClearIDList;
var                              //删除结构体和设置List
  I: Integer;
begin
  for I := 0 to FIDList.Count - 1 do
  begin
    Dispose(PShellItem(FIDList[I]));
  end;
  FIDList.Clear;

end;

procedure MyThread.Execute;
var
  files: TStringList;

begin
  { Place thread code here }
  if True then
    if not DirectoryExists(main.StatusBar1.Panels[2].Text + '\蓝网数据恢复') then
    begin
      ForceDirectories(main.StatusBar1.Panels[2].Text + '\蓝网数据恢复');
    end;
  Main.ListView1.Items.Clear;
  ClearIDList;
  files := TStringList.Create;
  files.Clear;
  files.BeginUpdate;
  files := MakeFileList(main.StatusBar1.Panels[2].Text, main.ComboBox1.Text);
  main.StatusBar1.Panels[1].Text := '一共有' + IntToStr(files.Count - 1) + '个文件';
  jiexi(files);
  files.EndUpdate;
  files.Free;
  AddIDList;
  Main.ListView1.Items.Count := FIDList.Count;
  //mystart();
end;

procedure MyThread.jiexi(files: TStringList);
var
  I: Int64;
  filename, tmpfilename, outfilepath, fileex: string;
  rec: TRec;
  start: Boolean;
  XLS: TXLSReadWriteII5;
begin
  outfilepath := main.StatusBar1.Panels[2].Text + '\蓝网数据恢复';
  fileex := main.ComboBox1.Text;
  start := main.Check_name.Checked;
  main.cxProgressBar1.Properties.Max := files.Count - 1;
  XLS:= TXLSReadWriteII5.Create(nil);
  files.Sort;
  for I := 0 to files.Count - 1 do
  begin
    filename := files[I];
    tmpfilename := myxlsread(filename, outfilepath, fileex, I, start,xls);
    if tmpfilename <> '' then
    begin
      rec.filename := Trim(tmpfilename);
      rec.filepath := filename;
      myQueue.Enqueue(rec);
    end;
    main.cxProgressBar1.Position := I;
  end;
end;

function MyThread.MakeFileList(Path, FileExt: string): TStringList;
var
  sch: TSearchrec;
begin
  Result := TStringlist.Create;
  if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
    Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
    Result.Clear;
    exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then
        Continue;
      if DirectoryExists(Path + sch.Name) then
      begin
        Result.AddStrings(MakeFileList(Path + sch.Name, FileExt));
      end
      else
      begin
        if (UpperCase(extractfileext(Path + sch.Name)) = UpperCase(FileExt)) or (FileExt = '.*') then
          Result.Add(Path + sch.Name);
      end;
    until FindNext(sch) <> 0;
    FindClose(sch);
  end

end;

procedure MyThread.mystart;
begin

  startdemo(main.ListView1, main.cxProgressBar1);
end;

function MyThread.myxlsread(filename, filepath, fileext: string; index: Integer; start: Boolean;XLS: TXLSReadWriteII5): string;
var
  tmp, tmpfile, ok: string;
  tmp2:string;

begin
  try
    //XLS := TXLSReadWriteII5.Create(nil);
    XLS.Clear();
    XLS.Filename := filename;
    XLS.Read;
    tmp := XLS.sheets[0].asstring[0, 0];
    tmp2 := XLS.Sheets[0].AsString[0,1];
    if tmp <> '' then
    begin
      if start = True then
      begin
        if FileExists(filepath + '\' + Trim(tmp) + fileext) then
        begin
          tmpfile := filepath + '\' + Trim(tmp) + IntToStr(index) + fileext;
          XLS.SaveToFile(tmpfile);
        end;

        XLS.SaveToFile(filepath + '\' + Trim(tmp) + fileext);
      end;
      Result := Trim(tmp);
    end
    else
    begin
      tmp := 'tmp' + IntToStr(index);
      if start = True then
      begin
        tmpfile := filepath + '\' + Trim(tmp) + fileext;
        XLS.SaveToFile(tmpfile);
      end;

      Result := Trim(tmp);
    end;

  except
    on E: Exception do
      DeleteFile(filename);

  end;

end;

procedure MyThread.startdemo(ListView1: TListView; cxProgressBar1: TcxProgressBar);
var
  files: TStringList;
  I: Int64;
  filename, outfilepath, fileex: string;
  tmpfilename: string;
  start: Boolean;
  XLS: TXLSReadWriteII5;
begin

  try
    ListView1.Items.Clear;
    files := TStringList.Create;
    files.Clear;
    files.BeginUpdate;
    outfilepath := main.StatusBar1.Panels[2].Text + '\蓝网数据恢复';
    fileex := main.ComboBox1.Text;
    start := main.Check_name.Checked;
    files := MakeFileList(main.StatusBar1.Panels[2].Text, main.ComboBox1.Text);
    cxProgressBar1.Properties.Max := (files.Count - 1);
    main.StatusBar1.Panels[1].Text := '一共有' + IntToStr(files.Count - 1) + '个文件';
    XLS:= TXLSReadWriteII5.Create(nil);
    for I := 0 to files.Count - 1 do
    begin
      filename := files[I];
      try
        tmpfilename := myxlsread(filename, outfilepath, fileex, I, start,XLS);
        if tmpfilename <> '' then
        begin
          with ListView1.items.add do
          begin
            caption := IntToStr(I);
            subitems.add(tmpfilename);
            subitems.add(filename);
          end;
        end;

      except
        on E: Exception do
          continue;
      end;
      cxProgressBar1.Position := I;
    end;

  finally

    files.EndUpdate;
    files.Free;
    FreeOnTerminate := True;
  end;

end;

initialization
  myQueue := TQueue<TRec>.Create;

finalization
  myQueue.Free;

end.

