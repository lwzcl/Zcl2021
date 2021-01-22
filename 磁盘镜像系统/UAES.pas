(**************************************************************)
(*    Advanced Encryption Standard (AES)    *)
(*    Interface Unit v1.3    *)
(*    *)
(*    Copyright (c) 2002 Jorlen Young    *)
(*    *)
(* ˵����    *)
(*    ���� ElASE.pas ��Ԫ��װ    *)
(*    *)
(*    ����һ�� AES �����㷨�ı�׼�ӿڡ�    *)
(* ����ʾ����    *)
(* if not EncryptStream(src, key, TStream(Dest), keybit) then *)
(*   showmessage('encrypt error');    *)
(*    *)
(* if not DecryptStream(src, key, TStream(Dest), keybit) then *)
(*   showmessage('encrypt error');    *)
(*    *)
(* *** һ��Ҫ��Dest����TStream(Dest) ***    *)
(* ========================================================== *)
(*    *)
(*   ֧�� 128 / 192 / 256 λ���ܳ�    *)
(*   Ĭ������°��� 128 λ�ܳײ���    *)
(*    *)
(**************************************************************)
unit UAES;
interface
{$IFDEF VER210}
  {$WARN IMPLICIT_STRING_CAST OFF} //�رվ���
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
   mov  esi,edx    //����edxֵ�������������ַ����ĵ�ַ
   mov  edi,eax    //����ԭ�ַ���
   mov  edx,[eax-4]  //����ַ�������
   test edx,edx    //��鳤��
   je   @@Exit    {Length(S) = 0}
   mov  ecx,edx    //���泤��
   Push ecx
   shl  edx,1
   mov  eax,esi
   {$IFDEF VER210}
   movzx ecx, word ptr [edi-12] {��Ҫ����CodePage}
   {$ENDIF}
   call System.@LStrSetLength //�����´�����
   mov  eax,esi    //���ַ�����ַ
   Call UniqueString  //����һ��Ψһ�����ַ�������λ����eax��
   Pop   ecx
  @@SetHex:
   xor  edx,edx    //���edx
   mov  dl, [edi]    //Str�ַ����ַ�
   mov  ebx,edx    //���浱ǰ���ַ�
   shr  edx,4    //����4�ֽڣ��õ���8λ
   mov  dl,byte ptr[edx+@@HexChar] //ת�����ַ�
   mov  [eax],dl    //���ַ������뵽�½����д��
   and  ebx,$0F    //��õ�8λ
   mov  dl,byte ptr[ebx+@@HexChar] //ת�����ַ�
   inc  eax    //�ƶ�һ���ֽ�,��ŵ�λ
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
  test eax,eax //Ϊ�մ�
  jz   @@Exit
  mov  edi,eax
  mov  esi,edx
  mov  edx,[eax-4]
  test edx,edx
  je   @@Exit
  mov  ecx,edx
  push ecx
  shr  edx,1
  mov  eax,esi //��ʼ�����ַ���
  {$IFDEF VER210}
  movzx ecx, word ptr [edi-12] {��Ҫ����CodePage}
  {$ENDIF}
  call System.@LStrSetLength //�����´�����
  mov  eax,esi    //���ַ�����ַ
  Call UniqueString  //����һ��Ψһ�����ַ�������λ����eax��
  Pop   ecx
  xor  ebx,ebx
  xor  esi,esi
@@CharFromHex:
  xor  edx,edx
  mov  dl, [edi]    //Str�ַ����ַ�
  cmp  dl, '0'  //�鿴�Ƿ���0��f֮����ַ�
  JB   @@Exit   //С��0���˳�
  cmp  dl,'9'   //С��=9
  ja  @@DoChar//CompOkNum
  sub  dl,'0'
  jmp  @@DoConvert
@@DoChar:
  //��ת�ɴ�д�ַ�
  and  dl,$DF
  cmp  dl,'F'
  ja   @@Exit  //����F�˳�
  add  dl,10
  sub  dl,'A'
@@DoConvert: //ת��
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
{  --  �ַ������ܺ��� Ĭ�ϰ��� 128 λ�ܳ׼��� --  }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(SS, 0, AESKey128, DS);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(SS, 0, AESKey192, DS);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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
{  --  �ַ������ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey128, DS);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey192, DS);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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
{ �����ܺ���, default keybit: 128bit }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(Src, 0, AESKey128, Dest);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(Src, 0, AESKey192, Dest);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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
{ �����ܺ���, default keybit: 128bit }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(Src, Src.Size - Src.Position,
   AESKey128, Dest);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(Src, Src.Size - Src.Position,
   AESKey192, Dest);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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
{  --  �ļ����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   EncryptAESStreamECB(SFS, 0, AESKey128, DFS);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   EncryptAESStreamECB(SFS, 0, AESKey192, DFS);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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
{  --  �ļ����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }
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
   {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
   if KeyBit = kb128 then
   begin
   FillChar(AESKey128, SizeOf(AESKey128), 0 );
   Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
   DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey128, DFS);
   end;
   {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
   if KeyBit = kb192 then
   begin
   FillChar(AESKey192, SizeOf(AESKey192), 0 );
   Move(PAnsiChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
   DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey192, DFS);
   end;
   {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
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

