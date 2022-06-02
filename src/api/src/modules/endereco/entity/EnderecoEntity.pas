unit EnderecoEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes, GenericEntity;

type
  TEnderecoEntity = class(TGenericEntity)
  private
    FLogradouro: string;
    FBairro: string;
    FCEP: string;
    FNumero: string;
    FComplemento: string;
    FCidade: string;
    FEstado: string;
    { private declarations }
  public
    { protected declarations }
    [TCampoBD('logradouro', ftString, 100)]
    property Logradouro: string read FLogradouro write FLogradouro;
    [TCampoBD('numero', ftString, 10)]
    property Numero: string read FNumero write FNumero;
    [TCampoBD('complemento', ftString, 100)]
    property Complemento: string read FComplemento write FComplemento;
    [TCampoBD('bairro', ftString, 100)]
    property Bairro: string read FBairro write FBairro;
    [TCampoBD('cidade', ftString, 100)]
    property Cidade: string read FCidade write FCidade;
    [TCampoBD('estado', ftString, 2)]
    property Estado: string read FEstado write FEstado;
    [TCampoBD('cep', ftString, 8)]
    property CEP: string read FCEP write FCEP;

  end;

implementation

end.
