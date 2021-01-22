unit uCheckered;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.Graphics, Winapi.Windows, Winapi.Messages;

type
  TSmall = class(TGraphicControl)
  private
    FPen: TPen;
    FBrush: TBrush;
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetColor(const Value: TColor);
  protected
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Color: TColor write SetColor;
    property OnClick;
  published
    procedure StyleChanged(Sender: TObject);
  end;

  TColls= array[0..100] of TSmall;

  TCheckered = class(TScrollingWinControl)
  private
    G: array of TColls;
    FBorderStyle: TBorderStyle;
    FOnSmallClick: TNotifyEvent;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetItem(Idx, Row: Integer): TSmall;
    function GetSmall(Index: Integer): TSmall;
    //procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC: Winapi.Windows.HDC); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure NewSmall(ACount: Cardinal);
    property Items[Idx, Row: Integer]: TSmall read GetItem;
    property OnSmallClick: TNotifyEvent read FOnSmallClick write FOnSmallClick;
    property Small[Index: Integer]: TSmall read GetSmall; default;
  published

  end;

implementation

constructor TSmall.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 8;
  Height := 8;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
end;

destructor TSmall.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TSmall.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  FPen.Width := MulDiv(FPen.Width, M, D);
  inherited;
end;

procedure TSmall.Paint;
var
  X, Y, W, H, S: Integer;
begin
  with Canvas do begin
    Pen := FPen;
    Brush := FBrush;
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    Rectangle(X, Y, X + W, Y + H);
  end;
end;

procedure TSmall.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TSmall.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TSmall.SetColor(const Value: TColor);
begin
  Self.FBrush.Color:= Value;
  Self.Invalidate;
end;

procedure TSmall.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;



{ TCheckered }

procedure TCheckered.NewSmall(ACount: Cardinal);   
var  
  Idx, R, A: Cardinal;
  ASmall: TSmall;

begin       
  if Length(G)> 0 then begin                                  
    for R :=High(G)downto Low(G)do     
    for Idx := High(TColls)downto Low(TColls)do begin 
      G[R][Idx].Free;  
      G[R][Idx]:= nil;
    end;     
  end;
  A:= 0;
  SetLength(G, ACount);
  for R := Low(G) to High(G)do     
  for Idx := Low(TColls) to High(TColls) do begin
    ASmall:= TSmall.Create(nil);
    ASmall.Parent:= Self;
    ASmall.Top := 1+ R * 9;
    ASmall.Left:= 1+ Idx * 9;
    ASmall.OnClick:= FOnSmallClick;
    G[R][Idx]:= ASmall;
    G[R][Idx].Tag:= A;
    Inc(A);
  end;
end;


constructor TCheckered.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks, csPannable, csGestures];
  AutoScroll := True;
  Width := 180;
  Height:= 40;
  FBorderStyle := bsSingle;
  FOnSmallClick:= nil;
end;


//procedure TCheckered.CMVisibleChanged(var Message: TMessage);
//begin
//  inherited;
////  if Visible then
////    UpdateScrollBars;
//end;

procedure TCheckered.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    FBorderStyle:= bsNone;
//    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
//    begin
//      Style := Style and not WS_BORDER;
//      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
//    end;
  end;
end; 

function TCheckered.GetItem(Idx, Row: Integer): TSmall;
begin
  Result:= G[Row][Idx];
end;

function TCheckered.GetSmall(Index: Integer): TSmall;
var
  Idx, Row: Integer;
begin
  Row:= Index div 100;
  Idx:= Index mod 100;
  Result:= G[Row][Idx];
end;

procedure TCheckered.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCheckered.WMNCHitTest(var Message: TWMNCHitTest);
begin
  DefaultHandler(Message);
end;

procedure TCheckered.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TCheckered.PaintWindow(DC: HDC);
begin
end;


end.
