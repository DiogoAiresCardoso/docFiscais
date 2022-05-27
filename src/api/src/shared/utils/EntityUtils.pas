unit EntityUtils;

interface

uses
  LerClassesRTTI, Query;

type
  TEntityUtils<T: constructor> = class
  private
    FSQLDelete: string;
    FSQLUpdate: string;
    FSQLFind: string;
    FSQLInsert: string;
    function GetSQLDelete: string;
    function GetSQLFind: string;
    function GetSQLInsert: string;
    function GetSQLUpdate: string;
    { private declarations }
  protected
    { protected declarations }
    FProperties: TLerClassesRTTI;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    property SQLInsert: string read GetSQLInsert write FSQLInsert;
    property SQLUpdate: string read GetSQLUpdate write FSQLUpdate;
    property SQLDelete: string read GetSQLDelete write FSQLDelete;
    property SQLFind: string read GetSQLFind write FSQLFind;
    property Properties: TLerClassesRTTI read FProperties;
  end;

implementation

uses
  TypInfo, SysUtils, StrUtils;

{ TDAOUtils<T> }

constructor TEntityUtils<T>.Create;
var
  Info: PTypeInfo;
begin
  Info := System.TypeInfo(T);
  FProperties := TLerClassesRTTI.Create(Info);
end;

destructor TEntityUtils<T>.Destroy;
begin
  FProperties.Free;
end;

function TEntityUtils<T>.GetSQLDelete: string;
begin
  if FSQLDelete <> '' then
    Exit(FSQLDelete);

  Result := FSQLDelete;
end;

function TEntityUtils<T>.GetSQLFind: string;
var
  oQuery: TQuery;
  I: Integer;
begin
  if FSQLFind <> '' then
    Exit(FSQLFind);

  try
    oQuery := TQuery.Create;

    for I := 0 to Pred(FProperties.Propriedades.Count) do
      OQuery.AddColuna(FProperties.Propriedades.Items[I].CampoBD, 't1');

    oQuery.AddTabela(FProperties.Tabela, FProperties.Schema, 't1');

    FSQLFind := oQuery.MontarQuery;
  finally
    oQuery.Free;
    Result := FSQLFind;
  end;
end;

function TEntityUtils<T>.GetSQLInsert: string;
var
  sCampos: string;
  sValues: string;
  I: integer;
begin
  if FSQLInsert <> '' then
    Exit(FSQLInsert);

  for I := 0 to Pred(FProperties.Propriedades.Count) do
  begin
    if (FProperties.Propriedades.Items[I].PK) and (FProperties.Propriedades.Items[I].AutoInc) then
      Continue;

    if sCampos <> '' then
    begin
      sValues := ', ';
      sCampos := ', ';
    end;

    sCampos := sCampos + FProperties.Propriedades.Items[I].CampoBD;
    sValues := sValues + ':' + FProperties.Propriedades.Items[I].CampoBD;
  end;

  FSQLInsert := Format('INSERT INTO %s (%s) VALUES(%s);',
                      [ifthen(FProperties.Schema <> '', FProperties.Schema + '.', '') + FProperties.Tabela,
                       sCampos,
                       sValues]);

  Result := FSQLInsert;
end;

function TEntityUtils<T>.GetSQLUpdate: string;
begin
  Result := FSQLUpdate;

{UPDATE doc.empresa
SET tipo=0, cpf='', cnpj='', razaosocial='', fantasia='', ativo=false, usuariocriacao=0, usuarioedicao=0, datacriacao=0, dataedicao=0, excluido=false
WHERE id=nextval('doc.empresa_id_seq'::regclass);                                                                                                    }


end;

end.
