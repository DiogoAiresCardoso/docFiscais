unit ConfiguracaoHorse;

interface

uses
  Horse, ParceirosEntity, ParceirosService;

type
  TConfiguracaoHorse = class
  private
    procedure InserirParceirosDML(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure InserirParceiros(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    procedure IniciarHorse;
    procedure PararHorse;
  end;

implementation

uses
  System.SysUtils, Web.HTTPApp, Generics.Collections;

{ TConfiguracaoHorse }


procedure TConfiguracaoHorse.IniciarHorse;
begin

  THorse.Routes.RegisterRoute(mtPost, '/inserirParceirosDML/:quant', InserirParceirosDML);
  THorse.Routes.RegisterRoute(mtPost, '/inserirParceiros/:quant', InserirParceiros);

  THorse.Listen(5566,
  procedure(Horse: THorse)
  begin
    Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
    Readln;
  end);


end;

procedure TConfiguracaoHorse.PararHorse;
begin
  THorse.StopListen;
  Writeln(Format('Finalizando servidor %s:%d', [THorse.Host, THorse.Port]));
  Readln;
end;

procedure TConfiguracaoHorse.InserirParceiros(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  sQuant, nCount: integer;
  oListParceiros: TList<TParceirosEntity>;
  oParceirosService: TParceiroService;
begin
  sQuant := StrToInt(Req.Params['quant']);

  try
    oParceirosService := TParceiroService.Create;
    oListParceiros := TList<TParceirosEntity>.Create;

    for nCount := 0 to Pred(sQuant) do
      oListParceiros.Add(oParceirosService.Inserir);

    Res.Send('Ok');
  finally
    FreeAndNil(oParceirosService);
  end;
end;

procedure TConfiguracaoHorse.InserirParceirosDML(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  sQuant: integer;
  oListParceiros: TList<TParceirosEntity>;
  oParceirosService: TParceiroService;
begin
  sQuant := StrToInt(Req.Params['quant']);

  try
    oParceirosService := TParceiroService.Create;
    oListParceiros := oParceirosService.Inserir(sQuant);

    Res.Send('Ok');
  finally
    FreeAndNil(oParceirosService);
  end;

end;

end.
