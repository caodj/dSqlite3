program TestSqlLite;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  utest in 'utest.pas';
var test: Ttest;
begin
  test:= Ttest.Create;
  test.test;
  test.Free;
end.
