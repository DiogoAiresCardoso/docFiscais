unit EmpresasRepository;

interface

uses GenericRepository, EmpresasEntity, Enums, Logger;



type
  TEmpresasRepository = class(TGenericRepository<TEmpresasEntity>)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }

    procedure ValoresPadroes;
  end;

implementation


{ TEmpresasRepository }

procedure TEmpresasRepository.ValoresPadroes;
var
  oEmpresa: TEmpresasEntity;
begin
  TLogger.InserirLog('Inserindo valores padrões');
  oEmpresa := TEmpresasEntity.Create;
  oEmpresa.Tipo := tpFisica;
  oEmpresa.CPF := '01234567890';
  oEmpresa.RazaoSocial := 'Empresa teste 1';
  oEmpresa.Fantasia := 'Testando 1';
  oEmpresa.Ativo := True;

  Insert(oEmpresa);

end;

end.
