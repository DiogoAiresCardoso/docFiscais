unit DocFiscaisConfEntity;

interface

uses DocFiscaisAttributes, DB, SimpleAttributes;

type
  [TTable('docfiscaisconf')]
  TDocFiscaisConfEntity = class
  private
    FnValorChave: Variant;
    FnIdChave: integer;
    FnDescChave: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    [TCampoBD('id', ftInteger), PK, NotNull, AutoInc]
    property nIdChave: integer read FnIdChave write FnIdChave;
    [TCampoBD('chave', ftString, 60), NotNull]
    property nDescChave: string read FnDescChave write FnDescChave;
    [TCampoBD('valor', ftString, 60), NotNull]
    property nValorChave: Variant read FnValorChave write FnValorChave;
  end;

implementation

end.
