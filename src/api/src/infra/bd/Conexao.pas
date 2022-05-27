unit Conexao;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Param, FireDAC.Phys.PGDef, Vcl.ExtCtrls, FireDAC.Phys.PG,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Logger;

type

  TConexao = class
  private
    { private declarations }
    FDConn: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;

  protected
    { protected declarations }
    procedure ConectarBanco;
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

procedure TConexao.ConectarBanco;
var
  oParams: TFDPhysPGConnectionDefParams;
begin
  TLogger.InserirLog(Self.ClassName, 'Tipo de banco: POSTGRESQL', False);

  oParams := TFDPhysPGConnectionDefParams(FDConn.Params);
  oParams.DriverID := 'PG';
  oParams.Database := 'docFiscais';
  oParams.UserName := 'postgres';
  oParams.Password := 'postgres';
  oParams.Server := '127.0.0.1';
  oParams.MetaDefSchema := 'doc';
  oParams.MetaCurSchema := 'doc';

  TLogger.InserirLog(Self.ClassName, 'Servidor: ' + oParams.Server, False);
  TLogger.InserirLog(Self.ClassName, 'Schema: ' + oParams.MetaDefSchema, False);
  TLogger.InserirLog(Self.ClassName, 'Database: ' + oParams.Database, False);
end;

constructor TConexao.Create;
begin
  TLogger.InserirLog(Self.ClassName, 'Iniciando conexao com o banco');
  FDConn := TFDConnection.Create(nil);
  FDPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);
  ConectarBanco;
end;

destructor TConexao.Destroy;
begin
  FreeAndNil(FDConn);
  FreeAndNil(FDPhysPgDriverLink);
  TLogger.InserirLog(Self.ClassName, 'Finalizando conexao com o banco');
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
  Result := FDConn.CloneConnection;
end;

end.
