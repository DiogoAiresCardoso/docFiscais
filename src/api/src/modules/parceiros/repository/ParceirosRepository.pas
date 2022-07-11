unit ParceirosRepository;

interface

uses
  ParceirosEntity, Generics.Collections, DAO, IDAO, Conexao;

type
  TParceirosRepository = class
  private
    { private declarations }
  protected
    { protected declarations }
    FoDAO: iDAO<TParceirosEntity>;
    FoConexao: TConexao;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;


    function Inserir(poParceiro: TParceirosEntity): TParceirosEntity; overload;
    function Inserir(const poParceiroList: TList<TParceirosEntity>): TList<TParceirosEntity>; overload;
  end;

implementation

{ TParceirosRepository }

uses SysUtils;

constructor TParceirosRepository.Create;
begin
  FoConexao := TConexao.Create;
end;

destructor TParceirosRepository.Destroy;
begin
  FreeAndNil(FoConexao);
  inherited;
end;

function TParceirosRepository.Inserir(
  const poParceiroList: TList<TParceirosEntity>): TList<TParceirosEntity>;
begin
  try
    FoDAO := TDAO<TParceirosEntity>.Create(FoConexao);
    Result := FoDAO.Insert(poParceiroList);
  finally
    FoDAO := nil;
  end;
end;

function TParceirosRepository.Inserir(poParceiro: TParceirosEntity): TParceirosEntity;
begin
  try
    FoDAO := TDAO<TParceirosEntity>.Create(FoConexao);
    Result := FoDAO.Insert(poParceiro);
  finally
    FoDAO := nil;
  end;
end;

end.
