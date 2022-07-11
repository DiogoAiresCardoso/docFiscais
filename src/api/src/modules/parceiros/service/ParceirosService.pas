unit ParceirosService;

interface

uses ParceirosEntity, Generics.Collections, DAO, IDAO, DocFiscaisAttributes, SimpleAttributes,
  ParceirosRepository, EmpresasEntity, Enums;

type
  TParceiroService = class
  private
    function GenerateRandomString(const ALength: Integer;
      const ACharSequence: String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'): String;
    { private declarations }
  protected
    { protected declarations }
    FoParceirosRepository: TParceirosRepository;
    function GerarParceiro: TParceirosEntity;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    function Inserir: TParceirosEntity; overload;
    function Inserir(const pnQuant: integer): TList<TParceirosEntity>; overload;

  end;

implementation

uses RTTI, Data.DB, DateUtils, SysUtils, Variants;


{ TParceiroService }

function TParceiroService.GerarParceiro: TParceirosEntity;
var
  oContext: TRttiContext;
  oType: TRttiType;
  oProperty: TRttiProperty;
  oCustom: TCustomAttribute;
  info: TRttiInstanceType;
  oEmpresa: TEmpresasEntity;
begin
  Result := TParceirosEntity.Create;

  oEmpresa := TEmpresasEntity.Create;
  oEmpresa.Id := 1;

  Result.Empresa := oEmpresa;
  Result.Tipo := TTipoPessoa.tpJuridica;

  try
    oContext := TRttiContext.Create;
    oType := oContext.GetType(TParceirosEntity);

    for oProperty in oType.GetProperties do
    begin
      if (oProperty.Name = 'Empresa') or (oProperty.Name = 'Tipo') then
        Continue;

      for oCustom in oProperty.GetAttributes do
      begin
        if (oCustom is AutoInc) then
        begin
          oProperty.SetValue(Result, TValue.FromVariant(Null));
          Continue;
        end;

        if oCustom is TCampoBD then
        begin
          case TCampoBD(oCustom).TypeKind of
            ftString: oProperty.SetValue(Result, TValue.From(GenerateRandomString(5)));
            ftInteger: oProperty.SetValue(Result, TValue.From(1));
            ftDateTime: oProperty.SetValue(Result, TValue.From(Now));
          end;
        end;
      end;
    end;

  finally
    oContext.Free;
  end;

end;

function TParceiroService.Inserir(const pnQuant: integer): TList<TParceirosEntity>;
var
  oList: TList<TParceirosEntity>;
  nCount : integer;
begin
  try
    oList := TList<TParceirosEntity>.Create;

    for nCount := 0 to Pred(pnQuant) do
      oList.Add(GerarParceiro);

    Result := FoParceirosRepository.Inserir(oList);
  finally
    FreeAndNil(oList);
  end;
end;

function TParceiroService.Inserir: TParceirosEntity;
begin
  Result := FoParceirosRepository.Inserir(GerarParceiro);
end;

constructor TParceiroService.Create;
begin
  FoParceirosRepository := TParceirosRepository.Create;
end;

destructor TParceiroService.Destroy;
begin
  FreeAndNil(FoParceirosRepository);
  inherited;
end;

function TParceiroService.GenerateRandomString(const ALength: Integer; const ACharSequence: String): String;
var
  Ch, SequenceLength: Integer;

begin
  SequenceLength := Length(ACharSequence);
  SetLength(Result, ALength);
  Randomize;

  for Ch := Low(Result) to High(Result) do
    Result[Ch] := ACharSequence[Random(SequenceLength)];
end;

end.
