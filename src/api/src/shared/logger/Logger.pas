unit Logger;

interface

type
  TLogger = class
  private
    { private declarations }
  protected
    { protected declarations }
    constructor Create;
  public
    { public declarations }
    class procedure InserirLog(const psMethodName: string; const psMessage: string; const pbMostrarTela: boolean = true);
  end;

implementation

uses
  SysUtils;

{ TLogger }

constructor TLogger.Create;
begin

end;

class procedure TLogger.InserirLog(const psMethodName, psMessage: string; const pbMostrarTela: boolean);
var
  oLog: TLogger;
begin
  if pbMostrarTela then
    Writeln(Format('%s - %s - %s', [FormatDateTime('DD-MM-YY HH:MM:SS', Now), psMethodName, psMessage]));

  oLog := TLogger.Create;

  try

  finally
    FreeAndNil(oLog);
  end;
end;

end.
