unit utest;

interface
uses
  SysUtils,
  SqliteDatabase;
type
  Ttest = class
  private
    sqliteData: TsqliteDataBase;
    procedure  CreateEmployee;
    procedure updateEmployee(const name,d: string);
    procedure showAllEmployee;
    function AllEmployeeResult(ColumnCount: Integer; ColumnValues,
  ColumnNames: PPointer;pdata: Pointer):Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure test;
  end;

implementation

constructor Ttest.Create;
begin
  sqliteData:= TsqliteDataBase.Create;
end;

destructor Ttest.Destroy;
begin
  sqliteData.Free;
end;

{ Ttest }

procedure Ttest.CreateEmployee;
const create_sql =
'CREATE TABLE [employee] ( [emp_name] VARCHAR(16)  UNIQUE NOT NULL PRIMARY KEY, [emp_date] CHAR(10)  NOT NULL,[emp_is_Luck] INTEGER DEFAULT 1 NOT NULL,[emp_Photo_path] VARCHAR(255) DEFAULT '''' NOT NULL)';
begin
   if sqliteData.Exec_Sql(create_sql) then
   begin
     Writeln(sqliteData.error);
    end;
end;

procedure Ttest.test;
var r:Boolean;
begin
   if sqliteData.OpenDatabase('db.db') then
    Writeln(sqliteData.error);
    if not (sqliteData.TableExists('employee',r) ) then
    begin
      Writeln(sqliteData.error);
    end else
    begin
      if r then
        Writeln('table Exists')
      else
        begin
         Writeln('table not Exists');
         CreateEmployee;
        end;
    end;
     Writeln('----------------------------------');
    if sqliteData.Exec_Sql('BEGIN TRANSACTION') then
    begin
      updateEmployee('aaa','2010-01-01');
      updateEmployee('bbb','2010-01-01');
      showAllEmployee;
      updateEmployee('aaa','2013-01-01');
      updateEmployee('bbb','2013-01-01');
      showAllEmployee;
      sqliteData.Exec_Sql('COMMIT');
    end;
end;

procedure Ttest.updateEmployee(const name, d: string);
const
  CON_F_NAME = 'emp_name, emp_date';
  CON_F_VALUE = '%s,%s';
var
  fvalue: string;
begin
  fvalue := Format(CON_F_VALUE, [QuotedStr(name), QuotedStr(d)]);

  sqliteData.Exec_AddOrInsert('employee', CON_F_NAME, fvalue);
end;


procedure Ttest.showAllEmployee;
var t: TQueryResult;
begin
  t.resultFun:= AllEmployeeResult;
  t.resultData:= nil;
 sqliteData.Exec_Query('select * from employee',t)
end;

function Ttest.AllEmployeeResult(ColumnCount: Integer; ColumnValues,
  ColumnNames: PPointer; pdata: Pointer): Boolean;
var i: Integer;
    s1,s2: string;
begin
 for i:=0 to ColumnCount -1 do
 begin
   s1:= PChar(ColumnNames^);
   s2:= PChar(ColumnValues^);
   Writeln(Format('%d %s=%s',[i+1,s1,s2]));
   inc(ColumnValues);
   Inc(ColumnNames);
 end;
 Writeln('----------------------------------');
 Result :=true;
end;

end.
