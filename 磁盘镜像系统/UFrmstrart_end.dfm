object Frmstrart_end: TFrmstrart_end
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36873#25321#20301#32622
  ClientHeight = 262
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 35
    Width = 48
    Height = 13
    Caption = #21551#22987#25159#21306
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 48
    Height = 13
    Caption = #32467#26463#25159#21306
  end
  object edt_start: TEdit
    Left = 62
    Top = 32
    Width = 145
    Height = 21
    TabOrder = 0
  end
  object edt_end: TEdit
    Left = 63
    Top = 93
    Width = 145
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 39
    Top = 192
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 192
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
  end
  object dxSkinController2: TdxSkinController
    NativeStyle = False
    SkinName = 'Office2007Black'
    Left = 40
    Top = 128
  end
end
