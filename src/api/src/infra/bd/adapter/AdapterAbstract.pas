unit AdapterAbstract;

interface

uses
  FireDAC.Comp.Client, FireDAC.Phys.Intf;

type
  TAdapterAbstract = class abstract
  private
    { private declarations }
  protected
    { protected declarations }
    FoConnection: TFDCustomConnection;
    FoMetaInfo: TFDMetaInfoQuery;
    FoQuery: TFDQuery;
  public
    { public declarations }
    constructor Create(const poConnection: TFDCustomConnection);
    destructor Destroy; override;
  end;

implementation

{ TAdapterAbstract }

constructor TAdapterAbstract.Create(const poConnection: TFDCustomConnection);
begin
  FoConnection := poConnection;

  FoQuery := TFDQuery.Create(nil);
  FoMetaInfo := TFDMetaInfoQuery.Create(nil);

  FoQuery.Connection := poConnection;
  FoMetaInfo.Connection := poConnection;
  FoMetaInfo.SchemaName := poConnection.CurrentSchema;
end;

destructor TAdapterAbstract.Destroy;
begin
  FoConnection := nil;
  FoQuery.Free;
  FoMetaInfo.Free;
end;

end.
