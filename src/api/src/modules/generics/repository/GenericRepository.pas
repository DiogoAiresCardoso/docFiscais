unit GenericRepository;

interface

uses AbstractClass, Generics.Collections, DAO, IDAO, Conexao;

type
  TGenericRepository<T: class, constructor> = class abstract(TAbstractClass)
  private
    { private declarations }
    FoDAO: iDAO<T>;
    FoConexao: TConexao;
    FbDetalhe: boolean;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; overload;
    constructor Create(const poConexao: TConexao); overload;
    destructor Destroy; override;

    function Insert(const poObject: T): T; virtual;
    function Update(const poObject: T): T; virtual;
    function Delete(const pnID: integer): boolean; virtual;
    function FindAll: TList<T>; virtual;
    function FindByFilter(const poFilter: TDictionary<String,Variant>): TList<T>; virtual;
    function FindByID(const pnID: integer): T; virtual;
  end;

implementation

uses
  System.SysUtils;

{ TGenericRepository<T> }

constructor TGenericRepository<T>.Create;
begin
  if not Assigned(FoConexao) then
    FoConexao := TConexao.Create;

  FoDAO := TDAO<T>.Create(FoConexao);
  FbDetalhe := False;
end;

constructor TGenericRepository<T>.Create(const poConexao: TConexao);
begin
  FoConexao := poConexao;
  Create;
  FbDetalhe := True;
end;

destructor TGenericRepository<T>.Destroy;
begin
  if not FbDetalhe then
    FreeAndNil(FoConexao);

  FoDAO := nil;
  inherited;
end;

function TGenericRepository<T>.FindAll: TList<T>;
begin
  Result := FoDAO.FindAll;
end;

function TGenericRepository<T>.FindByFilter(const poFilter: TDictionary<String, Variant>): TList<T>;
begin

end;

function TGenericRepository<T>.FindByID(const pnID: integer): T;
begin
  Result := FoDAO.FindForID(pnId);
end;

function TGenericRepository<T>.Insert(const poObject: T): T;
var
  oObject: T;
begin
  oObject := poObject;

  Result := FoDAO.Insert(oObject) as T;
end;

function TGenericRepository<T>.Update(const poObject: T): T;
begin
  Result := FoDAO.Update(poObject);
end;

function TGenericRepository<T>.Delete(const pnID: integer): boolean;
begin
  Result := FoDAO.Delete(pnID);
end;

end.
