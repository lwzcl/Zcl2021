object Frm_Raid: TFrm_Raid
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Frm_Raid'
  ClientHeight = 312
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 312
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 16
    object Button1: TButton
      Left = 16
      Top = 42
      Width = 75
      Height = 25
      Action = act_Hdd_1
      TabOrder = 0
    end
    object Edit_1: TEdit
      Left = 97
      Top = 44
      Width = 312
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object Button2: TButton
      Left = 16
      Top = 82
      Width = 75
      Height = 25
      Action = act_Hdd_2
      TabOrder = 2
    end
    object Edit_2: TEdit
      Left = 97
      Top = 84
      Width = 312
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object Button3: TButton
      Left = 16
      Top = 122
      Width = 75
      Height = 25
      Action = act_Hdd_3
      TabOrder = 4
    end
    object Edit_3: TEdit
      Left = 97
      Top = 124
      Width = 312
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object Button4: TButton
      Left = 16
      Top = 162
      Width = 75
      Height = 25
      Action = act_Hdd_4
      TabOrder = 6
    end
    object Edit_4: TEdit
      Left = 97
      Top = 164
      Width = 312
      Height = 21
      ReadOnly = True
      TabOrder = 7
    end
    object Button5: TButton
      Left = 16
      Top = 202
      Width = 75
      Height = 25
      Action = act_Hdd_5
      TabOrder = 8
    end
    object Edit_5: TEdit
      Left = 97
      Top = 202
      Width = 312
      Height = 21
      ReadOnly = True
      TabOrder = 9
    end
    object But_start: TButton
      Left = 136
      Top = 248
      Width = 75
      Height = 25
      Action = act_start
      TabOrder = 10
    end
    object But_canle: TButton
      Left = 280
      Top = 248
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 11
    end
  end
  object ActionList1: TActionList
    Left = 32
    Top = 256
    object act_Hdd_1: TAction
      Caption = '1'
      OnExecute = act_Hdd_1Execute
    end
    object act_Hdd_2: TAction
      Caption = '2'
      OnExecute = act_Hdd_2Execute
    end
    object act_Hdd_3: TAction
      Caption = '3'
      OnExecute = act_Hdd_3Execute
    end
    object act_Hdd_4: TAction
      Caption = '4'
      OnExecute = act_Hdd_4Execute
    end
    object act_Hdd_5: TAction
      Caption = '5'
      OnExecute = act_Hdd_5Execute
    end
    object act_start: TAction
      Caption = #24320#22987
      OnExecute = act_startExecute
    end
  end
end
