object DM_XS: TDM_XS
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 412
  Width = 416
  object ADC_XS: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Zcl5201314;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=lwkjdb;Data Source=119.45.20.230;U' +
      'se Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;' +
      'Workstation ID=DESKTOP-5AK1BSL;Use Encryption for Data=False;Tag' +
      ' with column collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 16
  end
  object DataSource_XS: TDataSource
    Tag = 1
    DataSet = FDQuery1
    Left = 336
    Top = 48
  end
  object ADQ_PJ: TADOQuery
    Active = True
    Connection = ADC_XS
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from PjInfo')
    Left = 24
    Top = 96
  end
  object DataSource_PJ: TDataSource
    DataSet = ADQ_PJ
    Left = 104
    Top = 96
  end
  object DataSource_CW: TDataSource
    DataSet = FDQ_Cw
    Left = 96
    Top = 168
  end
  object ADQ_user: TADOQuery
    Active = True
    Connection = ADC_XS
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM UserInfo ')
    Left = 32
    Top = 240
  end
  object DataSource_kehu: TDataSource
    DataSet = FDQ_kehu
    Left = 352
    Top = 176
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=119.45.20.230'
      'User_Name=sa'
      'Password=Zcl5201314'
      'ApplicationName=Architect'
      'Workstation=DESKTOP-TAHU1I3'
      'MARS=yes'
      'Database=lwkjdb'
      'DriverID=MSSQL')
    Connected = True
    LoginPrompt = False
    Left = 232
    Top = 40
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM XiaoShouInfo')
    Left = 232
    Top = 104
  end
  object FDQ_kehu: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM KuInfo')
    Left = 360
    Top = 136
  end
  object FDQ_hdd: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from HDDType')
    Left = 232
    Top = 176
  end
  object FDQ_Cw: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT * FROM XiaoShouInfo WHERE xs_EndTime is not null and xs_j' +
        'iezhangTime is not null and xs_jiekeuantype is not null and xs_j' +
        'iekuanren is not NULL')
    Left = 32
    Top = 160
  end
  object FDQ_cg: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM cginfo WHERE cg_jiezhangdate  is NULL')
    Left = 176
    Top = 256
  end
  object DataSource_cg: TDataSource
    DataSet = FDQ_cg
    Left = 296
    Top = 264
  end
  object FDQ_cgUser: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM cg_users')
    Left = 120
    Top = 344
  end
  object DataSource_cg_User: TDataSource
    DataSet = FDQ_cgUser
    Left = 232
    Top = 339
  end
end
