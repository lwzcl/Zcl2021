object Frm_kehu_find: TFrm_kehu_find
  Left = 0
  Top = 0
  Caption = #23458#25143#20449#24687
  ClientHeight = 391
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 871
    Height = 391
    Align = alClient
    TabOrder = 0
    object cxGrid1: TcxGrid
      Left = 1
      Top = 66
      Width = 869
      Height = 324
      Align = alClient
      PopupMenu = PopupMenu1
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnCellClick = cxGrid1DBTableView1CellClick
        DataController.DataSource = DM_XS.DataSource_kehu
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Kind = skCount
            Column = cxGrid1DBTableView1Ku_Name
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsSelection.CellSelect = False
        OptionsView.CellAutoHeight = True
        OptionsView.DataRowHeight = 28
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 30
        object cxGrid1DBTableView1Ku_Name: TcxGridDBColumn
          Caption = #23458#25143#22995#21517
          DataBinding.FieldName = 'Ku_Name'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          FooterAlignmentHorz = taCenter
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
        end
        object cxGrid1DBTableView1Ku_GongS: TcxGridDBColumn
          Caption = #20844#21496#21517#31216
          DataBinding.FieldName = 'Ku_GongS'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
        end
        object cxGrid1DBTableView1Ku_Tie: TcxGridDBColumn
          Caption = #32852#31995#30005#35805
          DataBinding.FieldName = 'Ku_Tie'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
        end
        object cxGrid1DBTableView1Ku_DateTime: TcxGridDBColumn
          Caption = #30331#24405#26085#26399
          DataBinding.FieldName = 'Ku_DateTime'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 869
      Height = 65
      Align = alTop
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 248
    object N3: TMenuItem
      Caption = #28155#21152
      OnClick = N3Click
    end
    object N1: TMenuItem
      Caption = #20462#25913
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #21024#38500
      OnClick = N2Click
    end
  end
end
