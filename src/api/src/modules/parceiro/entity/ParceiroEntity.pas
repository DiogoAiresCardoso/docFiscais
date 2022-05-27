unit ParceiroEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes, GenericEntity, Enums, EmpresaEntity;

type
  [TTable('parceiro')]
  TParceiroEntity = class(TGenericEntity)
  private
    FCNPJ: string;
    FDataNascimento: TDateTime;
    FCPF: string;
    FId: integer;
    FNome: string;
    FTipo: TTipoPessoa;
    FEmpresa: TEmpresaEntity;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    { protected declarations }
    [TCampoBD('id', TFieldType.ftInteger), PK, NotNull, AutoInc]
    property Id: integer read FId write FId;
    [TCampoBD('empresa', TFieldType.ftInteger), TFK(TEmpresaEntity), NotNull]
    property Empresa: TEmpresaEntity read FEmpresa write FEmpresa;
    [TCampoBD('tipo', TFieldType.ftInteger), NotNull]
    property Tipo: TTipoPessoa read FTipo write FTipo;
    [TCampoBD('cpf', TFieldType.ftString, 11)]
    property CPF: string read FCPF write FCPF;
    [TCampoBD('cnpj', TFieldType.ftString, 14)]
    property CNPJ: string read FCNPJ write FCNPJ;
    [TCampoBD('nome', TFieldType.ftString, 100)]
    property Nome: string read FNome write FNome;
    [TCampoBD('fantasia', TFieldType.ftDateTime)]
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
  end;

implementation


end.
