(**************************************************************)
(*    Advanced Encryption Standard (AES)    *)
(*    Interface Unit v1.3    *)
(*    *)
(*    Copyright (c) 2002 Jorlen Young    *)
(*    *)
(* 说明：    *)
(*    基于 ElASE.pas 单元封装    *)
(*    *)
(*    这是一个 AES 加密算法的标准接口。    *)
(* 调用示例：    *)
(* if not EncryptStream(src, key, TStream(Dest), keybit) then *)
(*   showmessage('encrypt error');    *)
(*    *)
(* if not DecryptStream(src, key, TStream(Dest), keybit) then *)
(*   showmessage('encrypt error');    *)
(*    *)
(* *** 一定要对Dest进行TStream(Dest) ***    *)
(* ========================================================== *)
(*    *)
(*   支持 128 / 192 / 256 位的密匙    *)
(*   默认情况下按照 128 位密匙操作    *)
(*    *)
(**************************************************************)
unit UAES;
interface
{$IFDEF VER210}
  {$WARN IMPLICIT_STRING_CAST OFF} //关闭警告
  {$WARN IMPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}
uses
  SysUtils, Classes, Math, ElAES;
const
  SDestStreamNotCreated = 'Dest stream not created.';
  SEncryptStreamError = 'Encrypt stream error.';
  SDecryptStreamError = 'Decrypt stream error.';
type
  TKeyBit = (kb128, kb192, kb256);
function StrToHex(Const str: AnsiString): AnsiString;
function HexToStr(const Str: AnsiString): AnsiString;
function EncryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
function DecryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
function EncryptStream(Src: TStream; Key: AnsiString;
  var Dest: TStream; KeyBit: TKeyBit = kb128): Boolean;
function DecryptStream(Src: TStream; Key: AnsiString;
  var Dest: TStream; KeyBit: TKeyBit = kb128): Boolean;
procedure EncryptFile(SourceFile, DestFile: String;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
procedure DecryptFile(SourceFile, DestFile: String;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
implementation
function StrToHex(Const str: Ansistring): Ansistring;
asm
   push ebx
   push esi
   push edi
   test eax,eax
   jz   @@Exit
   mov  esi,edx    //保存edx值，用来产生新字符串的地址
   mov  edi,eax    //保存原字符串
   mov  edx,[eax-4]  //获得字符串长度
   test edx,edx    //检查长度
   je   @@Exit    {Length(S) = 0}
   mov  ecx,edx    //保存长度
   Push ecx
   shl  edx,1
   mov  eax,esi
   {$IFDEF VER210}
   movzx ecx, word ptr [edi-12] {需要设置CodePage}
   {$ENDIF}
   call System.@LStrSetLength //设置新串长度
   mov  eax,esi    //新字符串地址
   Call UniqueString  //产生一个唯一的新字符串，串位置在eax中
   Pop   ecx
  @@SetHex:
   xor  edx,edx    //清空edx
   mov  dl, [edi]    //Str字符串字符
   mov  ebx,edx    //保存当前的字符
   shr  edx,4    //右移4字节，得到高8位
   mov  dl,byte ptr[edx+@@HexChar] //转换成字符
   mov  [eax],dl    //将字符串输入到新建串中存放
   and  ebx,$0F    //获得低8位
   mov  dl,byte ptr[ebx+@@HexChar] //转换成字符
   inc  eax    //移动一个字节,存放低位
   mov  [eax],dl
   inc  edi
   inc  eax
   loop @@SetHex
  @@Exit:
   pop  edi
   pop  esi
   pop  ebx
   ret
  @@HexChar: db '0123456789ABCDEF'
end;
function HexToStr(const Str: AnsiString): AnsiString;
asm
  push ebx
  push edi
  push esi
  test eax,eax //为空串
  jz   @@Exit
  mov  edi,eax
  mov  esi,edx
  mov  edx,[eax-4]
  test edx,edx
  je   @@Exit
  mov  ecx,edx
  push ecx
  shr  edx,1
  mov  eax,esi //开始构造字符串
  {$IFDEF VER210}
  movzx ecx, word ptr [edi-12] {需要设置CodePage}
  {$ENDIF}
  call System.@LStrSetLength //设置新串长度
  mov  eax,esi    //新字符串地址
  Call UniqueString  //产生一个唯一的新字符串，串位置在eax中
  Pop   ecx
  xor  ebx,ebx
  xor  esi,esi
@@CharFromHex:
  xor  edx,edx
  mov  dl, [edi]    //Str字符串字符
  cmp  dl, '0'  //查看是否在0到f之间的字符
  JB   @@Exit   //小于0，退出
  cmp  dl,'9'   //小于=9
  ja  @@DoChar//CompOkNum
  sub  dl,'0'
  jmp  @@DoConvert
@@DoChar:
  //先转成大写字符
  and  dl,$DF
  cmp  dl,'F'
  ja   @@Exit  //大于F退出
  add  dl,10
  sub  dl,'A'
@@DoConvert: //转化
  inc  ebx
  cmp  ebx,2
  je   @@Num1
  xor  esi,esi
  shl  edx,4
  mov  esi,edx
  jmp  @@Num2
@@Num1:
  add  esi,edx
  mov  edx,esi
  mov  [eax],dl
  xor  ebx,ebx
  inc  eax
@@Num2:
  dec  ecx
  inc  edi
  test ecx,ecx
  jnz  @@CharFromHex
@@Exit:
  pop  esi
  pop  edi
  pop  ebx
end;
{  --  字符串加密函数 默认按照 128 位密匙加密 --  }
function EncryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
var
  {$IFDEF VER210}
  SS,DS: TMemoryStream;
  {$ELSE}
  SS, DS: TStringStream;
  {$ENDIF}
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
  st: AnsiString;
begin
  Result := '';
  {$IFDEF VER210}
   ss := TMemoryStream.Create;
   SS.WriteBuffer(PAnsiChar(Value)^,Length(Value));
   DS := TMemoryStream.Create;
  {$ELSE}
   SS := TStringStream.Create(Value);
   DS := TStringStream.Create('');
  {$ENDIF}
  try
   Size := SS.Size;
   DS.WriteBuffer(Size, SizeOf(Size));
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(SS, 0, AESKey128, DS);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(SS, 0, AESKey192, DS);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   EncryptAESStreamECB(SS, 0, AESKey256, DS);
   end;
   {$IFDEF VER210}
   SetLength(st,Ds.Size);
   DS.Position := 0;
   DS.ReadBuffer(PAnsiChar(st)^,DS.Size);
   Result := StrToHex(st);
   {$ELSE}
   Result := StrToHex(DS.DataString);
   {$ENDIF}
  finally
   SS.Free;
   DS.Free;
  end;
end;
{  --  字符串解密函数 默认按照 128 位密匙解密 --  }
function DecryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
var
  SS, DS: TStringStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  Result := '';
  SS := TStringStream.Create(HexToStr(Value));
  DS := TStringStream.Create('');
  try
   Size := SS.Size;
   SS.ReadBuffer(Size, SizeOf(Size));
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey128, DS);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey192, DS);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey256, DS);
   end;
   Result := DS.DataString;
  finally
   SS.Free;
   DS.Free;
  end;
end;
{ 流加密函数, default keybit: 128bit }
function EncryptStream(Src: TStream; Key: AnsiString;
  var Dest: TStream; KeyBit: TKeyBit = kb128): Boolean;
var
  Count: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  if Dest = nil then
  begin
   raise Exception.Create(SDestStreamNotCreated);
   Result:= False;
   Exit;
  end;
  try
   Src.Position:= 0;
   Count:= Src.Size;
   Dest.Write(Count, SizeOf(Count));
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(Src, 0, AESKey128, Dest);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(Src, 0, AESKey192, Dest);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   EncryptAESStreamECB(Src, 0, AESKey256, Dest);
   end;
   Result := True;
  except
   raise Exception.Create(SEncryptStreamError);
   Result:= False;
  end;
end;
{ 流解密函数, default keybit: 128bit }
function DecryptStream(Src: TStream; Key: AnsiString;
  var Dest: TStream; KeyBit: TKeyBit = kb128): Boolean;
var
  Count, OutPos: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  if Dest = nil then
  begin
   raise Exception.Create(SDestStreamNotCreated);
   Result:= False;
   Exit;
  end;
  try
   Src.Position:= 0;
   OutPos:= Dest.Position;
   Src.ReadBuffer(Count, SizeOf(Count));
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(Src, Src.Size - Src.Position,
   AESKey128, Dest);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(Src, Src.Size - Src.Position,
   AESKey192, Dest);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   DecryptAESStreamECB(Src, Src.Size - Src.Position,
   AESKey256, Dest);
   end;
   Dest.Size := OutPos + Count;
   Dest.Position := OutPos;
   Result := True;
  except
   raise Exception.Create(SDecryptStreamError);
   Result:= False;
  end;
end;
{  --  文件加密函数 默认按照 128 位密匙解密 --  }
procedure EncryptFile(SourceFile, DestFile: String;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
   DFS := TFileStream.Create(DestFile, fmCreate);
   try
   Size := SFS.Size;
   DFS.WriteBuffer(Size, SizeOf(Size));
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(SFS, 0, AESKey128, DFS);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(SFS, 0, AESKey192, DFS);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   EncryptAESStreamECB(SFS, 0, AESKey256, DFS);
   end;
   finally
   DFS.Free;
   end;
  finally
   SFS.Free;
  end;
end;
{  --  文件解密函数 默认按照 128 位密匙解密 --  }
procedure DecryptFile(SourceFile, DestFile: String;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
   SFS.ReadBuffer(Size, SizeOf(Size));
   DFS := TFileStream.Create(DestFile, fmCreate);
   try
   {  --  128 位密匙最大长度为 16 个字符 --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey128, DFS);
   end;
   {  --  192 位密匙最大长度为 24 个字符 --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey192, DFS);
   end;
   {  --  256 位密匙最大长度为 32 个字符 --  }
   if KeyBit = kb256 then
   begin
   FillChar(AESKey256, SizeOf(AESKey256), 0 );
   Move(PAnsiChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
   DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey256, DFS);
   end;
   DFS.Size := Size;
   finally
   DFS.Free;
   end;
  finally
   SFS.Free;
  end;
end;
end.

