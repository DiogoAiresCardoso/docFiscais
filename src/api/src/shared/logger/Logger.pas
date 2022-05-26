unit Logger;

interface

type
  TLogger = class
  private
    FMethodName: string;
    FMostrarTela: boolean;
    FMensagem: string;
    { private declarations }
  protected
    { protected declarations }
    constructor Create;
    procedure ShowLogTela;
  public
    { public declarations }
    class procedure InserirLog(const psMethodName: string; const psMessage: string; const pbMostrarTela: boolean = true);

    procedure Iniciar;
    property MethodLog: string read FMethodName write FMethodName;
    property Mensagem: string read FMensagem write FMensagem;
    property MostrarTela: boolean read FMostrarTela write FMostrarTela;

  end;

implementation

uses
  SysUtils, Classes;

{ TLogger }

constructor TLogger.Create;
begin

end;

procedure TLogger.Iniciar;
begin
  if FMostrarTela then
    ShowLogTela;
end;

class procedure TLogger.InserirLog(const psMethodName, psMessage: string; const pbMostrarTela: boolean);
var
  oLog: TLogger;
begin
  try
    oLog := TLogger.Create;
    oLog.MethodLog := psMethodName;
    oLog.Mensagem := psMessage;
    oLog.MostrarTela := pbMostrarTela;

    oLog.Iniciar;
  finally
    FreeAndNil(oLog);
  end;
end;

procedure TLogger.ShowLogTela;
begin
  TThread.Queue(TThread.CurrentThread,
  procedure
  begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      Writeln(Format('%s - %s - %s', [FormatDateTime('DD-MM-YY HH:MM:SS', Now), FMethodName, FMensagem]));
    end);
  end);
end;

end.
