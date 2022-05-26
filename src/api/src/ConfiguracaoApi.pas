unit ConfiguracaoApi;

interface

uses ConfiguracaoHorse, ConfiguracaoBD;

type
  TConfiguracaoApi = class
  private
    { private declarations }
    FoConfiguracaoHorse: TConfiguracaoHorse;
    FoConfiguracaoBD: TConfiguracaoBD;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TConfiguracaoApi }

constructor TConfiguracaoApi.Create;
begin
  FoConfiguracaoBD := TConfiguracaoBD.Create;

  if not FoConfiguracaoBD.ConfigurarBancoDados then
    Exit;

  FoConfiguracaoHorse := TConfiguracaoHorse.Create;
  FoConfiguracaoHorse.IniciarHorse;
end;

destructor TConfiguracaoApi.Destroy;
begin
  FoConfiguracaoHorse.PararHorse;
  FoConfiguracaoHorse.Free;
  inherited;
end;

end.
