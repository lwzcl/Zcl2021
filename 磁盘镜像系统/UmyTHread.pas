unit UmyTHread;

interface

uses
  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils;

type
  myTHread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure GUIOK;
  public
    var
      itemdata: LONG64;
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure myTHread.UpdateCaption;
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

{ myTHread }
uses
  uFrmMain;

procedure myTHread.Execute;
begin
  { Place thread code here }
  GUIOK();
end;

procedure myTHread.GUIOK;
var
  tmp: LONG64;
begin

  while True do
  begin

    tmp := itemdata;
    if tmp <> 0 then
    begin
      Form2.StringGrid1.RowCount := tmp div 512 div 200;
      Sleep(100);
    end;

  end;

end;

end.

