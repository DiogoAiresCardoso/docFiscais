unit DAOUtils;

interface

uses
  LerClassesRTTI;

type
  TDAOUtils<T: constructor> = class
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
    FoClasseRTTI: TLerClassesRTTI;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    property SQLInsert: string read GetSQLInsert write FSQLInsert;
    property SQLUpdate: string read GetSQLUpdate write FSQLUpdate;
    property SQLDelete: string read GetSQLDelete write FSQLDelete;
    property SQLFind: string read GetSQLFind write FSQLFind;

  end;

implementation

uses
  TypInfo;

{ TDAOUtils<T> }

constructor TDAOUtils<T>.Create;
var
  Info: PTypeInfo;
begin
  Info := System.TypeInfo(T);
  FoClasseRTTI := TLerClassesRTTI.Create(Info);
end;

destructor TDAOUtils<T>.Destroy;
begin
  FoClasseRTTI.Free;
end;

function TDAOUtils<T>.GetSQLDelete: string;
begin
  if FSQLDelete <> '' then
    Exit(FSQLDelete);




  Result := FSQLDelete;
end;

function TDAOUtils<T>.GetSQLFind: string;
begin
  Result := FSQLFind;
end;

function TDAOUtils<T>.GetSQLInsert: string;
begin
  Result := FSQLInsert;
end;

function TDAOUtils<T>.GetSQLUpdate: string;
begin
  Result := FSQLUpdate;
end;

end.
