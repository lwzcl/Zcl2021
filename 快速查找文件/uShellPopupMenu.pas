unit uShellPopupMenu;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils
  , System.Win.ComObj, Winapi.ShlObj, Winapi.ActiveX;




function DisplayContextMenu(const Handle: THandle; const FileName: string; Pos: TPoint): Boolean;


implementation

//uses uMain.SearchNTFS;

type
  TUnicodePath = array[0..MAX_PATH - 1] of WideChar;

const
  ShenPathSeparator = '\';

Function String2PWideChar(const s: String): PWideChar;
begin
  if s = '' then
  begin
    result:= nil;
    exit;
  end;
  result:= AllocMem((Length(s) + 1) * sizeOf(widechar));
  StringToWidechar(s, result, Length(s) * sizeOf(widechar) + 1);
end;

function PidlFree(var IdList: PItemIdList): Boolean;
var
  Malloc: IMalloc;
begin
  Result := False;
  if IdList = nil then
    Result := True
  else
  begin
    if Succeeded(SHGetMalloc(Malloc)) and (Malloc.DidAlloc(IdList) > 0) then
    begin
      Malloc.Free(IdList);
      IdList := nil;
      Result := True;
    end;
  end;
end;

function MenuCallback(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  ContextMenu2: IContextMenu2;
begin
  case Msg of
    WM_CREATE:
      begin
        ContextMenu2 := IContextMenu2(PCreateStruct(lParam).lpCreateParams);
        SetWindowLong(Wnd, GWL_USERDATA, NativeInt(ContextMenu2));
        Result := DefWindowProc(Wnd, Msg, wParam, lParam);
      end;
    WM_INITMENUPOPUP:
      begin
        ContextMenu2 := IContextMenu2(GetWindowLong(Wnd, GWL_USERDATA));
        ContextMenu2.HandleMenuMsg(Msg, wParam, lParam);
        Result := 0;
      end;
    WM_DRAWITEM, WM_MEASUREITEM:
      begin
        ContextMenu2 := IContextMenu2(GetWindowLong(Wnd, GWL_USERDATA));
        ContextMenu2.HandleMenuMsg(Msg, wParam, lParam);
        Result := 1;
      end;
  else
    Result := DefWindowProc(Wnd, Msg, wParam, lParam);
  end;
end;

function CreateMenuCallbackWnd(const ContextMenu: IContextMenu2): HWND;
const
  IcmCallbackWnd = 'ICMCALLBACKWND';
var
  WndClass: TWndClass;
begin
  FillChar(WndClass, SizeOf(WndClass), #0);
  WndClass.lpszClassName := PChar(IcmCallbackWnd);
  WndClass.lpfnWndProc := @MenuCallback;
  WndClass.hInstance := HInstance;
  Winapi.Windows.RegisterClass(WndClass);
  Result := CreateWindow(IcmCallbackWnd, IcmCallbackWnd, WS_POPUPWINDOW, 0, 0, 0, 0, 0, 0, HInstance, Pointer(ContextMenu));
end;

function DisplayContextMenuPidl(const Handle: HWND; const Folder: IShellFolder; Item: PItemIdList; Pos: TPoint): Boolean;
var
  Cmd: Cardinal;
  ContextMenu: IContextMenu;
  ContextMenu2: IContextMenu2;
  Hm: HMENU;
  CommandInfo: TCMInvokeCommandInfo;
  CallbackWindow: HWND;
begin
  Result := False;
  if (Item = nil) or (Folder = nil) then
    Exit;
  Folder.GetUIObjectOf(Handle, 1, Item, IID_IContextMenu, nil, Pointer(ContextMenu));

  if ContextMenu <> nil then
  begin
    Hm := CreatePopupMenu;
    if Hm <> 0 then
    begin
      if Succeeded(ContextMenu.QueryContextMenu(Hm, 0, 1, $7FFF, CMF_EXPLORE)) then
      begin                                 // + MF_POPUP
        //InsertMenu(Hm, 0, MF_BYPOSITION+MF_POPUP, FMenu.Handle, '¡¾´ò¿ªÎ»ÖÃ¡¿');

        CallbackWindow := 0;
        if Succeeded(ContextMenu.QueryInterface(IContextMenu2, ContextMenu2)) then begin
          CallbackWindow := CreateMenuCallbackWnd(ContextMenu2);
        end;

        ClientToScreen(Handle, Pos);
        Cmd := Cardinal(TrackPopupMenu(Hm, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON or TPM_RETURNCMD, Pos.X, Pos.Y, 0, CallbackWindow, nil));

        if Cmd <> 0 then
        begin
          FillChar(CommandInfo, SizeOf(CommandInfo), #0);
          CommandInfo.cbSize := SizeOf(TCMInvokeCommandInfo);
          CommandInfo.hwnd := Handle;
          CommandInfo.lpVerb := MakeIntResourceA(Cmd - 1);
          CommandInfo.nShow := SW_SHOWNORMAL;
          Result := Succeeded(ContextMenu.InvokeCommand(CommandInfo));
        end;

        if CallbackWindow <> 0 then
          DestroyWindow(CallbackWindow);
      end;
      DestroyMenu(Hm);
    end;
  end;
end;

function PathAddSeparator(const Path: string): string;
begin
  Result := Path;
  if (Length(Path) = 0) or (AnsiLastChar(Path) <> ShenPathSeparator) then
    Result := Path + ShenPathSeparator;
end;

function DriveToPidlBind(const DriveName: string; out Folder: IShellFolder): PItemIdList;
var
  Attr: ULONG;
  Eaten: ULONG;
  DesktopFolder: IShellFolder;
  Drives: PItemIdList;
  Path: TUnicodePath;
begin
  Result := nil;
  if Succeeded(SHGetDesktopFolder(DesktopFolder)) then
  begin
    if Succeeded(SHGetSpecialFolderLocation(0, CSIDL_DRIVES, Drives)) then
    begin
      if Succeeded(DesktopFolder.BindToObject(Drives, nil, IID_IShellFolder, Pointer(Folder))) then
      begin
        MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, PAnsiChar(PathAddSeparator(DriveName)), -1, Path, MAX_PATH);

        if Failed(Folder.ParseDisplayName(0, nil, Path, Eaten, Result, Attr)) then
          Folder := nil;
      end;
    end;
    PidlFree(Drives);
  end;
end;

function PathToPidlBind(const FileName: string; out Folder: IShellFolder): PItemIdList;
var
  Attr, Eaten: ULONG;
  PathIdList: PItemIdList;
  DesktopFolder: IShellFolder;
  Path, ItemName: pwidechar;
  s1,s2: string;
begin
  Result := nil;

  s1:= ExtractFilePath(FileName);
  s2:= ExtractFileName(FileName);
  Path:= String2PWideChar(s1);
  ItemName:= String2PWideChar(s2);

  if Succeeded(SHGetDesktopFolder(DesktopFolder)) then
  begin
    if Succeeded(DesktopFolder.ParseDisplayName(0, nil, Path, Eaten, PathIdList, Attr)) then
    begin
      if Succeeded(DesktopFolder.BindToObject(PathIdList, nil, IID_IShellFolder, Pointer(Folder))) then
      begin
        if Failed(Folder.ParseDisplayName(0, nil, ItemName, Eaten, Result, Attr)) then
        begin
          Folder := nil;
          Result := DriveToPidlBind(FileName, Folder);
        end;
      end;
      PidlFree(PathIdList);
    end
    else
      Result := DriveToPidlBind(FileName, Folder);
  end;

  FreeMem(Path);
  FreeMem(ItemName);
end;

function DisplayContextMenu(const Handle: Thandle; const FileName: string; Pos: TPoint): Boolean;
var
  ItemIdList: PItemIdList;
  Folder: IShellFolder;
begin
  Result := False;
  ItemIdList := PathToPidlBind(FileName, Folder);

  if ItemIdList <> nil then
  begin
    Result := DisplayContextMenuPidl(Handle, Folder, ItemIdList, Pos);
    PidlFree(ItemIdList);
  end;
end;

end.
