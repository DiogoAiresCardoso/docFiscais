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
  GenericEntity in '..\src\modules\generics\entity\GenericEntity.pas',
  Enums in '..\src\shared\types\Enums.pas',
  DocFiscaisAttributes in '..\src\domain\rtti\DocFiscaisAttributes.pas',
  ClassRTTI in '..\src\domain\rtti\ClassRTTI.pas',
  Query in '..\src\domain\query\Query.pas',
  DAO in '..\src\infra\bd\DAO.pas',
  IDAO in '..\src\domain\interfaces\IDAO.pas',
  EntityUtils in '..\src\shared\utils\EntityUtils.pas',
  InstructionSQLEntity in '..\src\domain\rtti\InstructionSQLEntity.pas',
  Adapter in '..\src\infra\bd\adapter\Adapter.pas',
  ParametrosEntity in '..\src\modules\parametros\entity\ParametrosEntity.pas',
  EmpresasEntity in '..\src\modules\empresas\entity\EmpresasEntity.pas',
  ParceirosEntity in '..\src\modules\parceiros\entity\ParceirosEntity.pas',
  AdapterTables in '..\src\infra\bd\adapter\AdapterTables.pas',
  AdapterAbstract in '..\src\infra\bd\adapter\AdapterAbstract.pas',
  AbstractClass in '..\src\domain\abstract\AbstractClass.pas',
  EnderecoEntity in '..\src\modules\endereco\entity\EnderecoEntity.pas',
  EmpresasService in '..\src\modules\empresas\service\EmpresasService.pas',
  EmpresasRepository in '..\src\modules\empresas\repository\EmpresasRepository.pas',
  GenericRepository in '..\src\modules\generics\repository\GenericRepository.pas',
  ParceirosService in '..\src\modules\parceiros\service\ParceirosService.pas',
  ParceirosRepository in '..\src\modules\parceiros\repository\ParceirosRepository.pas';

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
