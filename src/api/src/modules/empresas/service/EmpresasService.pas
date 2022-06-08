unit EmpresasService;

interface

uses EmpresasRepository, EmpresasEntity, Generics.Collections;

type
  TEmpresasService = class
  private
    { private declarations }
    FoRepository: TEmpresasRepository;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(poRepository: TEmpresasRepository);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TEmpresasService }

constructor TEmpresasService.Create(poRepository: TEmpresasRepository);
begin
  FoRepository := poRepository;
end;

destructor TEmpresasService.Destroy;
begin
  FreeAndNil(FoRepository);
end;

end.
