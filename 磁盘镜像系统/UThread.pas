unit UThread;

interface

uses
  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, Winapi.ShellAPI, Vcl.Dialogs;

type
  Tword = class(TThread)
  private
    { Private declarations }
    jindu: PLONG64;
    state: Boolean;
  protected
    procedure Execute; override;
  public
    procedure myimgstart;
    property myState: Boolean read state write state;
    property myjindu: PLONG64 read jindu write jindu;
  end;

implementation
//

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure Tword.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ Tword }

uses
  uFrmMain, UFrmSTratr,UFrmstrart_end;

procedure Tword.Execute;
begin
  { Place thread code here }
  myimgstart();
end;

procedure Tword.myimgstart;
var
  Thddsize: LONG64;
  p: TBytes;
  index: LONG64;
  dataitem: Integer;
  starTime: TTime;
  endTime: TTime;
  endsize: LONG64;
  kedu: LONG64;
  Sdisk: THandle;
  tdisk: THandle;
  filestr: TFileStream;
  THDeviceHandle: THandleStream;
  SHDeviceHandle: THandleStream;
begin
  try

    dataitem := 0;
    index := Form2.StrarSec * 512;
    dataitem := 32768;
    SetLength(p, dataitem);
    state := False;
    endsize := Form2.EndSec * 512;
    if endsize <= 0 then
    begin
      ShowMessage('请用管理员权限运行此程序！');
      Exit
    end;
    kedu := (StrToInt64(Form2.lbl_yuan_szie.Caption) * 512) div 100;
    if Form2.myisHdd <> True then
    begin
      try
        Sdisk := CreateFile(PWideChar(Form2.lbl_Yuan_prot.Caption), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
          FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
        SHDeviceHandle := THandleStream.Create(Sdisk);
        tdisk := CreateFile(PWideChar(Form2.lbl_MuBiao_prot.Caption), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
          FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
        THDeviceHandle := THandleStream.Create(tdisk);
        starTime := Now();
        Form2.tmr_jishi.Enabled := True;
        FrmSTratr.Timer1.Enabled := True;
        while (index < endsize) do
        begin
          if state <> true then
          begin
//              Sdisk.ReadSector(index, p, dataitem);
//              tdisk.WriteSector(index, p, dataitem);
            SHDeviceHandle.Seek(index, soBeginning);
            SHDeviceHandle.Read(p, dataitem);
            THDeviceHandle.Seek(index, soBeginning);
            THDeviceHandle.Write(p, dataitem);
            index := index + dataitem;
              //FrmSTratr.cxProgressBar1.Position := Integer(index div kedu);
            jindu := @index;

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

    end
    else
    begin

      try
        filestr := TFileStream.Create(Form2.dxStatusBar1.Panels[3].Text, fmCreate, fmShareDenyNone);
        Sdisk := CreateFile(PWideChar(Form2.lbl_Yuan_prot.Caption), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
          FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
        SHDeviceHandle := THandleStream.Create(Sdisk);
        Form2.tmr_jishi.Enabled := True;
        FrmSTratr.Timer1.Enabled := True;
        while (index < endsize) do
        begin
          if state <> true then
          begin
            SHDeviceHandle.Seek(index, soBeginning);
            SHDeviceHandle.Read(p, dataitem);
            filestr.Write(p, dataitem);
//              tdisk.FileWritSector(filestr, index, p, dataitem);
            index := index + dataitem;
            myjindu := @index;
              //FrmSTratr.cxProgressBar1.Position := Integer(index div kedu);
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

    end;

  finally
    begin

      Form2.tmr_jishi.Enabled := False;
      FrmSTratr.timer1.Enabled := False;
      CloseHandle(Sdisk);
      CloseHandle(tdisk);
      THDeviceHandle.Free;
      SHDeviceHandle.Free;
      filestr.Free;
      FreeMemory(p);
      FrmSTratr.cxProgressBar1.Position := 100;

    end;

  end;

end;

end.

