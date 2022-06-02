unit ConfiguracaoApi;

interface

uses ConfiguracaoHorse, ConfiguracaoBD, AbstractClass;

type
  TConfiguracaoApi = class(TAbstractClass)
  private
    { private declarations }
    FoConfiguracaoHorse: TConfiguracaoHorse;

  protected
    { protected declarations }
    function ConfigureBD: boolean;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TConfiguracaoApi }

function TConfiguracaoApi.ConfigureBD: boolean;
var
  FoConfiguracaoBD: TConfiguracaoBD;
begin
  FoConfiguracaoBD := TConfiguracaoBD.Create;
  try
    Result := FoConfiguracaoBD.ConfigurarBancoDados;
  finally
    FreeAndNil(FoConfiguracaoBD);
  end;
end;

constructor TConfiguracaoApi.Create;
begin
  inherited Create;

  if not ConfigureBD then
    Exit;

  FoConfiguracaoHorse := TConfiguracaoHorse.Create;
  FoConfiguracaoHorse.IniciarHorse;
end;

destructor TConfiguracaoApi.Destroy;
begin
  FoConfiguracaoHorse.PararHorse;
  FoConfiguracaoHorse.Free;
  inherited Destroy;
end;

end.
