unit ConfiguracaoBD;

interface

uses Conexao, Logger, Query, ClassRTTI, System.Classes, EmpresasEntity, ParceirosEntity, Adapter, AbstractClass;

type
  TConfiguracaoBD = class(TAbstractClass)
  private
    { private declarations }
    FoAdapter: TAdapter;
  protected
    { protected declarations }
  public
    { public declarations }
    function ConfigurarBancoDados: boolean;
  end;

implementation

uses
  SysUtils, FireDAC.Comp.Client, Data.DB,
  RTTI, DocFiscaisAttributes, FireDAC.Comp.DataSet,
  StrUtils, ParametrosEntity;

{ TConfiguracaoBD }

function TConfiguracaoBD.ConfigurarBancoDados: boolean;
begin
  try
    FoAdapter := TAdapter.Create;

    Result := True;

    FoAdapter.StartAdapter;
  finally
    FreeAndNil(FoAdapter);
  end;
end;

end.
