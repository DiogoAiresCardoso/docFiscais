unit AdapterTables;

interface

uses FireDAC.Comp.Client, AdapterAbstract;

type
  TAdapterTables = class sealed(TAdapterAbstract)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function CreateTable(const poClass: TClass): boolean;
    function CreateColumn(const poClass: TClass): boolean;
  end;

implementation

{ TAdapterTables }

uses InstructionSQLEntity, System.SysUtils, FireDAC.Phys.Intf, Data.DB, Logger;

function TAdapterTables.CreateColumn(const poClass: TClass): boolean;
var
  oInstruction: TInstructionSQLEntity;
  I: integer;
  sScriptCreateColumn: string;
begin
  oInstruction := TInstructionSQLEntity.Create(poClass);
  Result := True;
  try
    FoMetaInfo.Active := False;
    FoMetaInfo.MetaInfoKind := TFDPhysMetaInfoKind.mkTableFields;
    FoMetaInfo.SchemaName := oInstruction.Properties.Schema;
    FoMetaInfo.ObjectName := oInstruction.Properties.Table;
    FoMetaInfo.Active := True;

    for I := 0 to Pred(oInstruction.Properties.Fields.Count) do
    begin
      if not Result then
        Break;

      FoMetaInfo.Filtered := False;
      FoMetaInfo.Filter := 'COLUMN_NAME = ' + QuotedStr(oInstruction.Properties.Fields.Items[I].FieldNameBD);
      FoMetaInfo.Filtered := True;

      if not FoMetaInfo.IsEmpty then
        Continue;

      try
        sScriptCreateColumn := oInstruction.SQLCreateColumn(I);
        FoQuery.SQL.Clear;
        FoQuery.SQL.Add(sScriptCreateColumn);
        FoQuery.ExecSQL;

        TLogger.InserirLog(oInstruction.Properties.Fields.Items[I].FieldNameBD + ' coluna criada');
      except
        on E : Exception do
        begin
          TLogger.InserirLog(oInstruction.Properties.Fields.Items[I].FieldNameBD + ' falha ao criar coluna ' + E.Message);
          Result := False;
        end;
      end;
    end;
  finally
    FreeAndNil(oInstruction);
  end;
end;

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
      FoMetaInfo.Filter := 'TABLE_NAME = ' + QuotedStr(oInstruction.Properties.Table);
      FoMetaInfo.Filtered := True;

      if not FoMetaInfo.IsEmpty then
      begin
        TLogger.InserirLog(oInstruction.Properties.Table + ' ok');
        Exit(True);
      end;

      sScriptCreate := oInstruction.SQLCreateTable;

      FoQuery.SQL.Clear;
      FoQuery.SQL.Add(sScriptCreate);
      FoQuery.ExecSQL;

      TLogger.InserirLog(oInstruction.Properties.Table + ' criada');

      Result := true;
    except
      on E: Exception do
      begin
        TLogger.InserirLog(oInstruction.Properties.Table + ' falha ao criar tabela ' + E.Message);
        Result := False;
      end;
    end;
  finally
    FreeAndNil(oInstruction);
  end;
end;

end.
