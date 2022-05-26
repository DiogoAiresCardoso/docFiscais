unit Query;

interface

uses Generics.Collections;

type
  TQuery = class
  private
    FListColuna: TList<string>;
    FListTabela: TList<string>;
    FListWhere: TList<string>;
    { private declarations }
  protected
    { protected declarations }
    function RetornarCampos: string;
    function RetornarCondicoes: string;
    function RetornarTabela: string;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    function AddColuna(const psName: string; const psAlias: string): TQuery;
    function AddTabela(const psName: string; const psSchema: string; const psAlias: string): TQuery;
    function AddCondicao(const psCondicao: string): TQuery;

    function MontarQuery: string;

  end;

implementation

{ TQuery }

uses SysUtils;

function TQuery.AddColuna(const psName, psAlias: string): TQuery;
var
  sColuna: string;
begin
  sColuna := Format('%s.%s', [psAlias, psName]);

  if FListColuna.IndexOf(sColuna) <= 0 then
    FListColuna.Add(sColuna);

  Result := Self;
end;

function TQuery.AddTabela(const psName, psSchema: string; const psAlias: string): TQuery;
var
  sTabela: string;
begin
  sTabela := psName + ' ' + psAlias;

  if psSchema <> '' then
    sTabela := psSchema + '.' + sTabela;

  if FListTabela.IndexOf(sTabela) <= 0 then
    FListTabela.Add(sTabela);

  Result := Self;
end;

function TQuery.AddCondicao(const psCondicao: string): TQuery;
begin
  if FListWhere.IndexOf(psCondicao) <= 0 then
    FListWhere.Add(psCondicao);

  Result := Self;
end;

constructor TQuery.Create;
begin
  FListColuna := TList<string>.Create;
  FListTabela := TList<string>.Create;
  FListWhere := TList<string>.Create;
end;

destructor TQuery.Destroy;
begin
  FreeAndNil(FListColuna);
  FreeAndNil(FListTabela);
  FreeAndNil(FListWhere);
end;

function TQuery.MontarQuery: string;
begin
  Result := Format('select %s from %s where %s', [RetornarCampos, RetornarTabela, RetornarCondicoes]);
end;

function TQuery.RetornarCampos: string;
var
  I: Integer;
begin
  for I := 0 to Pred(FListColuna.Count) do
  begin
    Result := Result + FListColuna[I];

    if I < Pred(FListColuna.Count)  then
      Result := Result + ', ';
  end;
end;

function TQuery.RetornarCondicoes: string;
var
  I: Integer;
begin
  for I := 0 to Pred(FListWhere.Count) do
  begin
    Result := Result + FListWhere[I];

    if I < Pred(FListWhere.Count)  then
      Result := Result + ', ';
  end;
end;

function TQuery.RetornarTabela: string;
begin
  Result := FListTabela[0];
end;

end.
