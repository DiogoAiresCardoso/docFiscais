unit Logger;

interface


type
  TLogger = class
  private
    FMethodName: string;
    FMostrarTela: boolean;
    FMensagem: string;
    sProc: string;
    sLine: integer;
    sFile: string;
    { private declarations }
  protected
    { protected declarations }
    constructor Create;
    procedure ShowLogTela;
  public
    { public declarations }
    class procedure InserirLog(const psMessage: string; const pbMostarTela: boolean = true);

    procedure Iniciar;
    property MethodLog: string read FMethodName write FMethodName;
    property Mensagem: string read FMensagem write FMensagem;
    property MostrarTela: boolean read FMostrarTela write FMostrarTela;

  end;

implementation

uses
  SysUtils, Classes, JCLDebug, AbstractClass;

{ TLogger }

constructor TLogger.Create;
var
  nIndex: integer;
begin
  nIndex := 0;
  while (FileByLevel(nIndex) = 'Logger.pas') or
        (FileByLevel(nIndex) = 'AbstractClass.pas') do
  begin
    sFile := FileByLevel(nIndex);
    Inc(nIndex);
  end;


  sFile := FileByLevel(nIndex);
  sProc := ProcByLevel(nIndex);
  sLine := LineByLevel(nIndex);
end;

procedure TLogger.Iniciar;
begin
  if FMostrarTela then
    ShowLogTela;
end;

class procedure TLogger.InserirLog(const psMessage: string; const pbMostarTela: boolean);
var
  oLog: TLogger;
begin
  try
    oLog := TLogger.Create;
    oLog.Mensagem := psMessage;
    oLog.MostrarTela := pbMostarTela;

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
      Writeln(Format('%s - %s - %s', [FormatDateTime('DD-MM-YY HH:MM:SS', Now), sProc, FMensagem]));
    end);
  end);
end;

end.
