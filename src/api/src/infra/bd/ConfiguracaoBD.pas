unit ConfiguracaoBD;

interface

uses Conexao, Logger, Query, LerClassesRTTI;

type
  TConfiguracaoBD = class
  private
    { private declarations }
    FoConexao: TConexao;
  protected
    { protected declarations }
    function VerificarTabela(const poClass: TClass): boolean;
    function GerarScriptCreate(const poClasse: TLerClassesRTTI): string;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    function VerificarBancoDados: boolean;
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
  TLogger.InserirLog(Self.ClassName, 'Limpando instancia');
  FoConexao.Free;
  inherited;
end;

function TConfiguracaoBD.GerarScriptCreate(const poClasse: TLerClassesRTTI): string;
var
  sQuery: string;
  sPK: string;
  sFields: string;
  I: Integer;
begin
  sPK := '';
  sFields := '';

  for I := 0 to Pred(poClasse.Propriedades.Count) do
  begin
    if poClasse.Propriedades[I].PK then
    begin
      if sPK = '' then
        sPk := poClasse.Propriedades[I].CampoBD
      else
        sPk := sPK + ', ' + poClasse.Propriedades[I].CampoBD;
    end;

    if poClasse.Propriedades[I].AutoInc then
    begin
      sFields := sFields + poClasse.Propriedades[I].CampoBD + ' SERIAL NOT NULL, ';
      Continue;
    end;

    sFields := sFields + Format(' %s %s %s,', [poClasse.Propriedades[I].CampoBD,
                                               poClasse.Propriedades[I].Kind,
                                               ifthen(poClasse.Propriedades[I].NotNull, 'NOT NULL', '')]);
  end;


  sQuery := Format('CREATE TABLE IF NOT EXISTS %s (%s %s)',
                  [poClasse.Schema + '.' + poClasse.Tabela,
                   sFields,
                   Format('CONSTRAINT %SPK PRIMARY KEY (%s)', [poClasse.Tabela, sPK])]);
  Result := sQuery;
end;

function TConfiguracaoBD.VerificarBancoDados: boolean;
begin
  Result := True;
  TLogger.InserirLog(Self.ClassName + '(VerificarBancoDados)', 'Iniciando');
  VerificarTabela(TDocFiscaisConfEntity);

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
    TLogger.InserirLog(Self.ClassName, 'Verificando tabela ' + oLerClasse.Tabela);

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

    oDataSet.SQL.Clear;
    oDataSet.SQL.Add(oQueryCreate);
    oDataSet.ExecSQL;
  finally
    FreeAndNil(oLerClasse);
    FreeAndNil(oQuery);
    FreeAndNil(oDataSet);
  end;
end;

end.
