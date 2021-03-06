{ Invokable interface IWSFutSystem }

unit WSFutSystemIntf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  //tipos enumerados
  TSexo      = (tsMasculino, tsFeminino);
  TTipoCampo = (tcQuadra, tcCampo, tcSociety);
  TStatus    = (tsAtivo, tsInativo);
  TPosicao   = (tpGoleiro, tpZagueiro, tpLatDireito, tpLatEsquerdo, tpVolante,
               tpMeia, tpPonteiro, tpAtacante, tpFixo, tpAla, tpPivo);
  TTipoLogin = (tlAtleta, tlCampo);

  //tipo Atleta
  TAtleta = class(TRemotable)
  private
    FCodigo: Integer;
    FNomeCompleto: string;
    FCaracteristicas: string;
    FObservacao: string;
    FNumEndereco: Integer;
    FEmail: string;
    FBairro: string;
    FDataNasc: TDate;
    FPosicao: TPosicao;
    FCid_IBGE: Integer;
    FCEP: string;
    FStatus: TStatus;
    FSenha: string;
    FSexo: TSexo;
    FEndereco: string;
    FTelefone: string;
    FCelular: string;
    procedure SetCodigo(const Value: Integer);
    procedure SetNomeCompleto(const Value: string);
    procedure SetBairro(const Value: string);
    procedure SetCaracteristicas(const Value: string);
    procedure SetCelular(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetCid_IBGE(const Value: Integer);
    procedure SetDataNasc(const Value: TDate);
    procedure SetEmail(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetNumEndereco(const Value: Integer);
    procedure SetObservacao(const Value: string);
    procedure SetPosicao(const Value: TPosicao);
    procedure SetSenha(const Value: string);
    procedure SetSexo(const Value: TSexo);
    procedure SetStatus(const Value: TStatus);
    procedure SetTelefone(const Value: string);

  published
    property Codigo         : Integer   read FCodigo          write SetCodigo;
    property NomeCompleto   : string    read FNomeCompleto    write SetNomeCompleto;
    property DataNasc       : TDate     read FDataNasc        write SetDataNasc;
    property Sexo           : TSexo     read FSexo            write SetSexo;
    property Telefone       : string    read FTelefone        write SetTelefone;
    property Celular        : string    read FCelular         write SetCelular;
    property Endereco       : string    read FEndereco        write SetEndereco;
    property Bairro         : string    read FBairro          write SetBairro;
    property NumEndereco    : Integer   read FNumEndereco     write SetNumEndereco;
    property CEP            : string    read FCEP             write SetCEP;
    property Cid_IBGE       : Integer   read FCid_IBGE        write SetCid_IBGE;
    property Email          : string    read FEmail           write SetEmail;
    property Senha          : string    read FSenha           write SetSenha;
    property Posicao        : TPosicao  read FPosicao         write SetPosicao;
    property Status         : TStatus   read FStatus          write SetStatus;
    property Caracteristicas: string    read FCaracteristicas write SetCaracteristicas;
    property Observacao     : string    read FObservacao      write SetObservacao;
  end;


  //tipo Campo
  TCampo = class(TRemotable)
  private
    FObservacao: String;
    FNumEndereco: Integer;
    FEmail: String;
    FBairro: String;
    FCodigo: Integer;
    FResponsavel: String;
    FCid_IBGE: Integer;
    FCEP: String;
    FTipoCampo: TTipoCampo;
    FStatus: TStatus;
    FSenha: String;
    FNome: String;
    FEndereco: String;
    FTelefone: String;
    FCelular: String;
    procedure SetBairro(const Value: String);
    procedure SetCelular(const Value: String);
    procedure SetCEP(const Value: String);
    procedure SetCid_IBGE(const Value: Integer);
    procedure SetCodigo(const Value: Integer);
    procedure SetEmail(const Value: String);
    procedure SetEndereco(const Value: String);
    procedure SetNome(const Value: String);
    procedure SetNumEndereco(const Value: Integer);
    procedure SetObservacao(const Value: String);
    procedure SetResponsavel(const Value: String);
    procedure SetSenha(const Value: String);
    procedure SetStatus(const Value: TStatus);
    procedure SetTelefone(const Value: String);
    procedure SetTipoCampo(const Value: TTipoCampo);
  published
    property Codigo     : Integer    read FCodigo      write SetCodigo;
    property Nome       : String     read FNome        write SetNome;
    property Endereco   : String     read FEndereco    write SetEndereco;
    property NumEndereco: Integer    read FNumEndereco write SetNumEndereco;
    property Bairro     : String     read FBairro      write SetBairro;
    property CEP        : String     read FCEP         write SetCEP;
    property Cid_IBGE   : Integer    read FCid_IBGE    write SetCid_IBGE;
    property Email      : String     read FEmail       write SetEmail;
    property Senha      : String     read FSenha       write SetSenha;
    property TipoCampo  : TTipoCampo read FTipoCampo   write SetTipoCampo;
    property Telefone   : String     read FTelefone    write SetTelefone;
    property Celular    : String     read FCelular     write SetCelular;
    property Observacao : String     read FObservacao  write SetObservacao;
    property Responsavel: String     read FResponsavel write SetResponsavel;
    property Status     : TStatus    read FStatus      write SetStatus;
  end;


  //Tipo Cidade
  TCidade = class(TRemotable)
  private
    FEst_Codigo: Integer;
    FCodigo: Integer;
    FNome: String;
    procedure SetCodigo(const Value: Integer);
    procedure SetEst_Codigo(const Value: Integer);
    procedure SetNome(const Value: String);
  published
    property Codigo     : Integer read FCodigo write SetCodigo;
    property Nome       : String  read FNome write SetNome;
    property Est_Codigo : Integer read FEst_Codigo write SetEst_Codigo;
  end;


  //Tipo Estado
  TEstado = class(TRemotable)
  private
    FCodigo: Integer;
    FSigla: String;
    FNome: String;
    procedure SetCodigo(const Value: Integer);
    procedure SetNome(const Value: String);
    procedure SetSigla(const Value: String);
  published
    property Codigo     : Integer read FCodigo write SetCodigo;
    property Nome       : String  read FNome   write SetNome;
    property Sigla      : String  read FSigla  write SetSigla;
  end;


  //Tipo Times
  TTimes = class(TRemotable)
  private
    FCodigo: Integer;
    FDataFundacao: TDate;
    FNome: String;
    FAtl_Codigo: Integer;
    procedure SetCodigo(const Value: Integer);
    procedure SetDataFundacao(const Value: TDate);
    procedure SetNome(const Value: String);
    procedure SetAtl_Codigo(const Value: Integer);
  published
    property Codigo      : Integer  read FCodigo       write SetCodigo;
    property Nome        : String   read FNome         write SetNome;
    property DataFundacao: TDate    read FDataFundacao write SetDataFundacao;
    property Atl_Codigo  : Integer  read FAtl_Codigo   write SetAtl_Codigo;
  end;


  //Tipo TimeAtleta
  TTimeAtleta = class(TRemotable)
  private
    FTim_Codigo: Integer;
    FAtl_Codigo: Integer;
    procedure SetAtl_Codigo(const Value: Integer);
    procedure SetTim_Codigo(const Value: Integer);
  published
    property Tim_Codigo : Integer read FTim_Codigo write SetTim_Codigo;
    property Atl_Codigo : Integer read FAtl_Codigo write SetAtl_Codigo;
  end;


  //Tipo Partida
  TPartida = class(TRemotable)
  private
    FHorario: TDateTime;
    FCodigo: Integer;
    FStatus: TStatus;
    FCam_Codigo: Integer;
    FTimeB: Integer;
    FTimeA: Integer;
    FData: TDate;
    procedure SetCam_Codigo(const Value: Integer);
    procedure SetCodigo(const Value: Integer);
    procedure SetData(const Value: TDate);
    procedure SetHorario(const Value: TDateTime);
    procedure SetStatus(const Value: TStatus);
    procedure SetTimeA(const Value: Integer);
    procedure SetTimeB(const Value: Integer);
  published
    property Codigo     : Integer   read FCodigo     write SetCodigo;
    property Data       : TDate     read FData       write SetData;
    property Horario    : TDateTime read FHorario    write SetHorario;
    property Cam_Codigo : Integer   read FCam_Codigo write SetCam_Codigo;
    property Status     : TStatus   read FStatus     write SetStatus;
    property TimeA      : Integer   read FTimeA      write SetTimeA;
    property TimeB      : Integer   read FTimeB      write SetTimeB;
  end;


  //Tipo PartidaAtleta
  TPartidaAtleta = class(TRemotable)
  private
    FAtl_Codigo: Integer;
    FPar_Codigo: Integer;
    FTim_Codigo: Integer;
    FCartVermelho: Integer;
    FGols: Integer;
    FCompareceu: Boolean;
    FAssistencias: Integer;
    FCartAmarelo: Integer;
    procedure SetAtl_Codigo(const Value: Integer);
    procedure SetPar_Codigo(const Value: Integer);
    procedure SetTim_Codigo(const Value: Integer);
    procedure SetAssistencias(const Value: Integer);
    procedure SetCartAmarelo(const Value: Integer);
    procedure SetCartVermelho(const Value: Integer);
    procedure SetCompareceu(const Value: Boolean);
    procedure SetGols(const Value: Integer);
  published
    property Par_Codigo  : Integer read FPar_Codigo   write SetPar_Codigo;
    property Atl_Codigo  : Integer read FAtl_Codigo   write SetAtl_Codigo;
    property Tim_Codigo  : Integer read FTim_Codigo   write SetTim_Codigo;
    property Gols        : Integer read FGols         write SetGols;
    property CartAmarelo : Integer read FCartAmarelo  write SetCartAmarelo;
    property CartVermelho: Integer read FCartVermelho write SetCartVermelho;
    property Assistencias: Integer read FAssistencias write SetAssistencias;
    property Compareceu  : Boolean read FCompareceu   write SetCompareceu;
  end;

  //arrays
  TListEstados         = array of TEstado;
  TListCidades         = array of TCidade;
  TListAtletas         = array of TAtleta;
  TListCampos          = array of TCampo;
  TListTimes           = array of TTimes;
  TListPartidas        = array of TPartida;
  TListPartidasAtletas = array of TPartidaAtleta;
  TListTimesAtletas    = array of TTimeAtleta;




  { Invokable interfaces must derive from IInvokable }
  IWSFutSystem = interface(IInvokable)
  ['{3C6F0823-49FA-42FE-8874-C1B0D3C51F6D}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }

    //get
    function GetAtletas(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListAtletas; stdcall;
    function GetCampos(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListCampos; stdcall;
    function GetCidades(UF: string): TListCidades; stdcall;
    function GetEstados: TListEstados; stdcall;
    function GetPartidas(const Codigo: Integer = 0): TListPartidas; stdcall;
    function GetPartidasAtletas(const Par_Codigo: Integer = 0; const Atl_Codigo: Integer = 0): TListPartidasAtletas; stdcall;
    function GetTimes(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListTimes; stdcall;
    function GetTimesAtletas(const Tim_Codigo: Integer = 0; const Atl_Codigo: Integer = 0): TListTimesAtletas; stdcall;
    function ValidaLogin(Email,Senha: string; TipoLogin : TTipoLogin): Integer; stdcall;

    //Set
    function SetAtleta(Atleta : TAtleta): Boolean; stdcall;
    function SetCampo(Campo : TCampo): Boolean; stdcall;
    function SetPartida(Partida : TPartida): Boolean; stdcall;
    function SetPartidaAtletas(Atletas_Partida: TListPartidasAtletas): Boolean; stdcall;
    function SetTime(Equipe : TTimes) : Boolean; stdcall;
    function SetTimeAtletas(Atletas_Times: TListTimesAtletas): Boolean; stdcall;

    //Delete
    function DeletePartidaAtleta(Par_Codigo, Atl_Codigo, Tim_Codigo: Integer): Boolean;
    function DeleteTimeAtleta(Atl_Codigo, Tim_Codigo: Integer): Boolean;
  end;

implementation

{ TAtleta }

procedure TAtleta.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TAtleta.SetCaracteristicas(const Value: string);
begin
  FCaracteristicas := Value;
end;

procedure TAtleta.SetCelular(const Value: string);
begin
  FCelular := Value;
end;

procedure TAtleta.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TAtleta.SetCid_IBGE(const Value: Integer);
begin
  FCid_IBGE := Value;
end;

procedure TAtleta.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TAtleta.SetDataNasc(const Value: TDate);
begin
  FDataNasc := Value;
end;

procedure TAtleta.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TAtleta.SetEndereco(const Value: string);
begin
  FEndereco := Value;
end;

procedure TAtleta.SetNomeCompleto(const Value: string);
begin
  FNomeCompleto := Value;
end;

procedure TAtleta.SetNumEndereco(const Value: Integer);
begin
  FNumEndereco := Value;
end;

procedure TAtleta.SetObservacao(const Value: string);
begin
  FObservacao := Value;
end;

procedure TAtleta.SetPosicao(const Value: TPosicao);
begin
  FPosicao := Value;
end;

procedure TAtleta.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TAtleta.SetSexo(const Value: TSexo);
begin
  FSexo := Value;
end;

procedure TAtleta.SetStatus(const Value: TStatus);
begin
  FStatus := Value;
end;

procedure TAtleta.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

{ TCampo }

procedure TCampo.SetBairro(const Value: String);
begin
  FBairro := Value;
end;

procedure TCampo.SetCelular(const Value: String);
begin
  FCelular := Value;
end;

procedure TCampo.SetCEP(const Value: String);
begin
  FCEP := Value;
end;

procedure TCampo.SetCid_IBGE(const Value: Integer);
begin
  FCid_IBGE := Value;
end;

procedure TCampo.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCampo.SetEmail(const Value: String);
begin
  FEmail := Value;
end;

procedure TCampo.SetEndereco(const Value: String);
begin
  FEndereco := Value;
end;

procedure TCampo.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TCampo.SetNumEndereco(const Value: Integer);
begin
  FNumEndereco := Value;
end;

procedure TCampo.SetObservacao(const Value: String);
begin
  FObservacao := Value;
end;

procedure TCampo.SetResponsavel(const Value: String);
begin
  FResponsavel := Value;
end;

procedure TCampo.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TCampo.SetStatus(const Value: TStatus);
begin
  FStatus := Value;
end;

procedure TCampo.SetTelefone(const Value: String);
begin
  FTelefone := Value;
end;

procedure TCampo.SetTipoCampo(const Value: TTipoCampo);
begin
  FTipoCampo := Value;
end;

{ TCidade }

procedure TCidade.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCidade.SetEst_Codigo(const Value: Integer);
begin
  FEst_Codigo := Value;
end;

procedure TCidade.SetNome(const Value: String);
begin
  FNome := Value;
end;

{ TEstado }

procedure TEstado.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TEstado.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TEstado.SetSigla(const Value: String);
begin
  FSigla := Value;
end;

{ TTime }

procedure TTimes.SetAtl_Codigo(const Value: Integer);
begin
  FAtl_Codigo := Value;
end;

procedure TTimes.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TTimes.SetDataFundacao(const Value: TDate);
begin
  FDataFundacao := Value;
end;

procedure TTimes.SetNome(const Value: String);
begin
  FNome := Value;
end;

{ TTimeAtleta }

procedure TTimeAtleta.SetAtl_Codigo(const Value: Integer);
begin
  FAtl_Codigo := Value;
end;

procedure TTimeAtleta.SetTim_Codigo(const Value: Integer);
begin
  FTim_Codigo := Value;
end;

{ TPartida }

procedure TPartida.SetCam_Codigo(const Value: Integer);
begin
  FCam_Codigo := Value;
end;

procedure TPartida.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TPartida.SetData(const Value: TDate);
begin
  FData := Value;
end;

procedure TPartida.SetHorario(const Value: TDateTime);
begin
  FHorario := Value;
end;

procedure TPartida.SetStatus(const Value: TStatus);
begin
  FStatus := Value;
end;

procedure TPartida.SetTimeA(const Value: Integer);
begin
  FTimeA := Value;
end;

procedure TPartida.SetTimeB(const Value: Integer);
begin
  FTimeB := Value;
end;

{ TPartidaAtleta }

procedure TPartidaAtleta.SetAssistencias(const Value: Integer);
begin
  FAssistencias := Value;
end;

procedure TPartidaAtleta.SetAtl_Codigo(const Value: Integer);
begin
  FAtl_Codigo := Value;
end;

procedure TPartidaAtleta.SetCartAmarelo(const Value: Integer);
begin
  FCartAmarelo := Value;
end;

procedure TPartidaAtleta.SetCartVermelho(const Value: Integer);
begin
  FCartVermelho := Value;
end;

procedure TPartidaAtleta.SetCompareceu(const Value: Boolean);
begin
  FCompareceu := Value;
end;

procedure TPartidaAtleta.SetGols(const Value: Integer);
begin
  FGols := Value;
end;

procedure TPartidaAtleta.SetPar_Codigo(const Value: Integer);
begin
  FPar_Codigo := Value;
end;

procedure TPartidaAtleta.SetTim_Codigo(const Value: Integer);
begin
  FTim_Codigo := Value;
end;

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IWSFutSystem));

end.
