unit UmycheckThread;

interface

uses

  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, Winapi.ShellAPI, Vcl.Dialogs;

type
  mycheckThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;

  end;

implementation
 uses
 UFrmCheck;
{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure mycheckThread.UpdateCaption;
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

{ mycheckThread }

procedure mycheckThread.Execute;
begin
  { Place thread code here }
  FrmCheck.Start;
end;


end.
