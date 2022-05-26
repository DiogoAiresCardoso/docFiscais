unit DocFiscaisAttributes;

interface

uses DB;

type
  TTable = class(TCustomAttribute)
  private
    FTable: string;
    FSchema: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(psName: string; psSchema: string = 'doc');

    property Table: string read FTable;
    property Schema: string read FSchema write FSchema;
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

implementation

uses
  SysUtils;

{ TTable }
constructor TTable.Create(psName: string; psSchema: string);
begin
  FTable := psName;
  FSchema := psSchema;
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
    ftString: result := Format('character varying(%s) COLLATE pg_catalog."default"', [IntToStr(FTamanho)]);
    ftInteger: result := 'integer';
    ftBoolean: result := 'boolean';
    ftFloat: result := Format('numeric(%s,5)', [IntToStr(FTamanho)]);
    ftBlob: result := 'oid';
    ftTimeStamp: result := 'time with time zone';
  end;
end;

end.
