unit EmpresasEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes, GenericEntity, Enums;

type
  [TTable('empresas')]
  TEmpresasEntity = class(TGenericEntity)
  private
    FFantasia: string;
    FCNPJ: string;
    FCPF: string;
    FId: integer;
    FRazaoSocial: string;
    FTipo: TTipoPessoa;
    { private declarations }
  public
    { protected declarations }
    [TCampoBD('id', TFieldType.ftInteger), PK, NotNull, AutoInc]
    property Id: integer read FId write FId;
    [TCampoBD('tipo', TFieldType.ftInteger), NotNull]
    property Tipo: TTipoPessoa read FTipo write FTipo;
    [TCampoBD('cpf', TFieldType.ftString, 11)]
    property CPF: string read FCPF write FCPF;
    [TCampoBD('cnpj', TFieldType.ftString, 14)]
    property CNPJ: string read FCNPJ write FCNPJ;
    [TCampoBD('razaosocial', TFieldType.ftString, 100)]
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    [TCampoBD('fantasia', TFieldType.ftString, 100)]
    property Fantasia: string read FFantasia write FFantasia;

  end;

implementation

end.
