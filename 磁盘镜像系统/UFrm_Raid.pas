unit UFrm_Raid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList;

type
  TFrm_Raid = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Edit_1: TEdit;
    Button2: TButton;
    Edit_2: TEdit;
    Button3: TButton;
    Edit_3: TEdit;
    Button4: TButton;
    Edit_4: TEdit;
    Button5: TButton;
    Edit_5: TEdit;
    But_start: TButton;
    But_canle: TButton;
    ActionList1: TActionList;
    act_Hdd_1: TAction;
    act_Hdd_2: TAction;
    act_Hdd_3: TAction;
    act_Hdd_4: TAction;
    act_Hdd_5: TAction;
    act_start: TAction;
    procedure act_Hdd_1Execute(Sender: TObject);
    procedure act_Hdd_2Execute(Sender: TObject);
    procedure act_Hdd_3Execute(Sender: TObject);
    procedure act_Hdd_4Execute(Sender: TObject);
    procedure act_Hdd_5Execute(Sender: TObject);
    procedure act_startExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Raid: TFrm_Raid;

implementation

{$R *.dfm}
uses
  UFrm_selectDisk;

procedure TFrm_Raid.act_Hdd_1Execute(Sender: TObject);
begin
  Form1 := TForm1.Create(Application);
  with Form1 do
  begin
    Form1.ShowModal;
    Self.Edit_1.Text := hddProt;
    Form1.Free;
  end;
end;

procedure TFrm_Raid.act_Hdd_2Execute(Sender: TObject);
begin
  Form1 := TForm1.Create(Application);
  with Form1 do
  begin
    Form1.ShowModal;
    Self.Edit_2.Text := hddProt;
    Form1.Free;
  end;

end;

procedure TFrm_Raid.act_Hdd_3Execute(Sender: TObject);
begin
  Form1 := TForm1.Create(Application);
  with Form1 do
  begin
    Form1.ShowModal;
    Self.Edit_3.Text := hddProt;
    Form1.Free;
  end;
end;

procedure TFrm_Raid.act_Hdd_4Execute(Sender: TObject);
begin
      Form1:= TForm1.Create(Application);
    with  Form1 do
    begin
       Form1.ShowModal;
       Self.Edit_4.Text := hddProt;
       Form1.Free;
    end;
end;

procedure TFrm_Raid.act_Hdd_5Execute(Sender: TObject);
begin
     Form1:= TForm1.Create(Application);
    with  Form1 do
    begin
       Form1.ShowModal;
       Self.Edit_5.Text := hddProt;
       Form1.Free;
    end;
end;

procedure TFrm_Raid.act_startExecute(Sender: TObject);
begin
     Application.MessageBox('这是阵列计算！','提示');
end;

end.

