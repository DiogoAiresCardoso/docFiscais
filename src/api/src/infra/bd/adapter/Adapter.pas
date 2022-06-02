unit Adapter;

interface

uses Conexao, FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, AbstractClass;

type
  TAdapter = class(TAbstractClass)
  private
    { private declarations }
    procedure AdapterEntity(const poClass: TClass);
  protected
    { protected declarations }
    FoConexao: TConexao;
    oConnection: TFDCustomConnection;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure StartAdapter;
  end;

implementation

{ TAdapter }

uses
  EmpresasEntity, ParceirosEntity, InstructionSQLEntity, Logger,
  System.SysUtils, ParametrosEntity, AdapterTables;

procedure TAdapter.AdapterEntity(const poClass: TClass);
var
  oAdapTables: TAdapterTables;
  bExecutado: boolean;
begin
  bExecutado := false;

  if not oConnection.InTransaction then
   Exit;

  oAdapTables := TAdapterTables.Create(oConnection);
  try
    bExecutado := oAdapTables.CreateTable(poClass);

    if bExecutado then
      oAdapTables.CreateColumn(poClass);
  finally
    if not bExecutado then
      oConnection.Rollback;

    oAdapTables.Free;
  end;
end;

constructor TAdapter.Create;
begin
  inherited Create;
  FoConexao := TConexao.Create;
  oConnection := FoConexao.GetConnection;
end;

destructor TAdapter.Destroy;
begin
  FreeAndNil(oConnection);
  FreeAndNil(FoConexao);
  inherited Destroy;
end;

procedure TAdapter.StartAdapter;
begin
  oConnection.StartTransaction;
  try
    TLogger.InserirLog('Verificando tabelas');
    AdapterEntity(TEmpresasEntity);
    AdapterEntity(TParametros);
    AdapterEntity(TParceirosEntity);
  finally
    if oConnection.InTransaction then
      oConnection.Commit;
  end;
end;

end.
