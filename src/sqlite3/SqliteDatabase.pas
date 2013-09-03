unit SqliteDatabase;

interface
uses
  SysUtils,
  SQLite3;
type
  TQueryResultFun = function (ColumnCount: Integer; ColumnValues,
  ColumnNames: PPointer;pdata: Pointer):Boolean of object;

  TQueryResult  = record
    resultFun: TQueryResultFun;
    resultData: Pointer;
  end;

  TsqliteDataBase = class
  private
    Fdb: TSQLiteDB;
    FdataBaseName: string;
    FIsConnect: Boolean;
    pErrMsg: PChar;  
    FErrorMsg: array[0..255] of Char;
    function Geterror: string;
    function TableExeistsCallBack(ColumnCount: Integer; ColumnValues, ColumnNames: PPointer;pdata: Pointer):Boolean;
  public
    function OpenDatabase(const fileName: string): Boolean;
    function CloseDataBase: Boolean;
    function TableExists(const tableName: string;var isExists:Boolean): Boolean;
    function Exec_Sql(const sqlStr: string): Boolean;
    function Exec_Query(const sqlStr: string;r: TQueryResult): Boolean;
    function Exec_AddOrInsert(const tblName,fieldsName,fieldsValue: string):Boolean;
    function GetErrorStr(const errCode: Integer): string;
    constructor Create;
    destructor Destroy; override;
    property dataBaseName: string read FdataBaseName;
    property error: string read Geterror;
    property IsConnect: Boolean read FIsConnect;  
  end;
implementation


function Callback(UserData: Pointer; ColumnCount: Integer; ColumnValues,
  ColumnNames: PPointer): Integer; cdecl;
var t: TQueryResult;
begin
  t:= TQueryResult(UserData^);
  if t.resultFun(ColumnCount, ColumnValues,ColumnNames,t.resultData) then
   Result := 0
  else
   Result := 1;
end;

function TsqliteDataBase.CloseDataBase: Boolean;
begin
 Result := sqlite3_close(Fdb) = SQLITE_OK;
 if Result then
 FIsConnect := False;
end;

function TsqliteDataBase.Exec_Query(const sqlStr: string;r: TQueryResult):
    Boolean;
begin
  Result := sqlite3_exec(fdb, PChar(sqlStr), Callback, @r, pErrMsg) =SQLITE_OK;
end;

function TsqliteDataBase.Exec_Sql(const sqlStr: string): Boolean;
begin
  Result := sqlite3_exec(fdb, PChar(sqlStr), nil, nil, pErrMsg) =SQLITE_OK;
end;

function TsqliteDataBase.Geterror: string;
begin
  Result := pErrMsg;
end;

function TsqliteDataBase.OpenDatabase(const fileName: string): Boolean;
var r: Integer;
begin
  r := sqlite3_open(PChar(fileName), Fdb) ;
  Result := r = SQLITE_OK ;
  if Result  then
  begin
    FDataBaseName:= fileName;
    FIsConnect := True;
  end else
  begin
    StrCopy(pErrMsg,PChar(SQLiteErrorStr(r)))
  end;
end;

function TsqliteDataBase.TableExists(const tableName: string;var isExists:Boolean): Boolean;
var
  sql: string;
  t: TQueryResult;
  Recordcount: Integer;
begin
  Recordcount:=0;
  sql := 'select [sql] from sqlite_master where [type] = ''table'' and lower(name) = '''
    +  lowercase(TableName) + ''' ';
  t.resultFun:= TableExeistsCallBack;
  t.resultData:=@Recordcount;
  Result := Exec_Query(sql,t);
  isExists:= (Recordcount > 0);
end;
constructor TsqliteDataBase.Create;
begin
  pErrMsg:=FErrorMsg;
end;

destructor TsqliteDataBase.Destroy;
begin
  if FIsConnect then
  CloseDataBase;
end;

function TsqliteDataBase.GetErrorStr(const errCode: Integer): string;
begin
  Result := SQLiteErrorStr(errCode);
end;

function TsqliteDataBase.TableExeistsCallBack(ColumnCount: Integer;
  ColumnValues, ColumnNames: PPointer;pdata: Pointer): Boolean;
begin
  pinteger(pdata)^:= ColumnCount;
  Result := true;
end;

function TsqliteDataBase.Exec_AddOrInsert(const tblName, fieldsName,
  fieldsValue: string): Boolean;
const
  SQL_REPLACEINTO = 'REPLACE INTO %s (%s) VALUES (%s);';
var sql: string;
begin
  sql:= Format(SQL_REPLACEINTO,[tblName,fieldsName,fieldsValue]);
  Result := Exec_Sql(sql);
end;

end.
