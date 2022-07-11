unit InstructionSQLEntity;

interface

uses
  ClassRTTI;

type
  TInstructionSQLEntity = class
  private
    FoProperties: TClassRTTI;
    FSQLCreateTable: string;
    FsTabela: string;
    function GetSQLInsert: string;
    function GetSQLFindALL: string;
    function GetSQLFindID: string;
    { private declarations }
  protected
    { protected declarations }
    // Destined block for CreateTable
    function CommonString(const poString: string; const psConcat: string = ','): string;
    function GetFSQLCreateTable: string;
    function MakeFields: string;
    function MakePK: string;
    function MakeFK: string;
    // Destined block for Insert

  public
    { public declarations }
    constructor Create(const poClass: TClass);
    destructor Destroy; override;

    function SQLCreateColumn(const pnIndex: integer): string;

    property SQLCreateTable: string read GetFSQLCreateTable;
    property SQLInsert: string read GetSQLInsert;
    property SQLFindAll: string read GetSQLFindALL;
    property SQLFindID: string read GetSQLFindID;
    property Properties: TClassRTTI read FoProperties;
  end;

implementation

uses
  TypInfo, StrUtils, SysUtils;

const
  sCREATETABLE = 'CREATE TABLE %s (%s %s %s)';
  sCREATEFK =  ', CONSTRAINT %sFK%s FOREIGN KEY(%s) REFERENCES %s(%s)';
  sCREATEPK = ', CONSTRAINT %SPK PRIMARY KEY (%s)';
  sINSERT = 'INSERT INTO %s (%s) VALUES(%s);';
  sUPDATE = 'UPDATE %s SET %s where %s';
  sDELETE = 'DELETE FROM %s where %s';
  sCREATECOLUMN = 'ALTER TABLE %s ADD COLUMN IF NOT EXISTS %s %s;';
  sFIND = 'select %s from %s';
  sFINDID = 'select %s from %s where %s';

{ TInstructionSQLEntity<T> }

function TInstructionSQLEntity.CommonString(const poString: string; const psConcat: string): string;
begin
  Result := poString;

  if Result <> '' then
    Result := Result + Format('%s ', [psConcat]);
end;

constructor TInstructionSQLEntity.Create(const poClass: TClass);
begin
  FoProperties := TClassRTTI.Create(poClass);

  FsTabela := ifthen(FoProperties.Schema <> '', FoProperties.Schema + '.', '') + FoProperties.Table;
end;

destructor TInstructionSQLEntity.Destroy;
begin
  FoProperties.Free;
end;

function TInstructionSQLEntity.GetFSQLCreateTable: string;
var
  sFields: string;
  SPK: string;
  sFK: string;
begin
  if FSQLCreateTable <> '' then
    Exit(FSQLCreateTable);

  sFields := MakeFields;
//  sPK := MakePK;
  sFK := MakeFK;

  FSQLCreateTable := Format(sCREATETABLE, [FsTabela, sFields, sPK, sFK]);

  Result := FSQLCreateTable;
end;

function TInstructionSQLEntity.GetSQLFindALL: string;
var
  sFields: string;
  I: integer;
begin
  for I := 0 to Pred(FoProperties.Fields.Count) do
    sFields := CommonString(sFields) + FoProperties.Alias + '.' + FoProperties.Fields.Items[I].FieldNameBD;

  Result := Format(sFIND, [sFields, FoProperties.Table + ' ' + FoProperties.Alias]);
end;

function TInstructionSQLEntity.GetSQLFindID: string;
var
  sFields: string;
  sWhere: string;
  I: integer;
begin
  for I := 0 to Pred(FoProperties.Fields.Count) do
  begin
    sFields := CommonString(sFields) + FoProperties.Alias + '.' + FoProperties.Fields.Items[I].FieldNameBD;
    if FoProperties.Fields.Items[I].PK then
      sWhere := CommonString(sWhere, 'and') + Format(' %s.%s = :%s ', [FoProperties.Alias, FoProperties.Fields.Items[I].FieldNameBD, FoProperties.Fields.Items[I].FieldNameBD]);
  end;

  Result := Format(sFINDID, [sFields, FoProperties.Table + ' ' + FoProperties.Alias, sWhere])
end;

function TInstructionSQLEntity.GetSQLInsert: string;
var
  sValues: string;
  sFields: string;
  I: Integer;
begin
  for I := 0 to Pred(FoProperties.Fields.Count) do
  begin
    if not FoProperties.Fields.Items[I].AutoInc then
    begin
      sValues := CommonString(sValues) + Format(':%s', [FoProperties.Fields.Items[I].FieldNameBD]);
      sFields := CommonString(sFields) + FoProperties.Fields.Items[I].FieldNameBD;
    end;
  end;

  Result := Format(sINSERT, [FoProperties.Table, sFields, sValues]);
end;

function TInstructionSQLEntity.MakeFields: string;
var
  sFields: string;
  I: integer;
  oProperty: TClassPropertyRTTI;
begin
  for I := 0 to Pred(FoProperties.Fields.Count) do
  begin
    oProperty := FoProperties.Fields.Items[I];

    if sFields <> '' then
      sFields := sFields + ', ';

    if oProperty.AutoInc then
    begin
//      sFields := sFields + oProperty.FieldNameBD + ' SERIAL NOT NULL';
      sFields := sFields + oProperty.FieldNameBD + ' INTEGER PRIMARY KEY AUTOINCREMENT';
      Continue;
    end;

    sFields := sFields + Format(' %s %s', [oProperty.FieldNameBD, oProperty.Kind]);

    if oProperty.NotNull then
     sFields := sFields + ' NOT NULL';
  end;

  Result := sFields;
end;

function TInstructionSQLEntity.MakeFK: string;
var
  sPK: string;
  oPropertyOwner: TClassPropertyRTTI;
  oPropertiesFK: TClassRTTI;
  I: Integer;
begin
  for I := 0 to Pred(FoProperties.Fields.Count) do
  begin
    oPropertyOwner := FoProperties.Fields.Items[I];

    if not oPropertyOwner.FK then
      Continue;

    oPropertiesFK := TClassRTTI.Create(FoProperties.Fields.Items[I].ClassFK);

    try
      sPK := oPropertiesFK.FieldsPK;

      Result := Result + Format(sCREATEFK, [FoProperties.Table,
                                            oPropertiesFK.Table,
                                            oPropertyOwner.FieldNameBD + ifthen(oPropertyOwner.FieldsFK <> '', ',' + oPropertyOwner.FieldsFK, ''),
                                            ifthen(oPropertiesFK.Schema <> '', oPropertiesFK.Schema + '.', '') + oPropertiesFK.Table,
                                            sPK]);
    finally
      oPropertiesFK.Free;
    end;
  end;
end;

function TInstructionSQLEntity.MakePK: string;
var
  sPK: string;
begin
  sPK := FoProperties.FieldsPK;

  if sPK = '' then
    Exit('');

  Result := Format(sCREATEPK, [FoProperties.Table, sPK]);
end;

function TInstructionSQLEntity.SQLCreateColumn(const pnIndex: integer): string;
begin
  Result := Format(sCREATECOLUMN, [FsTabela,
                                   FoProperties.Fields.Items[pnIndex].FieldNameBD,
                                   FoProperties.Fields.Items[pnIndex].Kind]);
end;

end.
