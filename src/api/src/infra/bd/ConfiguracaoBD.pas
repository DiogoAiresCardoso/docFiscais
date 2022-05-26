unit ConfiguracaoBD;

interface

uses Conexao, Logger, Query, LerClassesRTTI, System.Classes, EmpresaEntity, ParceiroEntity;

type
  TConfiguracaoBD = class
  private
    { private declarations }
    FoConexao: TConexao;
  protected
    { protected declarations }
    function VerificarTabela(const poClass: TClass): boolean;
    function GerarScriptCreate(const poClasse: TLerClassesRTTI): string;
    function GerarScriptCreatePK(const poClasse: TLerClassesRTTI): string;
    function GerarScriptCreateFK(const poProperty: TLerClassesProperty): string;
    function GerarScriptCreateField(const poProperty: TLerClassesProperty): string;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    function ConfigurarBancoDados: boolean;
  end;

implementation

uses
  SysUtils, FireDAC.Comp.Client, Data.DB,
  DocFiscaisConfEntity, RTTI, DocFiscaisAttributes, FireDAC.Comp.DataSet,
  StrUtils;

{ TConfiguracaoBD }

constructor TConfiguracaoBD.Create;
begin
  FoConexao := TConexao.Create;
end;

destructor TConfiguracaoBD.Destroy;
begin
  FoConexao.Free;
  TLogger.InserirLog(Self.ClassName, 'Limpando instancia');
end;

function TConfiguracaoBD.GerarScriptCreate(const poClasse: TLerClassesRTTI): string;
var
  sQuery: string;
  sPK: string;
  sFK: string;
  sFields: string;
  I: Integer;
begin
  for I := 0 to Pred(poClasse.Propriedades.Count) do
  begin
    if sFields <> '' then
      sFields := sFields + ', ';
    sFields := sFields +  GerarScriptCreateField(poClasse.Propriedades.Items[I]);

    if poClasse.Propriedades.Items[I].FK then
      sFK := sFk + ', ' + GerarScriptCreateFK(poClasse.Propriedades.Items[I]);
  end;

  sPK := GerarScriptCreatePK(poClasse);

  sQuery := Format('CREATE TABLE %s (%s %s %s)',
                  [poClasse.Schema + '.' + poClasse.Tabela,
                   sFields,
                   ifthen(sPK = '', '', ', ' + sPK),
                   ifthen(sFK = '', '', ifthen(sPK <> '', sFK, ', ' + sFK))]);
  Result := sQuery;
end;

function TConfiguracaoBD.GerarScriptCreateField(const poProperty: TLerClassesProperty): string;
var
  sFields: string;
begin
  if poProperty.AutoInc then
  begin
    sFields := sFields + poProperty.CampoBD + ' SERIAL NOT NULL';
    Exit(sFields);
  end;

  Result := Format(' %s %s %s', [poProperty.CampoBD,
                                  poProperty.Kind,
                                  ifthen(poProperty.NotNull, 'NOT NULL', '')]);
end;

function TConfiguracaoBD.GerarScriptCreateFK(const poProperty: TLerClassesProperty): string;
var
  sPK: string;
  oLerClasses: TLerClassesRTTI;
begin
  try
    oLerClasses := TLerClassesRTTI.Create(poProperty.ClasseFK);

    sPK := oLerClasses.CamposPK;


    Result := Format(' CONSTRAINT %sFK%s FOREIGN KEY(%s) REFERENCES %s(%s)', [
                     poProperty.Owner.Tabela,
                     oLerClasses.Tabela,
                     poProperty.CampoBD,
                     oLerClasses.Schema + '.' + oLerClasses.Tabela,
                     sPK]);
  finally
    FreeAndNil(oLerClasses);
  end;
end;

function TConfiguracaoBD.GerarScriptCreatePK(const poClasse: TLerClassesRTTI): string;
var
  sPK: string;
begin
  sPK := poClasse.CamposPK;

  if sPK = '' then
    Exit('');

  Result := Format('CONSTRAINT %SPK PRIMARY KEY (%s)', [poClasse.Tabela, sPK]);
end;

function TConfiguracaoBD.ConfigurarBancoDados: boolean;
begin
  Result := True;
  TLogger.InserirLog(Self.ClassName + '(VerificarBancoDados)', 'Iniciando');


  VerificarTabela(TDocFiscaisConfEntity);
  VerificarTabela(TEmpresaEntity);
  VerificarTabela(TParceiroEntity);
end;

function TConfiguracaoBD.VerificarTabela(const poClass: TClass): boolean;
var
  oQuery: TQuery;
  oDataSet: TFDQuery;
  oLerClasse: TLerClassesRTTI;
  oQueryCreate: string;
begin
  try
    Result := false;

    oLerClasse := TLerClassesRTTI.Create(poClass);

    oQuery := TQuery.Create;

    oQuery.AddColuna('*', 'T')
          .AddTabela('tables', 'information_schema', 'T')
          .AddCondicao('T.table_schema = ' + QuotedStr(oLerClasse.Schema) +
                       ' and T.table_name = ' + QuotedStr(oLerClasse.Tabela));

    oDataSet := FoConexao.ExecutarConsulta(oQuery.MontarQuery);

    if not oDataSet.IsEmpty then
    begin
      TLogger.InserirLog(Self.ClassName, oLerClasse.Tabela + ' Ok');
      Exit(True);
    end;

    TLogger.InserirLog(Self.ClassName, 'Criando tabela ' + oLerClasse.Tabela);

    oQueryCreate := GerarScriptCreate(oLerClasse);

    oDataSet.Connection.StartTransaction;

    try
      oDataSet.SQL.Clear;
      oDataSet.SQL.Add(oQueryCreate);
      oDataSet.ExecSQL;

      oDataSet.Connection.Commit;
    except
      on E: Exception do
      begin
        TLogger.InserirLog(Self.ClassName, 'Criando tabela ' + oLerClasse.Tabela + ' ' + e.Message);
        oDataSet.Connection.Rollback;
      end;
    end;
  finally
    oDataSet.Connection.Close;

    FreeAndNil(oLerClasse);
    FreeAndNil(oQuery);
    FreeAndNil(oDataSet);
  end;
end;

end.
