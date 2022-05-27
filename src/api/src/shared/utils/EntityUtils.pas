unit EntityUtils;

interface

uses
  LerClassesRTTI, Query;

type
  TEntityUtils<T: constructor> = class
  private
    FoProperties: TLerClassesRTTI;
    FsWhereCamposPK: string;
    FsTabela: string;
    FsSQLDelete: string;
    FsSQLUpdate: string;
    FsSQLFind: string;
    FsSQLInsert: string;
    function GetSQLDelete: string;
    function GetSQLFind: string;
    function GetSQLInsert: string;
    function GetSQLUpdate: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    property SQLInsert: string read GetSQLInsert write FsSQLInsert;
    property SQLUpdate: string read GetSQLUpdate write FsSQLUpdate;
    property SQLDelete: string read GetSQLDelete write FsSQLDelete;
    property SQLFind: string read GetSQLFind write FsSQLFind;
    property Properties: TLerClassesRTTI read FoProperties;
  end;

implementation

uses
  TypInfo, SysUtils, StrUtils;

{ TDAOUtils<T> }

constructor TEntityUtils<T>.Create;
var
  Info: PTypeInfo;
  I: integer;
begin
  Info := System.TypeInfo(T);
  FoProperties := TLerClassesRTTI.Create(Info);

  FsTabela := ifthen(FoProperties.Schema <> '', FoProperties.Schema + '.', '') + FoProperties.Tabela;

  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    if (FoProperties.Propriedades.Items[I].PK) and (FoProperties.Propriedades.Items[I].AutoInc) then
    begin
      if FsWhereCamposPK <> '' then  
        FsWhereCamposPK := FsWhereCamposPK + ' and ';

      FsWhereCamposPK := FsWhereCamposPK + FoProperties.Propriedades.Items[I].CampoBD + ' = :' + 
                        FoProperties.Propriedades.Items[I].CampoBD;
    end;                        
  end;
end;

destructor TEntityUtils<T>.Destroy;
begin
  FoProperties.Free;
end;

function TEntityUtils<T>.GetSQLDelete: string;
begin
  if FsSQLDelete <> '' then
    Exit(FsSQLDelete);

  FsSQLDelete := Format('DELETE FROM %s where %s', [FsTabela, FsWhereCamposPK]);

  Result := FsSQLDelete;
end;

function TEntityUtils<T>.GetSQLFind: string;
var
  oQuery: TQuery;
  I: Integer;
begin
  if FsSQLFind <> '' then
    Exit(FsSQLFind);

  try
    oQuery := TQuery.Create;

    for I := 0 to Pred(FoProperties.Propriedades.Count) do
      OQuery.AddColuna(FoProperties.Propriedades.Items[I].CampoBD, 't1');

    oQuery.AddTabela(FoProperties.Tabela, FoProperties.Schema, 't1');

    FsSQLFind := oQuery.MontarQuery;
  finally
    oQuery.Free;
    Result := FsSQLFind;
  end;
end;

function TEntityUtils<T>.GetSQLInsert: string;
var
  sCampos: string;
  sValues: string;
  I: integer;
begin
  if FsSQLInsert <> '' then
    Exit(FsSQLInsert);

  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    if (FoProperties.Propriedades.Items[I].PK) and (FoProperties.Propriedades.Items[I].AutoInc) then
      Continue;

    if sCampos <> '' then
    begin
      sValues := sValues + ', ';
      sCampos := sCampos + ', ';
    end;

    sCampos := sCampos + FoProperties.Propriedades.Items[I].CampoBD;
    sValues := sValues + ':' + FoProperties.Propriedades.Items[I].CampoBD;
  end;

  FsSQLInsert := Format('INSERT INTO %s (%s) VALUES(%s);',
                      [FsTabela,
                       sCampos,
                       sValues]);

  Result := FsSQLInsert;
end;

function TEntityUtils<T>.GetSQLUpdate: string;
var
  sCampos: string;
begin
  if FsSQLUpdate <> '' then
    Exit(FsSQLUpdate);

  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    if (FoProperties.Propriedades.Items[I].PK) and (FoProperties.Propriedades.Items[I].AutoInc) then
      Continue;

    if sCampos <> '' then
    begin
      sCampos := sCampos + ', ';
    end;

    sCampos := sCampos + FoProperties.Propriedades.Items[I].CampoBD + ' = :' + FoProperties.Propriedades.Items[I].CampoBD;
  end;

  FsSQLUpdate := Format('UPDATE %s SET %s where %s' , [FsTabela, sCampos, FsWhereCamposPK]);
  Result := FsSQLUpdate;
end;

end.
