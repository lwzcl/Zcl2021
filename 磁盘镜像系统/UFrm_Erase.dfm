object Frm_Erase: TFrm_Erase
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25968#25454#23433#20840#38144#27585
  ClientHeight = 96
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 729
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 3
      Height = 13
    end
    object Label2: TLabel
      Left = 249
      Top = 16
      Width = 3
      Height = 13
    end
    object Label3: TLabel
      Left = 553
      Top = 16
      Width = 3
      Height = 13
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 401
    Height = 47
    Align = alLeft
    TabOrder = 1
    object cxProgressBar1: TcxProgressBar
      Left = 1
      Top = 1
      Align = alClient
      TabOrder = 0
      Width = 399
    end
  end
  object Panel3: TPanel
    Left = 401
    Top = 49
    Width = 328
    Height = 47
    Align = alClient
    TabOrder = 2
    object Button1: TButton
      Left = 32
      Top = 6
      Width = 75
      Height = 25
      Action = act_start
      TabOrder = 0
    end
    object Button2: TButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Action = act_counter
      TabOrder = 1
    end
    object Button3: TButton
      Left = 128
      Top = 6
      Width = 75
      Height = 25
      Action = act_stop
      TabOrder = 2
    end
  end
  object ActionList1: TActionList
    Left = 64
    Top = 48
    object act_start: TAction
      Caption = #24320#22987
      OnExecute = act_startExecute
    end
    object act_stop: TAction
      Caption = #26242#20572
      OnExecute = act_stopExecute
    end
    object act_counter: TAction
      Caption = #32487#32493
      OnExecute = act_counterExecute
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 264
    Top = 57
  end
end
