unit ClassRTTI;

interface

uses
  Generics.Collections, DB, DocFiscaisAttributes, SimpleAttributes, RTTI;

type
  TClassRTTI = class;

  TClassPropertyRTTI = class
  private
    FTypeKind: TFieldType;
    FKind: string;
    FFieldName: string;
    FSize: integer;
    FFieldNameBD: string;
    FPK: boolean;
    FNotNull: boolean;
    FAutoInc: boolean;
    FClassFK: TClass;
    FFK: boolean;
    FoOwner: TClassRTTI;
    FFieldsFK: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(oOwner: TClassRTTI);

    property FieldName: string read FFieldName write FFieldName;
    property FieldNameBD: string read FFieldNameBD write FFieldNameBD;
    property Size: integer read FSize write FSize;
    property TypeKind: TFieldType read FTypeKind write FTypeKind;
    property Kind: string read FKind write FKind;
    property PK: boolean read FPK write FPK default false;
    property NotNull: boolean read FNotNull write FNotNull default false;
    property AutoInc: boolean read FAutoInc write FAutoInc default false;
    property FK: boolean read FFK write FFK default false;
    property FieldsFK: string read FFieldsFK write FFieldsFK;
    property ClassFK: TClass read FClassFK write FClassFK;

    property Owner: TClassRTTI read FoOwner;
  end;

  TClassRTTI = class
  private
    { private declarations }
    FOwner: TClass;
    FTabela: string;
    FSchema: string;
    FCamposPK: string;
    FListProperty: TList<TClassPropertyRTTI>;
    function GetFieldsPK: string;
  protected
    { protected declarations }
    procedure ReadClassFields(poType: TRttiType);
    procedure ReadClass;
  public
    { public declarations }
    constructor Create(poOwner: TClass);
    destructor Destroy; override;

    property Table: string read FTabela;
    property Schema: string read FSchema write FSchema;
    property Fields: TList<TClassPropertyRTTI> read FListProperty;
    property FieldsPK: string read GetFieldsPK;
  end;

implementation

{ TLerClassesRTTI }

uses
  SysUtils;

constructor TClassRTTI.Create(poOwner: TClass);
begin
  FOwner := poOwner;
  FListProperty := TList<TClassPropertyRTTI>.Create;
  ReadClass;
end;

destructor TClassRTTI.Destroy;
begin
  FreeAndNil(FListProperty);
  FOwner := nil;
  inherited;
end;

function TClassRTTI.GetFieldsPK: string;
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

      Result := Result + FListProperty.Items[I].FieldNameBD;
    end;
  end;
end;

procedure TClassRTTI.ReadClass;
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

    ReadClassFields(oType);
  finally
    oContext.Free;
  end;
end;

procedure TClassRTTI.ReadClassFields(poType: TRttiType);
var
  oProp: TRttiProperty;
  oAtributo: TCustomAttribute;
  oPropriedade: TClassPropertyRTTI;
begin
  // lendo propriedades
  for oProp in poType.GetProperties do
  begin
    oPropriedade := TClassPropertyRTTI.Create(Self);
    // nome
    oPropriedade.FieldName := oProp.Name;

    for oAtributo in oProp.GetAttributes do
    begin
      if oAtributo is TCampoBD then
      begin
        oPropriedade.FFieldNameBD := TCampoBD(oAtributo).CampoBD;
        oPropriedade.Kind     := TCampoBD(oAtributo).Kind;
        oPropriedade.Size  := TCampoBD(oAtributo).Tamanho;
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
        oPropriedade.ClassFK := TFK(oAtributo).ClasseFK;
        oPropriedade.FieldsFK := TFK(oAtributo).ChaveMultipla;
      end;
    end;

    FListProperty.Add(oPropriedade);
  end;
end;

{ TLerClassesProperty }

constructor TClassPropertyRTTI.Create(oOwner: TClassRTTI);
begin
  FoOwner := oOwner;
end;


end.
