object Frm_XSInfo: TFrm_XSInfo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Frm_XSInfo'
  ClientHeight = 503
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 411
    Height = 503
    Align = alClient
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 409
      Height = 446
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#20449#24687
        object Label10: TLabel
          Left = 7
          Top = 325
          Width = 60
          Height = 13
          Caption = #22791#27880#35828#26126#65306
        end
        object Label2: TLabel
          Left = 7
          Top = 53
          Width = 60
          Height = 13
          Caption = #20844#21496#21517#31216#65306
        end
        object Label3: TLabel
          Left = 7
          Top = 87
          Width = 60
          Height = 13
          Caption = #32852#31995#30005#35805#65306
        end
        object Label4: TLabel
          Left = 7
          Top = 121
          Width = 60
          Height = 13
          Caption = #30913#30424#21697#29260#65306
        end
        object Label5: TLabel
          Left = 7
          Top = 155
          Width = 60
          Height = 13
          Caption = #30913#30424#22411#21495#65306
        end
        object Label6: TLabel
          Left = 7
          Top = 189
          Width = 72
          Height = 13
          Caption = #30913#30424#24207#21015#21495#65306
        end
        object Label7: TLabel
          Left = 7
          Top = 223
          Width = 52
          Height = 13
          Caption = #30913#30424#23481#37327':'
        end
        object Label8: TLabel
          Left = 7
          Top = 257
          Width = 57
          Height = 13
          Caption = #36153'       '#29992#65306
        end
        object Label9: TLabel
          Left = 7
          Top = 291
          Width = 60
          Height = 13
          Caption = #36865#20462#26102#38388#65306
        end
        object Label1: TLabel
          Left = 7
          Top = 19
          Width = 60
          Height = 13
          Caption = #23458#25143#21517#31216#65306
        end
        object DBEdit1: TDBEdit
          Left = 77
          Top = 16
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_name'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 77
          Top = 50
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_gs'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 77
          Top = 84
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_til'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 2
        end
        object DBEdit5: TDBEdit
          Left = 77
          Top = 152
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_Moede'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 3
        end
        object DBEdit6: TDBEdit
          Left = 77
          Top = 186
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_Sn'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 4
        end
        object DBEdit7: TDBEdit
          Left = 77
          Top = 220
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_HddSzie'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 5
        end
        object DBEdit8: TDBEdit
          Left = 77
          Top = 254
          Width = 243
          Height = 21
          AutoSelect = False
          AutoSize = False
          DataField = 'xs_money'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 6
        end
        object DBMemo1: TDBMemo
          Left = 77
          Top = 315
          Width = 243
          Height = 101
          DataField = 'xs_BeiZhu'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 7
        end
        object DBComboBox1: TDBComboBox
          Left = 77
          Top = 111
          Width = 243
          Height = 21
          DataField = 'xs_hddType'
          DataSource = DM_XS.DataSource_XS
          TabOrder = 8
        end
        object scDBDateEdit1: TscDBDateEdit
          Left = 78
          Top = 288
          Width = 242
          Height = 21
          FluentUIOpaque = False
          UseFontColorToStyleColor = False
          ContentMarginLeft = 0
          ContentMarginRight = 0
          ContentMarginTop = 0
          ContentMarginBottom = 0
          CustomBackgroundImageNormalIndex = -1
          CustomBackgroundImageHotIndex = -1
          CustomBackgroundImageDisabledIndex = -1
          PromptTextColor = clNone
          HidePromptTextIfFocused = False
          WallpaperIndex = -1
          BlanksChar = ' '
          Date = 43994.000000000000000000
          TodayDefault = False
          CalendarWidth = 200
          CalendarHeight = 150
          CalendarFont.Charset = DEFAULT_CHARSET
          CalendarFont.Color = clWindowText
          CalendarFont.Height = -11
          CalendarFont.Name = 'Tahoma'
          CalendarFont.Style = []
          CalendarBoldDays = False
          CalendarBackgroundStyle = sccasPanel
          CalendarWallpaperIndex = -1
          FirstDayOfWeek = Sun
          WeekNumbers = False
          ShowToday = False
          LeftButton.ComboButton = False
          LeftButton.Enabled = True
          LeftButton.Visible = False
          LeftButton.ShowHint = False
          LeftButton.ShowEllipses = False
          LeftButton.StyleKind = scbsPushButton
          LeftButton.Width = 18
          LeftButton.ImageIndex = -1
          LeftButton.ImageHotIndex = -1
          LeftButton.ImagePressedIndex = -1
          LeftButton.RepeatClick = False
          LeftButton.RepeatClickInterval = 200
          LeftButton.CustomImageNormalIndex = -1
          LeftButton.CustomImageHotIndex = -1
          LeftButton.CustomImagePressedIndex = -1
          LeftButton.CustomImageDisabledIndex = -1
          RightButton.ComboButton = False
          RightButton.Enabled = True
          RightButton.Visible = True
          RightButton.ShowHint = False
          RightButton.ShowEllipses = True
          RightButton.StyleKind = scbsPushButton
          RightButton.Width = 18
          RightButton.ImageIndex = -1
          RightButton.ImageHotIndex = -1
          RightButton.ImagePressedIndex = -1
          RightButton.RepeatClick = False
          RightButton.RepeatClickInterval = 200
          RightButton.CustomImageNormalIndex = -1
          RightButton.CustomImageHotIndex = -1
          RightButton.CustomImagePressedIndex = -1
          RightButton.CustomImageDisabledIndex = -1
          Transparent = False
          BorderKind = scebFrame
          FrameColor = clBtnShadow
          FrameActiveColor = clHighlight
          MaxLength = 10
          TabOrder = 9
          AllowNullData = True
          DataField = 'xs_StartTime'
          DataSource = DM_XS.DataSource_XS
        end
        object cxButton1: TcxButton
          Left = 326
          Top = 18
          Width = 43
          Height = 17
          OptionsImage.Glyph.SourceDPI = 96
          OptionsImage.Glyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000021744558745469746C650046696E643B437573746F6D65723B46696E
            64437573746F6D65723B60483E400000033949444154785E858F6B4C5B751C86
            9F737A4AD78DB60C98208E592D0304A4607086391CA40E2F533F189CC6CC984D
            E3502B517497661787C816BC2CC445B32F6646925DBC1003C87481C52CEAC04B
            E622C9B8ADD1211B5236A0B4EBE9B9F42F1F1ADD17F5499E0FBFDF87277925FE
            41022C800C08C00412C97F1204D71F422007DEFD1240DEF8E25BB736EEEFE8DA
            DADA196978F393EE4736EEC86FD8F3917B4FDBC9CE5DEF9D5403077A3AFDBB3E
            5E01488DFBBF20094A5CD701AC6959EEF647D7792B33D3EC7CFFF358AD69949F
            73A6BBC4FAB5F9B6A54E3B7DDFFDFAD0702CD505D468AA6E721D72DDA6969AE6
            835F89C9D0BC383D302C5A0F1E17CF6E6F17DBDEEE16E39767C570704A1C3EDA
            27FCBB8F88A75E79BF1290FE9E00586DCEA5CF14E565135375A2AAC1F8F81423
            23630B06D14D8163898D92A29BB9F7EE3CEEB9B3B809480164499290F3BDBE1B
            AC298EBA8285C04C4465FE9A4A38AAA2C775742D8E55B1100E0EA09F6A22BD7F
            07B79C7D755DFBE6E2337B6B739F002C7241D9FD2DBED505B69C2C17B7AFCCA2
            ECB65C96DF98816E68C4350D4830F259334B5C2E446A0E59653E6EF214964B09
            3E04144556EC1B6A2A0B38716A948EDE21EA1E2CA27A8D97EEDEB3C4551D9B55
            E6D2C434C23E4E029933DFF690E648211A334C4091E3AA614973DAE8393D4686
            AF8A1303414A8B3D58AD16B2737258BC4861CEEE41280EEEF307D8B4AD1E132B
            33AAD90B24E4583C327EE1F710BE356EE67EE8A7BA6205A3C1CB44E7AF5E8C84
            67C7A6AF46F03EFD06983A429D4736624898748DCEB6009AC5919E9B08C7E407
            56952EE7F1DA12D4F01C473AFA183C37D0BAB0EF9B2B617DFD2AAF9BC90BBF40
            38C4C4D0203F9D9F98F87A70B2ADA97AD91C802BAFBCAEB1B8AA7EA8A8EA7991
            57F1E47076DEDAAD4006B0F8A5ED6D3B5F6FFDE0D26BFB1E13FB5E5E2DF66EA9
            101BFC2B7BEFF0657800AB04C8C0222015B00206100162805C7FA024E074D803
            F9EE427B665A267F4C07999C0A713138159B0E45DF4108F1AF02B617DA8AB4CF
            7FF48B63FDCF89437D0F8B9DC7CB44C3A14211387C97A8DDB24C53F86FC4CC95
            6B9F1EEBE82A3574D36E26121E5D3350A346D0D0FE8CABAA79FEFF02C6D1E6DF
            36034A72AA856438A9F1179FBB795CE19401350000000049454E44AE426082}
          TabOrder = 10
          OnClick = cxButton1Click
        end
        object cxButton2: TcxButton
          Left = 326
          Top = 52
          Width = 43
          Height = 17
          OptionsImage.Glyph.SourceDPI = 96
          OptionsImage.Glyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000030744558745469746C650044423B536F757263653B53746F723B6461
            7461736F757263653B44617461626173653B4164643B4E657722FBFACB000002
            8B49444154785E7DCE5168D56518C7F1EFFB3FEF71E8118732A9664AD344E782
            A4E8C2080BBD58811D8DD0C0180B73154A1122E1A54CD02B9D1769434548BA91
            290C4756A363CB226D93A00BBBB0CCCE6173B5ADE65C9EFDCFFFFF3ECFE3F042
            C641F681EFEDF3FC1C90F9AEE3CD2DD94CB43E72ACC0F429CC3589CAF510B418
            52B95949C2E54DFBBFEE06C4A631D3954FB7156EF4B4DBEDFE33F6EF6FDD3659
            EC351DBF6A776F74D9C8C0312B7EDB6EBF9E79DF7ADB5FFB01F066C6CC3CA61B
            5636BF0726A0092615D029E6D72D21B770112665EA1B1BF9E7E4A99780882A5E
            5221DCFB0B9F6B80081C8AA16814884787A8FC37089561240D008E2A918AA2E9
            04A13C02CC211DBFC264B193D16B1DFC79A19352A19BCA580909F2C8035E5361
            367E5E2DD9BA35D4AD5A0EF4659C7311A00F170409CC66EE138D9C1FF9999EA8
            977DA79FFFFF9313CF1580686FE75AF67CB6964852653696C9726B6298D62DBB
            D8F1C62E422AAF00D1CEB77693C48297205473991CBE7631B9154F1392409208
            A2C270F947924401FCEA856D00E6250D547335CBF8A2BF9B5B778631055523C8
            144948886361C781C629354352FDDEAB08D50CCF1F6343B4B5ECC44C0123D10A
            E974F9ADAB782CF702201C39FAF9CB7EF25EF2CDB5AEB3CDF54D2F52FB6413F3
            6A04E0C1A754624A777FC2503043119C1AC5F13E024625161C903BBCED99ED0B
            6A7C3E1BB1DC67DCCAC7D7ACCB5E9CF8C506E351170278EFC8BFB314C43877AA
            485C56540D09567080033C9005324034238068F3470D23BB3F7E7D7ACD55CE1F
            FF9BAF4E94160009A098597500E43F6CE0E2CD0F00E6BCDAB6CC7A7E7FD78E0D
            3C6B1B5B97185073EEFADB6C68598AE7D14862E1E8C12F01AC52D642477BEF46
            000DEE12A0C70F5D0607F701C8A46B6782959C4D0000000049454E44AE426082}
          TabOrder = 11
          OnClick = cxButton2Click
        end
      end
      object TabSheet2: TTabSheet
        Caption = #36130#21153#20449#24687
        ImageIndex = 1
        object Label11: TLabel
          Left = 32
          Top = 24
          Width = 60
          Height = 13
          Caption = #32467#26463#26102#38388#65306
        end
        object Label12: TLabel
          Left = 32
          Top = 64
          Width = 60
          Height = 13
          Caption = #32467#24080#26102#38388#65306
        end
        object Label13: TLabel
          Left = 32
          Top = 112
          Width = 48
          Height = 13
          Caption = #32467#27454#20154#65306
        end
        object Label14: TLabel
          Left = 32
          Top = 168
          Width = 60
          Height = 13
          Caption = #32467#27454#26041#24335#65306
        end
        object Label15: TLabel
          Left = 32
          Top = 220
          Width = 28
          Height = 13
          Caption = #29366#24577':'
        end
        object DBComboBox2: TDBComboBox
          Left = 98
          Top = 217
          Width = 201
          Height = 21
          DataField = 'xs_zhuangTai'
          DataSource = DM_XS.DataSource_XS
          DragMode = dmAutomatic
          DropDownCount = 2
          Items.Strings = (
            'True'
            'False')
          TabOrder = 0
        end
        object DBComboBox3: TDBComboBox
          Left = 98
          Top = 165
          Width = 201
          Height = 21
          DataField = 'xs_jiekeuantype'
          DataSource = DM_XS.DataSource_XS
          Items.Strings = (
            #29616#37329
            #23545#20844
            #24494#20449
            #25903#20184#23453
            #38134#34892#21345)
          TabOrder = 1
        end
        object DBComboBox4: TDBComboBox
          Left = 98
          Top = 109
          Width = 201
          Height = 21
          DataField = 'xs_jiekuanren'
          DataSource = DM_XS.DataSource_XS
          Items.Strings = (
            #24352#25165#26519
            #23395#22269#33521)
          TabOrder = 2
        end
        object scDBDateEdit2: TscDBDateEdit
          Left = 98
          Top = 21
          Width = 203
          Height = 21
          FluentUIOpaque = False
          UseFontColorToStyleColor = False
          ContentMarginLeft = 0
          ContentMarginRight = 0
          ContentMarginTop = 0
          ContentMarginBottom = 0
          CustomBackgroundImageNormalIndex = -1
          CustomBackgroundImageHotIndex = -1
          CustomBackgroundImageDisabledIndex = -1
          PromptTextColor = clNone
          HidePromptTextIfFocused = False
          WallpaperIndex = -1
          BlanksChar = ' '
          Date = 43998.000000000000000000
          TodayDefault = False
          CalendarWidth = 200
          CalendarHeight = 150
          CalendarFont.Charset = DEFAULT_CHARSET
          CalendarFont.Color = clWindowText
          CalendarFont.Height = -11
          CalendarFont.Name = 'Tahoma'
          CalendarFont.Style = []
          CalendarBoldDays = False
          CalendarBackgroundStyle = sccasPanel
          CalendarWallpaperIndex = -1
          FirstDayOfWeek = Sun
          WeekNumbers = False
          ShowToday = False
          LeftButton.ComboButton = False
          LeftButton.Enabled = True
          LeftButton.Visible = False
          LeftButton.ShowHint = False
          LeftButton.ShowEllipses = False
          LeftButton.StyleKind = scbsPushButton
          LeftButton.Width = 18
          LeftButton.ImageIndex = -1
          LeftButton.ImageHotIndex = -1
          LeftButton.ImagePressedIndex = -1
          LeftButton.RepeatClick = False
          LeftButton.RepeatClickInterval = 200
          LeftButton.CustomImageNormalIndex = -1
          LeftButton.CustomImageHotIndex = -1
          LeftButton.CustomImagePressedIndex = -1
          LeftButton.CustomImageDisabledIndex = -1
          RightButton.ComboButton = False
          RightButton.Enabled = True
          RightButton.Visible = True
          RightButton.ShowHint = False
          RightButton.ShowEllipses = True
          RightButton.StyleKind = scbsPushButton
          RightButton.Width = 18
          RightButton.ImageIndex = -1
          RightButton.ImageHotIndex = -1
          RightButton.ImagePressedIndex = -1
          RightButton.RepeatClick = False
          RightButton.RepeatClickInterval = 200
          RightButton.CustomImageNormalIndex = -1
          RightButton.CustomImageHotIndex = -1
          RightButton.CustomImagePressedIndex = -1
          RightButton.CustomImageDisabledIndex = -1
          Transparent = False
          BorderKind = scebFrame
          FrameColor = clBtnShadow
          FrameActiveColor = clHighlight
          AutoSelect = False
          HideSelection = False
          MaxLength = 10
          TabOrder = 3
          AllowNullData = False
          DataField = 'xs_EndTime'
          DataSource = DM_XS.DataSource_XS
        end
        object scDBDateEdit3: TscDBDateEdit
          Left = 98
          Top = 61
          Width = 203
          Height = 21
          FluentUIOpaque = False
          UseFontColorToStyleColor = False
          ContentMarginLeft = 0
          ContentMarginRight = 0
          ContentMarginTop = 0
          ContentMarginBottom = 0
          CustomBackgroundImageNormalIndex = -1
          CustomBackgroundImageHotIndex = -1
          CustomBackgroundImageDisabledIndex = -1
          PromptTextColor = clNone
          HidePromptTextIfFocused = False
          WallpaperIndex = -1
          BlanksChar = ' '
          TodayDefault = False
          CalendarWidth = 200
          CalendarHeight = 150
          CalendarFont.Charset = DEFAULT_CHARSET
          CalendarFont.Color = clWindowText
          CalendarFont.Height = -11
          CalendarFont.Name = 'Tahoma'
          CalendarFont.Style = []
          CalendarBoldDays = False
          CalendarBackgroundStyle = sccasPanel
          CalendarWallpaperIndex = -1
          FirstDayOfWeek = Sun
          WeekNumbers = False
          ShowToday = False
          LeftButton.ComboButton = False
          LeftButton.Enabled = True
          LeftButton.Visible = False
          LeftButton.ShowHint = False
          LeftButton.ShowEllipses = False
          LeftButton.StyleKind = scbsPushButton
          LeftButton.Width = 18
          LeftButton.ImageIndex = -1
          LeftButton.ImageHotIndex = -1
          LeftButton.ImagePressedIndex = -1
          LeftButton.RepeatClick = False
          LeftButton.RepeatClickInterval = 200
          LeftButton.CustomImageNormalIndex = -1
          LeftButton.CustomImageHotIndex = -1
          LeftButton.CustomImagePressedIndex = -1
          LeftButton.CustomImageDisabledIndex = -1
          RightButton.ComboButton = False
          RightButton.Enabled = True
          RightButton.Visible = True
          RightButton.ShowHint = False
          RightButton.ShowEllipses = True
          RightButton.StyleKind = scbsPushButton
          RightButton.Width = 18
          RightButton.ImageIndex = -1
          RightButton.ImageHotIndex = -1
          RightButton.ImagePressedIndex = -1
          RightButton.RepeatClick = False
          RightButton.RepeatClickInterval = 200
          RightButton.CustomImageNormalIndex = -1
          RightButton.CustomImageHotIndex = -1
          RightButton.CustomImagePressedIndex = -1
          RightButton.CustomImageDisabledIndex = -1
          Transparent = False
          BorderKind = scebFrame
          FrameColor = clBtnShadow
          FrameActiveColor = clHighlight
          MaxLength = 10
          TabOrder = 4
          AllowNullData = False
          DataField = 'xs_jiezhangTime'
          DataSource = DM_XS.DataSource_XS
        end
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 447
      Width = 409
      Height = 55
      Align = alBottom
      TabOrder = 1
      object Button2: TButton
        Left = 203
        Top = 14
        Width = 75
        Height = 25
        Caption = #25918#24323
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 81
        Top = 14
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 1
        OnClick = Button1Click
      end
    end
  end
end