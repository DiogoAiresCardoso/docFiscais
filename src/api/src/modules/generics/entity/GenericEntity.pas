unit GenericEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes;

type
  TGenericEntity = class
  private
    FAtivo: boolean;
    FUsuarioEdicao: integer;
    FDataEdicao: TDateTime;
    FUsuarioCriacao: integer;
    FExcluido: boolean;
    FDataCriacao: TDateTime;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    [TCampoBD('ativo', TFieldType.ftBoolean), NotNull]
    property Ativo: boolean read FAtivo write FAtivo default true;
    [TCampoBD('usuariocriacao', TFieldType.ftInteger), NotNull]
    property UsuarioCriacao: integer read FUsuarioCriacao write FUsuarioCriacao;
    [TCampoBD('usuarioedicao', TFieldType.ftInteger), NotNull]
    property UsuarioEdicao: integer read FUsuarioEdicao write FUsuarioEdicao;
    [TCampoBD('datacriacao', TFieldType.ftDateTime), NotNull]
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    [TCampoBD('dataedicao', TFieldType.ftDateTime), NotNull]
    property DataEdicao: TDateTime read FDataEdicao write FDataEdicao;
    [TCampoBD('excluido', TFieldType.ftBoolean), NotNull]
    property Excluido: boolean read FExcluido write FExcluido default false;
  end;

implementation

end.
