unit LerClassesRTTI;

interface

uses
  Generics.Collections, DB, DocFiscaisAttributes, SimpleAttributes, RTTI;

type
  TLerClassesRTTI = class;

  TLerClassesProperty = class
  private
    FTypeKind: TFieldType;
    FKind: string;
    FNome: string;
    FTamanho: integer;
    FCampoBD: string;
    FPK: boolean;
    FNotNull: boolean;
    FAutoInc: boolean;
    FClasseFK: TClass;
    FFK: boolean;
    FoOwner: TLerClassesRTTI;
    FFKChaves: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(oOwner: TLerClassesRTTI);

    property Nome: string read FNome write FNome;
    property CampoBD: string read FCampoBD write FCampoBD;
    property Tamanho: integer read FTamanho write FTamanho;
    property TypeKind: TFieldType read FTypeKind write FTypeKind;
    property Kind: string read FKind write FKind;
    property PK: boolean read FPK write FPK default false;
    property NotNull: boolean read FNotNull write FNotNull default false;
    property AutoInc: boolean read FAutoInc write FAutoInc default false;
    property FK: boolean read FFK write FFK default false;
    property FKChaves: string read FFKChaves write FFKChaves;
    property ClasseFK: TClass read FClasseFK write FClasseFK;

    property Owner: TLerClassesRTTI read FoOwner;
  end;

  TLerClassesRTTI = class
  private
    { private declarations }
    FOwner: TClass;
    FTabela: string;
    FSchema: string;
    FCamposPK: string;
    FListProperty: TList<TLerClassesProperty>;
    function GetCamposPK: string;
  protected
    { protected declarations }
    procedure LerPropriedades(poType: TRttiType);
    procedure LerClasse;
  public
    { public declarations }
    constructor Create(poOwner: TClass);
    destructor Destroy; override;

    property Tabela: string read FTabela;
    property Schema: string read FSchema write FSchema;
    property Propriedades: TList<TLerClassesProperty> read FListProperty;
    property CamposPK: string read GetCamposPK;
  end;

implementation

{ TLerClassesRTTI }

uses
  SysUtils;

constructor TLerClassesRTTI.Create(poOwner: TClass);
begin
  FOwner := poOwner;
  FListProperty := TList<TLerClassesProperty>.Create;
  LerClasse;
end;

destructor TLerClassesRTTI.Destroy;
begin
  FreeAndNil(FListProperty);
  FOwner := nil;
  inherited;
end;

function TLerClassesRTTI.GetCamposPK: string;
var
  I: Integer;
begin
  if FCamposPK <> '' then
    Exit(FCamposPK);

  Result := '';

  for I := 0 to Pred(FListProperty.Count) do
  begin
    if FListProperty.Items[I].PK then
    begin
      if Result <> '' then
        Result := Result + ', ';

      Result := Result + FListProperty.Items[I].CampoBD;
    end;
  end;
end;

procedure TLerClassesRTTI.LerClasse;
var
  oContext: TRttiContext;
  oType: TRttiType;
  oAtributo: TCustomAttribute;
begin
  try
    oContext := TRttiContext.Create;
    oType := oContext.GetType(FOwner);

    // lendo tabela
    for oAtributo in oType.GetAttributes do
    begin
      if oAtributo is TTable then
      begin
        FTabela := TTable(oAtributo).Table;
        FSchema := TTable(oAtributo).Schema;
      end;
    end;

    LerPropriedades(oType);
  finally
    oContext.Free;
  end;
end;

procedure TLerClassesRTTI.LerPropriedades(poType: TRttiType);
var
  oProp: TRttiProperty;
  oAtributo: TCustomAttribute;
  oPropriedade: TLerClassesProperty;
begin
  // lendo propriedades
  for oProp in poType.GetProperties do
  begin
    oPropriedade := TLerClassesProperty.Create(Self);
    // nome
    oPropriedade.Nome := oProp.Name;

    for oAtributo in oProp.GetAttributes do
    begin
      if oAtributo is TCampoBD then
      begin
        oPropriedade.FCampoBD := TCampoBD(oAtributo).CampoBD;
        oPropriedade.Kind     := TCampoBD(oAtributo).Kind;
        oPropriedade.Tamanho  := TCampoBD(oAtributo).Tamanho;
        oPropriedade.TypeKind := TCampoBD(oAtributo).TypeKind;
      end;

      if oAtributo is PK then
        oPropriedade.PK := True;

      if oAtributo is NotNull then
        oPropriedade.NotNull := True;

      if oAtributo is AutoInc then
        oPropriedade.AutoInc := True;

      if oAtributo is TFK then
      begin
        oPropriedade.FK := True;
        oPropriedade.ClasseFK := TFK(oAtributo).ClasseFK;
        oPropriedade.FKChaves := TFK(oAtributo).ChaveMultipla;
      end;
    end;

    FListProperty.Add(oPropriedade);
  end;
end;

{ TLerClassesProperty }

constructor TLerClassesProperty.Create(oOwner: TLerClassesRTTI);
begin
  FoOwner := oOwner;
end;


end.
