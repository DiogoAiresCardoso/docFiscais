unit ParametrosEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes, EmpresasEntity;

type
  [TTable('parametros', 'param')]
  TParametros = class
  private
    FnValorChave: Variant;
    FnIdChave: integer;
    FnDescChave: string;
    FnEmpresa: integer;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    [TCampoBD('id', ftInteger), PK, NotNull, AutoInc]
    property idChave: integer read FnIdChave write FnIdChave;
    [TCampoBD('empresa', ftInteger), PK, TFK(TEmpresasEntity), NotNull]
    property empresa: integer read FnEmpresa write FnEmpresa;
    [TCampoBD('chave', ftString, 60), NotNull]
    property descChave: string read FnDescChave write FnDescChave;
    [TCampoBD('valor', ftString, 60), NotNull]
    property valorChave: Variant read FnValorChave write FnValorChave;
  end;

implementation


end.
