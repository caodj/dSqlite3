{$ALIGN OFF}      // Because of #pragma pack(push, 1)
{$MINENUMSIZE 4}
unit CRT;

interface
   uses MSVCRT;
function malloc(size: size_t): Pointer; cdecl;
function localtime(const tod: ptime_t): ptm; cdecl;
function memset(s: Pointer; c: Integer; n: size_t): Pointer; cdecl;
function strncmp(const s1, s2: PChar; n: size_t): Integer; cdecl;
procedure free(ptr: Pointer); cdecl;
function realloc(ptr: Pointer; size: size_t): Pointer; cdecl;
function memmove(s1: Pointer; const s2: Pointer; n: size_t): Pointer; cdecl;
function memcmp(const s1, s2: Pointer; n: size_t): Integer; cdecl;
function memcpy(s1: Pointer; const s2: Pointer; n: size_t): Pointer; cdecl;
function strchr(const s: PChar; c: Integer): PChar; cdecl;
function floor(x: Double): Double; cdecl;
procedure abort; cdecl;
procedure longjmp(env: jmp_buf; val: Integer); cdecl;
function setjmp(env: jmp_buf):Integer;cdecl;
function pow(x, y: Double): Double; cdecl;
function time(tod: ptime_t): time_t; cdecl;
function __ftol():Integer; cdecl;
implementation


function malloc(size: size_t): Pointer; cdecl;
begin
  Result:= _malloc(size)
end;

function localtime(const tod: ptime_t): ptm; cdecl;
begin
  Result:=_localtime(tod);
end;

function memset(s: Pointer; c: Integer; n: size_t): Pointer; cdecl;
begin
  Result := _memset(s,c,n);
end;

function strncmp(const s1, s2: PChar; n: size_t): Integer; cdecl;
begin
  Result := strncmp(s1,s2,n);
end;

procedure free(ptr: Pointer); cdecl;
begin
  _free(ptr);
end;

function realloc(ptr: Pointer; size: size_t): Pointer; cdecl;
begin
  Result :=_realloc(ptr,size);
end;

function memmove(s1: Pointer; const s2: Pointer; n: size_t): Pointer; cdecl;
begin
  Result := _memmove(s1,s2,n);
end;

function memcmp(const s1, s2: Pointer; n: size_t): Integer; cdecl;
begin
  Result := _memcmp(s1,s2,n);
end;  

function memcpy(s1: Pointer; const s2: Pointer; n: size_t): Pointer; cdecl;
begin
  Result := _memcpy(s1,s2,n);
end;

function strchr(const s: PChar; c: Integer): PChar; cdecl;
begin
  Result := _strchr(s,c)
end;

function floor(x: Double): Double; cdecl;
begin
  Result := _floor(x);
end;

procedure abort; cdecl;
begin
  _abort;
end;
procedure longjmp(env: jmp_buf; val: Integer); cdecl;
begin
 _longjmp(env,val);
end;

function setjmp(env: jmp_buf):Integer;cdecl;
begin
 Result := _setjmp(env);
end;

function pow(x, y: Double): Double; cdecl;
begin
  Result := _pow(x,y)
end;

function time(tod: ptime_t): time_t; cdecl;
begin
  Result :=_time(tod);
end;
function __ftol():Integer; cdecl;
begin
  Result :=_ftol
end;  
end.
