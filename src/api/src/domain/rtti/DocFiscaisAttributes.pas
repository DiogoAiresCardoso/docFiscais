unit DocFiscaisAttributes;

interface

uses DB;

type
  TTable = class(TCustomAttribute)
  private
    FTable: string;
    FSchema: string;
    FAlias: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(psName: string; psAlias: string; psSchema: string = 'doc');

    property Table: string read FTable;
    property Schema: string read FSchema;
    property Alias: string read FAlias;
  end;

  TCampoBD = class(TCustomAttribute)
  private
    FCampoBD: string;
    FKind: TFieldType;
    FTamanho: integer;
    function GetKind: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(psCampoBD: string; poKind: TFieldType; pnTamanho: integer = 0);

    property CampoBD: string read FCampoBD;
    property Kind: string read GetKind;
    property Tamanho: integer read FTamanho;
    property TypeKind: TFieldType read FKind;
  end;

  TFK = class(TCustomAttribute)
  private
    FClasseFK: TClass;
    FsChaveMultipla: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(poClasseFK: TClass; poChaveMultipla: string = '');

    property ClasseFK: TClass read FClasseFK;
    property ChaveMultipla: string read FsChaveMultipla;
  end;

implementation

uses
  SysUtils;

{ TTable }
constructor TTable.Create(psName: string; psAlias: string; psSchema: string);
begin
  FTable := psName;
  FSchema := psSchema;
  FAlias := psAlias;
end;

{ TCampoBD }
constructor TCampoBD.Create(psCampoBD: string; poKind: TFieldType; pnTamanho: integer);
begin
  FCampoBD := psCampoBD;
  FKind := poKind;
  FTamanho := pnTamanho;
end;

function TCampoBD.GetKind: string;
begin
  case FKind of
//    ftString: result := Format('character varying(%s) COLLATE pg_catalog."default"', [IntToStr(FTamanho)]);
    ftString: result := Format('TEXT(%s)', [IntToStr(FTamanho)]);
    ftInteger: result := 'integer';
    ftBoolean: result := 'boolean';
    ftFloat: result := Format('numeric(%s,5)', [IntToStr(FTamanho)]);
    ftBlob: result := 'oid';
    ftTimeStamp: result := 'TEXT';
//    ftTimeStamp: result := 'time with time zone';
  end;
end;

{ TFK }

constructor TFK.Create(poClasseFK: TClass; poChaveMultipla: string);
begin
  FClasseFK := poClasseFK;
  FsChaveMultipla := poChaveMultipla;
end;

end.
