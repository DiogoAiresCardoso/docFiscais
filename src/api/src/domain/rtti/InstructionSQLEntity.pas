unit InstructionSQLEntity;

interface

uses
  LerClassesRTTI;

type
  TInstructionSQLEntity = class
  private
    FoProperties: TLerClassesRTTI;
    FSQLCreateTable: string;
    FsTabela: string;
    { private declarations }
  protected
    { protected declarations }
    // Destined block for CreateTable
    function GetFSQLCreateTable: string;
    function MakeFields: string;
    function MakePK: string;
    function MakeFK: string;
    // Destined block for Insert

  public
    { public declarations }
    constructor Create(const poClass: TClass);
    destructor Destroy; override;

    property SQLCreateTable: string read GetFSQLCreateTable;
    property Properties: TLerClassesRTTI read FoProperties;
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

{ TInstructionSQLEntity<T> }

constructor TInstructionSQLEntity.Create(const poClass: TClass);
begin
  FoProperties := TLerClassesRTTI.Create(poClass);

  FsTabela := ifthen(FoProperties.Schema <> '', FoProperties.Schema + '.', '') + FoProperties.Tabela;
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
  sPK := MakePK;
  sFK := MakeFK;

  FSQLCreateTable := Format(sCREATETABLE, [FsTabela, sFields, sPK, sFK]);

  Result := FSQLCreateTable;
end;

function TInstructionSQLEntity.MakeFields: string;
var
  sFields: string;
  I: integer;
  oProperty: TLerClassesProperty;
begin
  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    oProperty := FoProperties.Propriedades.Items[I];

    if sFields <> '' then
      sFields := sFields + ', ';

    if oProperty.AutoInc then
    begin
      sFields := sFields + oProperty.CampoBD + ' SERIAL NOT NULL';
      Continue;
    end;

    sFields := sFields + Format(' %s %s', [oProperty.CampoBD, oProperty.Kind]);

    if oProperty.NotNull then
     sFields := sFields + ' NOT NULL';
  end;

  Result := sFields;
end;

function TInstructionSQLEntity.MakeFK: string;
var
  sPK: string;
  oPropertyOwner: TLerClassesProperty;
  oPropertiesFK: TLerClassesRTTI;
  I: Integer;
begin
  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    oPropertyOwner := FoProperties.Propriedades.Items[I];

    if not oPropertyOwner.FK then
      Continue;

    oPropertiesFK := TLerClassesRTTI.Create(FoProperties.Propriedades.Items[I].ClasseFK);

    try
      sPK := oPropertiesFK.CamposPK;

      Result := Result + Format(sCREATEFK, [FoProperties.Tabela,
                                            oPropertiesFK.Tabela,
                                            oPropertyOwner.CampoBD + ifthen(oPropertyOwner.FKChaves <> '', ',' + oPropertyOwner.FKChaves, ''),
                                            ifthen(oPropertiesFK.Schema <> '', oPropertiesFK.Schema + '.', '') + oPropertiesFK.Tabela,
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
  sPK := FoProperties.CamposPK;

  if sPK = '' then
    Exit('');

  Result := Format(sCREATEPK, [FoProperties.Tabela, sPK]);
end;

end.
