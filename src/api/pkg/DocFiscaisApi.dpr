program DocFiscaisApi;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ConfiguracaoApi in '..\src\ConfiguracaoApi.pas',
  ConfiguracaoHorse in '..\src\infra\horse\ConfiguracaoHorse.pas',
  Conexao in '..\src\infra\bd\Conexao.pas',
  Logger in '..\src\shared\logger\Logger.pas',
  ConfiguracaoBD in '..\src\infra\bd\ConfiguracaoBD.pas',
  DocFiscaisConfEntity in '..\src\modules\docFiscaisConf\entity\DocFiscaisConfEntity.pas',
  DocFiscaisAttributes in '..\domain\rtti\DocFiscaisAttributes.pas',
  Query in '..\domain\query\Query.pas',
  LerClassesRTTI in '..\domain\rtti\LerClassesRTTI.pas',
  GenericEntity in '..\src\modules\generics\entity\GenericEntity.pas',
  EmpresaEntity in '..\src\modules\empresa\entity\EmpresaEntity.pas',
  ParceiroEntity in '..\src\modules\parceiro\entity\ParceiroEntity.pas',
  Enums in '..\src\shared\types\Enums.pas';

begin
  try
    {$IFDEF MSWINDOWS}
    IsConsole := False;
    ReportMemoryLeaksOnShutdown := True;
    {$ENDIF}

    TConfiguracaoApi.Create;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
