unit ConfiguracaoHorse;

interface

uses
  Horse;

type
  TConfiguracaoHorse = class
  private
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
  System.SysUtils;

{ TConfiguracaoHorse }

procedure TConfiguracaoHorse.IniciarHorse;
begin
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

end.
