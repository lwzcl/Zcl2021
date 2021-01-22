unit uMyGrid;

interface

uses
  Vcl.Grids, Data.DB, Vcl.Menus,  System.Types, System.Classes, Vcl.ImgList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, System.UITypes,
  Vcl.Graphics;


type

  TGridEvent = procedure(Sender: TObject; Index: UInt64) of object;


  TDataGrid = class(TStringGrid)
  private
    FClick: TGridEvent;
    procedure SetState(Index: Integer; const Value: Integer);
  published
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property State[Index: Integer]: Integer write SetState;  default;
    property OnSmallClick: TGridEvent read FClick write FClick;
  end;


implementation

uses
  System.SysUtils, Winapi.Windows, System.Variants;


{ TDataGrid }

constructor TDataGrid.Create(AOwner: TComponent);
begin
  inherited;
  FClick:= nil;

  Self.ScrollBars:= System.UITypes.TScrollStyle.ssBoth;

  Self.FixedCols:= 0;
  Self.FixedRows:= 0;

  Self.ColCount := 200;

  Self.DefaultColWidth := 8;
  Self.DefaultRowHeight:= 8;

  Self.GridLineWidth:= 1;

  Self.Options:=[goFixedVertLine
                ,goFixedHorzLine
                //,goVertLine
                //,goHorzLine
                ,goColSizing
                //,goRowSelect
                //,goDrawFocusSelected
                ,goThumbTracking
                ,goFixedHotTrack
                ];
end;


destructor TDataGrid.Destroy;
begin
  inherited;
end;

procedure TDataGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
begin
  if Self.Cells[ACol, ARow] = '1' then
    Self.Canvas.Brush.Color:= clLime
  else if Self.Cells[ACol, ARow] = '2' then
    Self.Canvas.Brush.Color:= clRed
  else if Self.Cells[ACol,ARow] ='3' then
  begin
  self.Canvas.Brush.Color := clGrayText;
  end
  else
    Self.Canvas.Brush.Color:= clWhite;

  Self.Canvas.Rectangle(ARect);

  Self.Canvas.Brush.Color:= clBlack;
  Self.Canvas.FrameRect(ARect);
end;

procedure TDataGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACoord: TGridCoord;
begin
  inherited;
  ACoord:= Self.MouseCoord(X, Y);
  if(ACoord.X>-1)or(ACoord.y>-1)then
  if Assigned(FClick)then begin
    FClick(Self, 100*ACoord.Y+ACoord.X);
  end;
end;


procedure TDataGrid.SetState(Index: Integer; const Value: Integer);
var
  Idx, Row: Integer;
begin
  Row:= Index div 200;
  Idx:= Index mod 200;
  Self.Cells[Idx, Row] := IntToStr(Value);
  //Self.Invalidate;
end;

end.
