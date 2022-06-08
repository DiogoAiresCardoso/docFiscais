unit DAO;

interface

uses Conexao, IDAO, InstructionSQLEntity,
     FireDAC.Comp.Client, FireDAC.Phys.Intf,
     Generics.Collections, RTTI, TypInfo;

type
  TDAO <T: class, constructor> = class(TInterfacedObject, iDAO<T>)
  private
    { private declarations }
  protected
    { protected declarations }
    FoConexao: TConexao;
    FoInstructionSQL: TInstructionSQLEntity;
    FoQuery: TFDQuery;

    function GetValue(const psProperty: string; const poObject: T): TValue;
  public
    { public declarations }
    constructor Create(const poConexao: TConexao);
    destructor Destroy; override;

    function Insert(const poObject: TList<T>): TList<T>; overload;
    function Insert(var poObject: T): T; overload;
    function Update(const poObject: T): T;
    function Delete(const poObject: T): T;
    function FindAll: TList<T>;
    function FindForID(const pnID: integer): T;
  end;

implementation

uses
  SysUtils, Logger, System.Classes, FireDAC.Stan.Param;

{ TDAO<T> }

constructor TDAO<T>.Create(const poConexao: TConexao);
var
  TypeEntity: PTypeInfo;
begin
  TLogger.InserirLog('Iniciando');

  FoConexao := poConexao;
  FoQuery := TFDQuery.Create(nil);
  FoQuery.Connection := FoConexao.GetConnection;

  TypeEntity := System.TypeInfo(T);
  FoInstructionSQL := TInstructionSQLEntity.Create(TypeEntity);
end;

destructor TDAO<T>.Destroy;
begin
  FoConexao := nil;
  FreeAndNil(FoQuery);
  FreeAndNil(FoInstructionSQL);
  TLogger.InserirLog('Finalizando');
end;

function TDAO<T>.Insert(var poObject: T): T;
var
  sSQL: string;
  I: Integer;
  vValue: TValue;
begin
  TLogger.InserirLog('Inserindo');
  sSQL := FoInstructionSQL.SQLInsert;

  try
    FoQuery.SQL.Clear;
    FoQuery.SQL.Add(sSQL);
    FoQuery.Prepare;

    for I := 0 to Pred(FoInstructionSQL.Properties.Fields.Count) do
    begin
      with FoInstructionSQL.Properties.Fields.Items[I] do
      begin
        vValue := GetValue(FieldName, poObject);

        if vValue.IsEmpty then
          Continue;

        if not AutoInc then
        begin
          if FoQuery.FindParam(FieldNameBD) <> nil then
            FoQuery.FindParam(FieldNameBD).Value := vValue.AsVariant;
        end;
      end;
    end;

    FoQuery.ExecSQL;

    TLogger.InserirLog('Registro inserido com sucesso!');
  except
    on E: Exception do
    begin
      TLogger.InserirLog('Falha ao inserir registro ' + E.Message);
    end;
  end;
end;

function TDAO<T>.Insert(const poObject: TList<T>): TList<T>;
begin

end;

function TDAO<T>.Update(const poObject: T): T;
begin

end;

function TDAO<T>.Delete(const poObject: T): T;
begin

end;

function TDAO<T>.FindAll: TList<T>;
begin

end;

function TDAO<T>.FindForID(const pnID: integer): T;
begin

end;


function TDAO<T>.GetValue(const psProperty: string; const poObject: T): TValue;
var
  oContext: TRttiContext;
  oTypes: TRttiType;
  oProp: TRttiProperty;
  oTypeEntity: PTypeInfo;
begin
  oContext := TRttiContext.Create;
  oTypeEntity := System.TypeInfo(T);

  try
    oTypes := oContext.GetType(oTypeEntity);
    oProp := oTypes.GetProperty(psProperty);

    if oProp <> nil then
      Result := oProp.GetValue(Pointer(poObject));
  finally
    oContext.Free;
  end;
end;

end.
