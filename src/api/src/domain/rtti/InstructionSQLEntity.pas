unit InstructionSQLEntity;

interface

uses
  LerClassesRTTI;

type
  TInstructionSQLEntity<T: constructor> = class
  private
    FoProperties: TLerClassesRTTI;
    FSQLCreateTable: string;
    FsCampos: string;
    FsValues: string;
    FsWhere: string;
    function GetFSQLCreateTable: string;
    procedure MontarCampos(const pbAdicionarPK: boolean = false);
    procedure MontarValues(const pbConcatenarCampo: boolean = true; const pbAdicionarPK: boolean = false);
    function MontarCampoCreate(const poPropriedade: TLerClassesProperty): string;
    { private declarations }
  protected
    { protected declarations }
    const
      sCREATETABLE = 'CREATE TABLE %s (%s %s %s)';
      sINSERT = 'INSERT INTO %s (%s) VALUES(%s);';
      sUPDATE = 'UPDATE %s SET %s where %s';
      sDELETE = 'DELETE FROM %s where %s';
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    property SQLCreateTable: string read GetFSQLCreateTable;
  end;

implementation

uses
  TypInfo, StrUtils, SysUtils;

{ TInstructionSQLEntity<T> }

constructor TInstructionSQLEntity<T>.Create;
var
  Info: PTypeInfo;
begin
  Info := System.TypeInfo(T);
  FoProperties := TLerClassesRTTI.Create(Info);
end;

destructor TInstructionSQLEntity<T>.Destroy;
begin
  FoProperties.Free;
end;

function TInstructionSQLEntity<T>.GetFSQLCreateTable: string;
begin
  if FSQLCreateTable <> '' then
    Exit(FSQLCreateTable);  

  Result := FSQLCreateTable;
end;

function TInstructionSQLEntity<T>.MontarCampoCreate(const poPropriedade: TLerClassesProperty): string;
begin

  

  Result := Format(' %s %s %s', [poPropriedade.CampoBD]);
end;

procedure TInstructionSQLEntity<T>.MontarCampos(const pbAdicionarPK: boolean);
var
  I: Integer;
begin
  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    if (FoProperties.Propriedades.Items[I].PK) and
       (not pbAdicionarPK) then
      Continue;

    FsCampos := Format('%s %s',
                      [ifthen(FsValues <> '', FsValues + ', ', FsValues),
                       FoProperties.Propriedades.Items[I].CampoBD]);
  end;
end;

procedure TInstructionSQLEntity<T>.MontarValues(const pbConcatenarCampo: boolean; const pbAdicionarPK: boolean);
var
  I: Integer;
begin
  for I := 0 to Pred(FoProperties.Propriedades.Count) do
  begin
    if (FoProperties.Propriedades.Items[I].PK) and
       (not pbAdicionarPK) then
      Continue;

    FsValues := Format('%s %s', 
                      [ifthen(FsValues <> '', FsValues + ', ', FsValues), 
                       ifthen(pbConcatenarCampo, 
                              Format('%s = :%s', [FoProperties.Propriedades.Items[I].CampoBD]),
                              Format(':%s', [FoProperties.Propriedades.Items[I].CampoBD]))]);
  end;
end;

end.
