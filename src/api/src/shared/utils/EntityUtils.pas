unit EntityUtils;

interface


type
  TEntityUtils<T: constructor> = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

  end;

implementation


{ TEntityUtils<T> }

constructor TEntityUtils<T>.Create;
begin

end;

destructor TEntityUtils<T>.Destroy;
begin

  inherited;
end;

end.
