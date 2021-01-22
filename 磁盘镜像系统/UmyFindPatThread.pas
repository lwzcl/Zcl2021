unit UmyFindPatThread;

interface

uses
  System.Classes, System.SysUtils;

type
  myFindPatThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure myfindpatstart();
  end;

implementation

uses
  uFrmMain, UdiskIo, UFrmFindPartition;
{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure myFindPatThread.UpdateCaption;
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

{ myFindPatThread }

procedure myFindPatThread.Execute;
begin
  { Place thread code here }
  myfindpatstart();
end;

procedure myFindPatThread.myfindpatstart;
//var
//disk : diskio;
begin
//   disk := diskio.Create(Form2.lbl_Yuan_prot.Caption);
//   disk.FindDiskP(StrToInt64(Form2.lbl_yuan_szie.Caption),512) ;
  FrmFindPartition.MyFindDiskP();

end;

end.

