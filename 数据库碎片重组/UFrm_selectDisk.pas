unit UFrm_selectDisk;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MiTeC_WinIOCTL, StdCtrls, ComCtrls, ExtCtrls, ImgList, MSI_Storage, MSI_Disk,
  MSI_Common, MSI_DeviceMonitor, MiTeC_CfgMgrSetupApi, System.ImageList,
  Winapi.TlHelp32;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    hddMode: string;
    hddSn: string;
    hddProt: string;
    hddSize: LONG64;
    procedure cmRefresh(Sender: TObject; Tree: TTreeView);
    procedure DeviceMonitorVolumeConnect(Sender: TObject; Drive: Char; Remote: Boolean);
  private
    Storage: TMiTeC_Storage;
    spid: TSPClassImageListData;
    Disk: TMiTeC_Disk;
    DeviceMonitor: TMiTeC_DeviceMonitor;
  end;

var
  Form1: TForm1;

implementation

uses
  MiTeC_StrUtils, MiTeC_Routines, MiTeC_Storage, shellapi, Umain;
{$R *.dfm}

{ TForm1 }

//var
//  hddMode: string;
//  hddSn: string;
//  hddProt: string;
//  hddSize: LONG64;

procedure TForm1.cmRefresh(Sender: TObject; Tree: TTreeView);
var
  rd, c, i, j, ii: Integer;
  n, r: TTreeNode;
  pi: PInteger;
  s, d: string;
  g: TGUID;
begin
  d := '';
  Tree.OnChange := nil;
  with Storage do
  try
    Screen.Cursor := crHourGlass;
    RefreshData;
    Tree.Items.BeginUpdate;
    try
      Tree.Items.Clear;
      c := PhysicalCount;
      for i := 0 to PhysicalCount - 1 do
        with Physical[i] do
        begin
          New(pi);
          pi^ := i;
          if Size > 0 then
            r := Tree.Items.AddChildObject(nil, Trim(Format('%s - %s (%d GB)', [Model, SerialNumber, Size div 1024 shr 20])), pi)
          else
            r := Tree.Items.AddChildObject(nil, Trim(Format('%s - %s', [Model, SerialNumber])), pi);
          g := GUID_DEVCLASS_DISKDRIVE;
          case DeviceType of
            FILE_DEVICE_CD_ROM, FILE_DEVICE_DVD:
              g := GUID_DEVCLASS_CDROM;
            FILE_DEVICE_TAPE:
              g := GUID_DEVCLASS_TAPEDRIVE;
            FILE_DEVICE_DISK:
              if Removable then
                g := GUID_DEVCLASS_FDC;
          end;
          SetupDiGetClassImageIndex(spid, g, ii);
          r.ImageIndex := ii;
          r.SelectedIndex := r.ImageIndex;
          for j := 0 to LogicalCount - 1 do
            with Logical[j] do
              if PhysicalIndex = i then
              begin
                d := d + Copy(drive, 1, 1);
                New(pi);
                pi^ := j;
                Disk.Drive := drive + ':';
                if Disk.Capacity = 0 then
                  n := Tree.Items.AddChildObject(r, Format('%s:', [drive]), pi)
                else
                begin
                  if not (DeviceType in [FILE_DEVICE_CD_ROM, FILE_DEVICE_DVD, FILE_DEVICE_TAPE, FILE_DEVICE_UNKNOWN]) and (Length(Layout) > 0) and (LayoutIndex > -1) then
                    n := Tree.Items.AddChildObject(r, Format('%s: (%s %s - %d GB)', [drive, GetPartitionType(Layout[LayoutIndex].Number, Layout[LayoutIndex].Typ), FileSystem, //GetPartitionSystem(Layout[LayoutIndex].Typ),
                      Layout[LayoutIndex].Length.QuadPart div 1024 shr 20]), pi)
                  else
                    n := Tree.Items.AddChildObject(r, Format('%s: (%s - %d GB)', [drive, Disk.FileSystem, Disk.Capacity div 1024 shr 20]), pi);
                end;
                g := GUID_DEVCLASS_VOLUME;
                SetupDiGetClassImageIndex(spid, g, ii);
                n.ImageIndex := ii;
                n.SelectedIndex := n.ImageIndex;
              end;
        end;

      new(pi);
      pi^ := -1;
      r := Tree.Items.AddChildObject(nil, 'Network drives', pi);
      g := GUID_DEVCLASS_DISKDRIVE;
      SetupDiGetClassImageIndex(spid, g, ii);
      r.ImageIndex := ii;
      r.SelectedIndex := r.ImageIndex;
      Disk.RefreshData;
      s := Disk.AvailableDisks;
      with Disk do
        for i := 1 to Length(s) do
        begin
          drive := Format('%s:\', [Copy(s, i, 1)]);
          if MediaType = dtRemote then
          begin
            d := d + Copy(drive, 1, 1);
            new(pi);
            pi^ := i;
            n := Tree.Items.AddChildObject(r, Format('%s (%s)', [drive, UNCPath]), pi);
            g := GUID_DEVCLASS_VOLUME;
            SetupDiGetClassImageIndex(spid, g, ii);
            n.ImageIndex := ii;
            n.SelectedIndex := n.ImageIndex;
          end;
        end;
      if r.Count = 0 then
        Tree.Items.Delete(r);

      new(pi);
      pi^ := -2;
      r := Tree.Items.AddChildObject(nil, 'Removable drives', pi);
      g := GUID_DEVCLASS_DISKDRIVE;
      SetupDiGetClassImageIndex(spid, g, ii);
      r.ImageIndex := ii;
      r.SelectedIndex := r.ImageIndex;
      with Disk do
        for i := 1 to Length(s) do
        begin
          drive := Format('%s:\', [Copy(s, i, 1)]);
          if (Pos(Copy(s, i, 1), d) = 0) and (MediaType = dtRemovable) then
          begin
            d := d + Copy(drive, 1, 1);
            new(pi);
            pi^ := i;
            n := Tree.Items.AddChildObject(r, Format('%s', [drive]), pi);
            g := GUID_DEVCLASS_VOLUME;
            SetupDiGetClassImageIndex(spid, g, ii);
            n.ImageIndex := ii;
            n.SelectedIndex := n.ImageIndex;
            Inc(rd);
          end;
        end;
      if r.Count = 0 then
        Tree.Items.Delete(r);

      new(pi);
      pi^ := -2;
      r := Tree.Items.AddChildObject(nil, 'Other drives', pi);
      g := GUID_DEVCLASS_DISKDRIVE;
      SetupDiGetClassImageIndex(spid, g, ii);
      r.ImageIndex := ii;
      r.SelectedIndex := r.ImageIndex;
      with Disk do
        for i := 1 to Length(s) do
        begin
          if Pos(Copy(s, i, 1), d) = 0 then
          begin
            drive := Format('%s:\', [Copy(s, i, 1)]);
            new(pi);
            pi^ := i;
            n := Tree.Items.AddChildObject(r, Format('%s', [drive]), pi);
            g := GUID_DEVCLASS_VOLUME;
            SetupDiGetClassImageIndex(spid, g, ii);
            n.ImageIndex := ii;
            n.SelectedIndex := n.ImageIndex;
          end;
        end;
      if r.Count = 0 then
        Tree.Items.Delete(r);

      Tree.FullExpand;
    finally
      Tree.Items.EndUpdate;
    end;
  finally
    Screen.Cursor := crDefault;
    //Caption := Format('�������ݻָ����� (%d physical, %d logical)', [PhysicalCount + rd, Length(s)]);
  end;
  Tree.Items[0].MakeVisible;
  Tree.OnChange := TreeView1Change;

end;

procedure TForm1.DeviceMonitorVolumeConnect(Sender: TObject; Drive: Char; Remote: Boolean);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Storage := TMiTeC_Storage.Create(Self);
  Disk := TMiTeC_Disk.Create(Self);
  DeviceMonitor := TMiTeC_DeviceMonitor.Create(Self);
  with DeviceMonitor do
  begin
    Active := True;
    CatchBluetooth := False;
    OnVolumeConnect := DeviceMonitorVolumeConnect;
    OnVolumeDisconnect := DeviceMonitorVolumeConnect;
  end;
  cmRefresh(nil, TreeView1);

end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  s: string;
begin

  if Assigned(Node) and Assigned(Node.Data) then
  begin
    if PInteger(Node.Data)^ < 0 then
      Exit;
    if Node.Level = 0 then
      with Storage.Physical[PInteger(Node.Data)^] do
      begin
        FMain.Ed_filepath.Text := Model;
        FMain.StatusBar1.Panels[0].Text := Model;
        FMain.StatusBar1.Panels[1].Text := SerialNumber;
        FMain.StatusBar1.Panels[5].Text := '\\.\PHYSICALDRIVE' + IntToStr(Device);
        FMain.StatusBar1.Panels[2].Text  := IntToStr(LengthInBytes div Geometry.BytesPerSector) ;
//        hddmode := Model;
//        hddsn := SerialNumber;
//        hddsize := LengthInBytes div Geometry.BytesPerSector;
//        hddprot := '\\.\PHYSICALDRIVE' + IntToStr(Device);


      end
    else
    begin
      if PInteger(Node.Parent.Data)^ < 0 then
        Disk.Drive := Copy(Disk.AvailableDisks, PInteger(Node.Data)^, 1) + ':'
      else
        Disk.Drive := Storage.Logical[PInteger(Node.Data)^].Drive + ':';

      FMain.Ed_filepath.Text := Disk.Drive;
        FMain.StatusBar1.Panels[0].Text := Disk.Drive;
      FMain.StatusBar1.Panels[1].Text := Disk.VolumeLabel;
      FMain.StatusBar1.Panels[5].Text := '\\.\' + Disk.Drive;
//      hddmode := Disk.Drive;
//      hddsn := Disk.VolumeLabel;
//      hddprot := '\\.\' + Disk.Drive;
      with Storage.Logical[PInteger(Node.Data)^] do
        if LayoutIndex > -1 then
        begin

          //hddsize := (Layout[LayoutIndex].Length.QuadPart div Geometry.BytesPerSector);
          FMain.StatusBar1.Panels[2].Text := IntToStr(Layout[LayoutIndex].Length.QuadPart div Geometry.BytesPerSector);

        end;

    end;
  end;

end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin

//  FMain.Ed_filepath.Text := hddMode;
//  FMain.StatusBar1.Panels[0].Text := hddMode;
//  FMain.StatusBar1.Panels[1].Text := hddSn;
//  FMain.StatusBar1.Panels[2].Text := hddSize.ToString;
//  FMain.StatusBar1.Panels[3].Text := hddProt;
//
  Close;

end;

end.

