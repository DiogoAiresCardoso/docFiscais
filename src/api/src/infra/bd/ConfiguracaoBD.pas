unit ConfiguracaoBD;

interface

uses Conexao, Logger, Query, LerClassesRTTI, System.Classes, EmpresasEntity, ParceirosEntity, Adapter;

type
  TConfiguracaoBD = class
  private
    { private declarations }
    FoConexao: TConexao;
    FoAdapter: TAdapter;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    function ConfigurarBancoDados: boolean;
  end;

implementation

uses
  SysUtils, FireDAC.Comp.Client, Data.DB,
  RTTI, DocFiscaisAttributes, FireDAC.Comp.DataSet,
  StrUtils, ParametrosEntity;

{ TConfiguracaoBD }

constructor TConfiguracaoBD.Create;
begin
  FoConexao := TConexao.Create;
  FoAdapter := TAdapter.Create;
end;

destructor TConfiguracaoBD.Destroy;
begin
  FoConexao.Free;
  FoAdapter.Free;
  TLogger.InserirLog(Self.ClassName, 'Limpando instancia');
end;

function TConfiguracaoBD.ConfigurarBancoDados: boolean;
begin
  Result := True;
  TLogger.InserirLog(Self.ClassName + '(VerificarBancoDados)', 'Iniciando');


  FoAdapter.StartAdapter;
end;

end.
