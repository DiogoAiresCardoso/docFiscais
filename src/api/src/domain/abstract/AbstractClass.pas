unit AbstractClass;

interface

type
  TAbstractClass = class abstract
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

{ TAbstractClass }

uses Logger, SysUtils;

constructor TAbstractClass.Create;
begin
  TLogger.InserirLog('Iniciando');
end;

destructor TAbstractClass.Destroy;
begin
  TLogger.InserirLog('Finalizado');
end;

end.
