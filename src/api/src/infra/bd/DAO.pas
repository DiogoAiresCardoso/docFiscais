unit DAO;

interface

uses Conexao, IDAO, InstructionSQLEntity,
     FireDAC.Comp.Client, FireDAC.Phys.Intf,
     Generics.Collections, RTTI, TypInfo, Enums, DocFiscaisAttributes, EmpresasEntity;

type
  TDAO <T: class, constructor> = class(TInterfacedObject, iDAO<T>)
  private
    { private declarations }
  protected
    { protected declarations }
    FoConexao: TConexao;
    FoInstructionSQL: TInstructionSQLEntity;
    FoQuery: TFDQuery;

    procedure ConfigureParams(const poQuery: TFDQuery);
    function GetValue(const psProperty: string; const poObject: T): TValue;
    function DataSetToEntity: T;
    function DataSetToListEntity: TList<T>;
  public
    { public declarations }
    constructor Create(const poConexao: TConexao);
    destructor Destroy; override;

    function Insert(const poObject: TList<T>): TList<T>; overload;
    function Insert(var poObject: T): T; overload;
    function Update(const poObject: T): T;
    function Delete(const pnID: integer): boolean;
    function FindAll: TList<T>;
    function FindForID(const pnID: integer): T;
  end;

implementation

uses
  SysUtils, Logger, System.Classes, FireDAC.Stan.Param, Data.DB;

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
  FoInstructionSQL := TInstructionSQLEntity.Create(T);
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
  nLastID: integer;
begin
  TLogger.InserirLog('Inserindo');
  sSQL := FoInstructionSQL.SQLInsert;

  try
    FoQuery.SQL.Clear;
    FoQuery.SQL.Add(sSQL);
    ConfigureParams(FoQuery);
    FoQuery.Prepare;

    for I := 0 to Pred(FoInstructionSQL.Properties.Fields.Count) do
    begin
      with FoInstructionSQL.Properties.Fields.Items[I] do
      begin
        vValue := GetValue(FieldName, poObject);

        if vValue.IsObject then
        begin
          vValue := TValue.FromVariant(TEmpresasEntity(vValue.AsObject).Id);
        end;

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

    nLastID := Int64(FoConexao.GetConnection.GetLastAutoGenValue(''));

    Result := FindForID(nLastID);
  except
    on E: Exception do
    begin
      TLogger.InserirLog('Falha ao inserir registro ' + E.Message);
    end;
  end;
end;

function TDAO<T>.Insert(const poObject: TList<T>): TList<T>;
var
  sSQL: string;
  I: Integer;
  vValue: TValue;
  nCountList: integer;
begin
  TLogger.InserirLog('Inserindo');
  sSQL := FoInstructionSQL.SQLInsert;

  FoQuery.SQL.Clear;
  FoQuery.SQL.Add(sSQL);
  ConfigureParams(FoQuery);
  FoQuery.Params.ArraySize := poObject.Count;

  for nCountList := 0 to Pred(poObject.Count) do
  begin
    for I := 0 to Pred(FoInstructionSQL.Properties.Fields.Count) do
    begin
      with FoInstructionSQL.Properties.Fields.Items[I] do
      begin
        vValue := GetValue(FieldName, poObject[nCountList]);

        if vValue.IsObject then
        begin
          vValue := TValue.FromVariant(TEmpresasEntity(vValue.AsObject).Id);
        end;

        if vValue.IsEmpty then
          Continue;

        if not AutoInc then
        begin
          if FoQuery.FindParam(FieldNameBD) <> nil then
            FoQuery.FindParam(FieldNameBD).Values[nCountList] := vValue.AsVariant;
        end;
      end;
    end;
  end;

  FoQuery.Execute(FoQuery.Params.ArraySize);

//  Result := FindAll;
end;

function TDAO<T>.Update(const poObject: T): T;
begin

end;

function TDAO<T>.Delete(const pnID: integer): boolean;
begin

end;

function TDAO<T>.FindAll: TList<T>;
var
  sSQL: string;
begin
  TLogger.InserirLog('Buscando todos');
  sSQL := FoInstructionSQL.SQLFindAll;

  FoQuery.SQL.Clear;
  FoQuery.SQL.Add(sSQL);
  FoQuery.Open;

  Result := DataSetToListEntity;
end;

function TDAO<T>.FindForID(const pnID: integer): T;
var
  sSQL: string;
  sChaves: string;
begin
  TLogger.InserirLog('Buscando pelo id ' + IntToStr(pnID));

  sSQL := FoInstructionSQL.SQLFindID;

  FoQuery.SQL.Clear;
  FoQuery.SQL.Add(sSQL);
  ConfigureParams(FoQuery);

  FoQuery.Params[0].AsInteger := pnID;

  FoQuery.Open;

  Result := DataSetToEntity;
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

procedure TDAO<T>.ConfigureParams(const poQuery: TFDQuery);
var
  I : integer;
  sCampo: string;
begin
  for I := 0 to Pred(FoInstructionSQL.Properties.Fields.Count) do
  begin
    sCampo := FoInstructionSQL.Properties.Fields.Items[I].FieldNameBD;

    if poQuery.FindParam(sCampo) <> nil then
    begin
      poQuery.FindParam(sCampo).DataType := FoInstructionSQL.Properties.Fields.Items[I].TypeKind;
      if poQuery.FindParam(sCampo).DataType = ftString then
        poQuery.FindParam(sCampo).Size := FoInstructionSQL.Properties.Fields.Items[I].Size;
    end;
  end;
end;

function TDAO<T>.DataSetToEntity: T;
var
  nCount: Integer;
  sFieldBD: string;
  sPropertyName: string;

  oContext: TRttiContext;
  oType: TRttiType;
  oProperty: TRttiProperty;
  oCustom: TCustomAttribute;
  sEnumName: string;

  TestEnumTypeInfo: PTypeInfo;

begin
  Result := T.Create;

  try
    oContext := TRttiContext.Create;
    oType := oContext.GetType(T);

    for nCount := 0 to Pred(FoInstructionSQL.Properties.Fields.Count) do
    begin
      sFieldBD := FoInstructionSQL.Properties.Fields[nCount].FieldNameBD;
      sPropertyName := FoInstructionSQL.Properties.Fields[nCount].FieldName;

      oProperty := oType.GetProperty(sPropertyName);

      if oProperty.PropertyType.ClassType = TRttiEnumerationType then
      begin
        for oCustom in oProperty.GetAttributes do
        begin
          if oCustom is TCampoBD then
          begin
            if TCampoBD(oCustom).TypeKind = ftBoolean then
              oProperty.SetValue(Pointer(Result), TValue.FromVariant(FoQuery.FieldByName(sFieldBD).Value))
            else
              oProperty.SetValue(Pointer(Result), TValue.From(TTipoPessoa(FoQuery.FieldByName(sFieldBD).AsInteger)));
          end;
        end;
      end
      else
        oProperty.SetValue(Pointer(Result), TValue.FromVariant(FoQuery.FieldByName(sFieldBD).Value));
      oProperty := nil;
    end;
  finally
    oContext.Free;
  end;
end;

function TDAO<T>.DataSetToListEntity: TList<T>;
begin
  Result := TList<T>.Create;
  FoQuery.First;

  while not FoQuery.Eof do
  begin
    Result.Add(DataSetToEntity);
    FoQuery.Next;
  end;
end;


end.
