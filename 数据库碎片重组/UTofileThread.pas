unit UTofileThread;

interface

uses
  System.Classes , Umain,Winapi.Windows;

type
  ToFile_Thread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;

  public
      procedure ToFiledata();
  end;

implementation

procedure ToFile_Thread.Execute;
begin
  { Place thread code here }
end;

procedure ToFile_Thread.ToFiledata;


begin

end;

end.
