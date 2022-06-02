unit Conexao;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Param, FireDAC.Phys.PGDef, Vcl.ExtCtrls, FireDAC.Phys.PG,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Logger, AbstractClass;

type

  TConexao = class(TAbstractClass)
  private
    { private declarations }
    FDConn: TFDConnection;
    FDTransac: TFDTransaction;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;

  protected
    { protected declarations }
    procedure ConectarBanco;

    procedure BeforeStartTransaction(Sender: TObject);
    procedure BeforeCommit(Sender: TObject);
    procedure BeforeRollback(Sender: TObject);
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TFDCustomConnection;

    function ExecutarConsulta(psQuery: string): TFDQuery;
  end;

implementation

uses
  System.SysUtils;


{ TConexao }

procedure TConexao.BeforeCommit(Sender: TObject);
begin


  TLogger.InserirLog('Commit transação ');
end;

procedure TConexao.BeforeRollback(Sender: TObject);
begin
  TLogger.InserirLog('Rollback transação');
end;

procedure TConexao.BeforeStartTransaction(Sender: TObject);
begin
  TLogger.InserirLog('Iniciando transação');
end;

procedure TConexao.ConectarBanco;
var
  oParams: TFDPhysPGConnectionDefParams;
begin
  TLogger.InserirLog('Tipo de banco: POSTGRESQL', False);

  oParams := TFDPhysPGConnectionDefParams(FDConn.Params);
  oParams.DriverID := 'PG';
  oParams.Database := 'documentosFiscais';
  oParams.UserName := 'postgres';
  oParams.Password := 'postgres';
  oParams.Server := '127.0.0.1';
  oParams.MetaDefSchema := 'doc';
  oParams.MetaCurSchema := 'doc';

  TLogger.InserirLog('Servidor: ' + oParams.Server, False);
  TLogger.InserirLog('Schema: ' + oParams.MetaDefSchema, False);
  TLogger.InserirLog('Database: ' + oParams.Database, False);
end;

constructor TConexao.Create;
begin
  inherited Create;

  FDConn := TFDConnection.Create(nil);
  FDTransac := TFDTransaction.Create(nil);
  FDPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);

  FDConn.BeforeStartTransaction := BeforeStartTransaction;
  FDConn.BeforeCommit := BeforeCommit;
  FDConn.BeforeRollback := BeforeRollback;
  FDConn.Transaction := FDTransac;

  ConectarBanco;
end;

destructor TConexao.Destroy;
begin
  FreeAndNil(FDTransac);
  FreeAndNil(FDConn);
  FreeAndNil(FDPhysPgDriverLink);
  inherited Destroy;
end;

function TConexao.ExecutarConsulta(psQuery: string): TFDQuery;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);

  FDQuery.Connection := GetConnection;

  FDQuery.SQL.Clear;
  FDQuery.SQL.Add(psQuery);
  FDQuery.Open;

  Result := FDQuery;
end;

function TConexao.GetConnection: TFDCustomConnection;
begin
  Result := FDConn;
end;

end.
