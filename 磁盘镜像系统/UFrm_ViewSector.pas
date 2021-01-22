unit UFrm_ViewSector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.ComCtrls;

type
  TFrm_ViewSector = class(TForm)
    StringGrid1: TStringGrid;
    StatusBar1: TStatusBar;
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure StringGrid1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    startsector : LongInt;
     nsectors : LongInt;
    driver:pchar;
   bytepersectors:integer;
   s,n:LONG64;
   seca,secb:array of integer;
   function BytesToGrid(startsector,nsectors: LONG64):Boolean;
  public
    { Public declarations }
    procedure OnFocusChange;
    property mystartsector: LongInt read startsector write startsector;
    property mynsectors: LongInt read nsectors write nsectors;
  end;

var
  ColOld: Integer = 1;
  RowOld: Integer = 1;
  CellKeyPress: Integer;
  CharSellsCount: integer = 17;
  hdevicehandle: thandle;
  Frm_ViewSector: TFrm_ViewSector;

implementation

{$R *.dfm}

  uses
  uFrmMain;

function TFrm_ViewSector.BytesToGrid(startsector, nsectors: LONG64): Boolean;
var
  i,j,k:Integer;
  c: Char;
  fbuf:pchar;
begin
   n:=nsectors;
   s:=startsector;
   setlength(seca,n*bytepersectors);
   setlength(secb,n*bytepersectors);
   StatusBar1.Panels[1].Text := '';
   hDeviceHandle := CreateFile(driver, GENERIC_ALL, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,0, 0);
   if (hDeviceHandle<> INVALID_HANDLE_VALUE) then
   begin
   fbuf:=allocmem(n*bytepersectors);
   FileSeek(hDevicehandle,s*bytepersectors,0);
    if FileRead(hDevicehandle,fbuf[0],n*bytepersectors)<>n*bytepersectors then
           raise exception.create('�����̴���!');
    stringgrid1.Rowcount:=n*32+1;
    for i:=0 to ((n*bytepersectors) div 16)-1 do
        StringGrid1.Cells[0,i+1] := IntToHex(i*16,2)+':';
    for i:=0 to ((n*bytepersectors) div 16)-1 do
    for j:=1 to 16 do
      begin
      seca[j-1+16*i]:=integer(fbuf[j-1+16*i]);
      secb[j-1+16*i]:=seca[j-1+16*i];
      end;
    for i:=0 to ((n*bytepersectors) div 16)-1 do begin
    StringGrid1.Cells[0,i+1] := IntToHex(i*16,4)+':';
    for j:=1 to 16 do begin
      K := seca[j-1+16*i];
      StringGrid1.Cells[j,i+1]:=format('%.2x',[integer(fbuf[j-1+16*i])]);
      C :=chr(k);
      if c<' ' then c:='.';
      StringGrid1.Cells[j+17,i+1] := c;

    end;
    StatusBar1.Panels[1].Text := Format('�߼����� '+'�����'+'�� %D ����������'+inttostr(n)+'������',[s]);
   end;
   freemem(fbuf);
   closehandle(hDeviceHandle);

  end;
end;

procedure TFrm_ViewSector.FormCreate(Sender: TObject);
var
i:integer;
begin
   startsector:=0;
   mynsectors:=1;
   bytepersectors:=512;
   with StringGrid1 do begin
    ColWidths[0] := 50;
    for i := 17 to 33 do begin
      TabStops[i] := False;
      ColWidths[i] := 11;
    end;
    for i := 1 to 16 do Cells[i,0] := IntToHex(i-1,02);
    for i := 18 to 33 do Cells[i,0] := IntToHex(i-18,1);
    Cells[0,0] := 'ƫ��';
 end;
end;

procedure TFrm_ViewSector.FormShow(Sender: TObject);
begin
    driver :=   PWideChar(Form2.lbl_Yuan_prot.Caption) ;
    BytesToGrid(0,1);
end;

procedure TFrm_ViewSector.OnFocusChange;
var
  I: Integer;
  C: Char;
begin
  I := ColOld-1+(RowOld-1)*16;
  with StringGrid1 do
    if Length(Cells[ColOld,RowOld])>2 then begin
      Cells[ColOld,RowOld] := IntToHex(seca[i],2);
    end else
    try
      secb[i] := StrToInt('$'+Cells[ColOld,RowOld]);
      C := Chr(secb[i]);
      if c<' ' then c:='.';
      Cells[ColOld+17,RowOld] := C;
    except; end;
end;

procedure TFrm_ViewSector.StringGrid1Exit(Sender: TObject);
begin
with StringGrid1 do
    if Col<16 then
      Col := Col+1
    else begin
      Col := 1; Row := Row+1;
    end;
  OnFocusChange;
end;

procedure TFrm_ViewSector.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  S: String;
  L: Integer;
begin
  with StringGrid1 do begin
    S := Cells[ColOld,RowOld];
    L := Length(S);
    case L of
      0: Cells[ColOld,RowOld] := '00';
      1: Cells[ColOld,RowOld] := '0'+S;
    end;
  end;
  ColOld := ACol;
  RowOld := ARow;

end;

procedure TFrm_ViewSector.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if Key<>#8 then begin
    Key := UpCase(Key);
    if not (Key in ['0'..'9','A'..'F']) then Key := #0 else
    with StringGrid1 do
      if CellKeyPress>1 then begin
        if Length(Cells[Col,Row])>1 then begin
          if (Col+1+CharSellsCount)<ColCount then begin
            Col := Col+1;
            CellKeyPress := 1;
          end else begin
            if (Row+1)<RowCount then begin
              Col := 1; Row := Row+1;
              CellKeyPress := 1;
            end else Key := #0;
          end;
        end;
      end else Inc(CellKeyPress);
  end;
  //if Key<>#0 then StatusBar1.Panels[1].Text := Format('�޸��߼����� '+'�Լ�����'+'�� %D ����');
end;

procedure TFrm_ViewSector.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ACol > 16 then
    CanSelect := False;
    CellKeyPress := 0;
    OnFocusChange;
end;

end.

