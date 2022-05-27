unit DAO;

interface

uses Conexao, IDAO, Generics.Collections;

type
  TDAO <T: constructor> = class(TInterfacedObject, iDAO<T>)
  private
    { private declarations }
  protected
    { protected declarations }
    FoConexao: TConexao;
  public
    { public declarations }
    constructor Create(const poConexao: TConexao);
    destructor Destroy; override;

    function Insert(const poObject: T): T;
    function Update(const poObject: T): T;
    function Delete(const poObject: T): T;
    function FindAll: TList<T>;
    function FindForID(const pnID: integer): T;
  end;

implementation

{ TDAO<T> }

constructor TDAO<T>.Create(const poConexao: TConexao);
begin
  FoConexao := poConexao
end;

destructor TDAO<T>.Destroy;
begin
  FoConexao := nil;
end;

function TDAO<T>.Insert(const poObject: T): T;
begin

end;

function TDAO<T>.Update(const poObject: T): T;
begin

end;

function TDAO<T>.Delete(const poObject: T): T;
begin

end;

function TDAO<T>.FindAll: TList<T>;
begin

end;

function TDAO<T>.FindForID(const pnID: integer): T;
begin

end;

end.
