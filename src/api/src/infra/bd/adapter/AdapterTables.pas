unit AdapterTables;

interface

uses FireDAC.Comp.Client, AdapterAbstract;

type
  TAdapterTables = class(TAdapterAbstract)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function CreateTable(const poClass: TClass): boolean;
  end;

implementation

{ TAdapterTables }

uses InstructionSQLEntity, System.SysUtils, FireDAC.Phys.Intf, Data.DB, Logger;

function TAdapterTables.CreateTable(const poClass: TClass): boolean;
var
  oInstruction: TInstructionSQLEntity;
  sScriptCreate: string;
begin
  oInstruction := TInstructionSQLEntity.Create(poClass);
  try
    try
      FoMetaInfo.MetaInfoKind := TFDPhysMetaInfoKind.mkTables;
      FoMetaInfo.Active := False;
      FoMetaInfo.Active := True;

      FoMetaInfo.Filtered := False;
      FoMetaInfo.Filter := 'TABLE_NAME = ' + QuotedStr(oInstruction.Properties.Tabela);
      FoMetaInfo.Filtered := True;

      if not FoMetaInfo.IsEmpty then
      begin
        TLogger.InserirLog(Self.ClassName + ' - ' + oInstruction.Properties.Tabela, 'Tabela ok');
        Exit(True);
      end;

      sScriptCreate := oInstruction.SQLCreateTable;

      FoQuery.SQL.Clear;
      FoQuery.SQL.Add(sScriptCreate);
      FoQuery.ExecSQL;

      TLogger.InserirLog(Self.ClassName + ' - ' + oInstruction.Properties.Tabela, 'Tabela criada');

      Result := true;
    except
      on E: Exception do
      begin
        TLogger.InserirLog(Self.ClassName + ' - ' + oInstruction.Properties.Tabela, 'Falha ao criar tabela ' + E.Message);
        Result := False;
      end;
    end;
  finally
    oInstruction.Free;
  end;
end;

end.
