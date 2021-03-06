{ Invokable implementation File for TWSFutSystem which implements IWSFutSystem }

unit WSFutSystemImpl;

interface

uses
  Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, WSFutSystemIntf, System.SysUtils;

type

  { TWSFutSystem }
  TWSFutSystem = class(TInvokableClass, IWSFutSystem)
  public
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
    function SetAtleta(Atleta: TAtleta)   : Boolean; stdcall;
    function SetCampo(Campo: TCampo)      : Boolean; stdcall;
    function SetPartida(Partida: TPartida): Boolean; stdcall;
    function SetPartidaAtletas(Atletas_Partida: TListPartidasAtletas): Boolean; stdcall;
    function SetTime(Equipe: TTimes)      : Boolean; stdcall;
    function SetTimeAtletas(Atletas_Times: TListTimesAtletas): Boolean; stdcall;

    //Delete
    function DeletePartidaAtleta(Par_Codigo, Atl_Codigo, Tim_Codigo: Integer): Boolean;
    function DeleteTimeAtleta(Atl_Codigo, Tim_Codigo: Integer): Boolean;

  end;

implementation


{ TWSFutSystem }

uses UFuncoes, UDModulo;

function TWSFutSystem.DeletePartidaAtleta(Par_Codigo, Atl_Codigo, Tim_Codigo: Integer): Boolean;
begin
  Result := False;
  try
    DModulo.DBStartTrans;
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM Partidas_Atletas');
      SQL.Add('WHERE Tim_Codigo = :Tim_Codigo and Atl_Codigo = :Atl_Codigo');
      SQL.Add('      AND Par_Codigo = :Par_Codigo ');
      ParamByName('Tim_Codigo').AsInteger  := Tim_Codigo;
      ParamByName('Par_Codigo').AsInteger  := Par_Codigo;
      ParamByName('Atl_Codigo').AsInteger  := Atl_Codigo;
      ExecSQL();

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo DeletePartidaAtleta. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.DeleteTimeAtleta(Atl_Codigo, Tim_Codigo: Integer): Boolean;
begin
  Result := False;
  try
    DModulo.DBStartTrans;
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM Times_Atletas');
      SQL.Add('WHERE Tim_Codigo = :Tim_Codigo and Atl_Codigo = :Atl_Codigo');
      ParamByName('Tim_Codigo').AsInteger  := Tim_Codigo;
      ParamByName('Atl_Codigo').AsInteger  := Atl_Codigo;
      ExecSQL();

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo DeleteTimeAtleta. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.GetAtletas(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListAtletas;
var
  ListaAtletas: TListAtletas;
  Atleta : TAtleta;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Atletas');
      SQL.Add('WHERE 1 > 0');
      if Codigo > 0 then
        SQL.Add('AND Atl_Codigo = :Codigo');
      if Cid_IBGE > 0 then
        SQL.Add('AND Cid_IBGE = :Cid_IBGE');
      if Codigo > 0 then
        ParamByName('Codigo').AsInteger  := Codigo;
      if Cid_IBGE > 0 then
        ParamByName('Cid_IBGE').AsInteger:= Cid_IBGE;
      Open();
      Last;
      First;
    end;

    SetLength(ListaAtletas, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de atletas
      with Atleta do
      begin
        Atleta          := TAtleta.Create;

        Codigo          := DModulo.fdqAuxiliar.FieldByName('Atl_Codigo').AsInteger;
        NomeCompleto    := DModulo.fdqAuxiliar.FieldByName('Atl_NomeCompleto').AsString;
        DataNasc        := DModulo.fdqAuxiliar.FieldByName('Atl_DataNasc').AsDateTime;
        Sexo            := iif(DModulo.fdqAuxiliar.FieldByName('Atl_Sexo').AsString = 'M', tsMasculino, tsFeminino);
        Telefone        := DModulo.fdqAuxiliar.FieldByName('Atl_Telefone').AsString;
        Celular         := DModulo.fdqAuxiliar.FieldByName('Atl_Celular').AsString;
        Endereco        := DModulo.fdqAuxiliar.FieldByName('Atl_Endereco').AsString;
        Bairro          := DModulo.fdqAuxiliar.FieldByName('Atl_Bairro').AsString;
        NumEndereco     := DModulo.fdqAuxiliar.FieldByName('Atl_NumEndereco').AsInteger;
        CEP             := DModulo.fdqAuxiliar.FieldByName('Atl_CEP').AsString;
        Cid_IBGE        := DModulo.fdqAuxiliar.FieldByName('Cid_IBGE').AsInteger;
        Email           := DModulo.fdqAuxiliar.FieldByName('Atl_Email').AsString;
        Senha           := DModulo.fdqAuxiliar.FieldByName('Atl_Senha').AsString;
        Posicao         := TPosicao(DModulo.fdqAuxiliar.FieldByName('Atl_Posicao').AsInteger);
        Status          := iif(DModulo.fdqAuxiliar.FieldByName('Atl_Status').AsString = 'A', tsAtivo, tsInativo);
        Caracteristicas := DModulo.fdqAuxiliar.FieldByName('Atl_Caracteristica').AsString;
        Observacao      := DModulo.fdqAuxiliar.FieldByName('Atl_Obs').AsString;
      end;

      ListaAtletas[DModulo.fdqAuxiliar.RecNo -1]   := Atleta;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaAtletas;
    Finalize(ListaAtletas);
    //Atleta.Free;
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetAtletas. ' + e.Message);
  end;
end;

function TWSFutSystem.GetCampos(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListCampos;
var
  ListaCampos: TListCampos;
  Campo : TCampo;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Campos');
      SQL.Add('WHERE 1 > 0');
      if Codigo > 0 then
        SQL.Add('AND Cam_Codigo = :Codigo');
      if Cid_IBGE > 0 then
        SQL.Add('AND Cid_IBGE = :Cid_IBGE');
      if Codigo > 0 then
        ParamByName('Codigo').AsInteger  := Codigo;
      if Cid_IBGE > 0 then
        ParamByName('Cid_IBGE').AsInteger:= Cid_IBGE;
      Open();
      Last;
      First;
    end;

    SetLength(ListaCampos, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de campos do servidor
      with Campo do
      begin
        Campo       := TCampo.Create;
        Codigo      := DModulo.fdqAuxiliar.FieldByName('Cam_Codigo').AsInteger;
        Nome        := DModulo.fdqAuxiliar.FieldByName('Cam_Nome').AsString;
        Endereco    := DModulo.fdqAuxiliar.FieldByName('Cam_Endereco').AsString;
        NumEndereco := DModulo.fdqAuxiliar.FieldByName('Cam_NumEndereco').AsInteger;
        Bairro      := DModulo.fdqAuxiliar.FieldByName('Cam_Bairro').AsString;
        CEP         := DModulo.fdqAuxiliar.FieldByName('Cam_CEP').AsString;
        Cid_IBGE    := DModulo.fdqAuxiliar.FieldByName('Cid_IBGE').AsInteger;
        Email       := DModulo.fdqAuxiliar.FieldByName('Cam_Email').AsString;
        Senha       := DModulo.fdqAuxiliar.FieldByName('Cam_Senha').AsString;
        TipoCampo   := TTipoCampo(DModulo.fdqAuxiliar.FieldByName('Cam_TipoCampo').AsInteger);
        Status      := iif(DModulo.fdqAuxiliar.FieldByName('Cam_Status').AsString = 'A', tsAtivo, tsInativo);
        Telefone    := DModulo.fdqAuxiliar.FieldByName('Cam_Telefone').AsString;
        Celular     := DModulo.fdqAuxiliar.FieldByName('Cam_Celular').AsString;
        Observacao  := DModulo.fdqAuxiliar.FieldByName('Cam_Obs').AsString;
        Responsavel := DModulo.fdqAuxiliar.FieldByName('Cam_Responsavel').AsString;
      end;
      ListaCampos[DModulo.fdqAuxiliar.RecNo -1] := Campo;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaCampos;
    Finalize(ListaCampos);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetCampos. ' + e.Message);
  end;
end;

function TWSFutSystem.GetCidades(UF: string): TListCidades;
var
  ListaCidades: TListCidades;
  Cidade : TCidade;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT C.* FROM CIDADES C');
      SQL.Add('INNER JOIN ESTADOS E ON E.EST_CODIGO = C.EST_CODIGO');
      SQL.Add('WHERE');
      SQL.Add('  EST_SIGLA = :SIGLA');
      ParamByName('SIGLA').AsString := UF;
      Open();
      Last;
      First;
    end;

    SetLength(ListaCidades, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de cidades do servidor
      with Cidade do
      begin
        Cidade     := TCidade.Create;
        Codigo     := DModulo.fdqAuxiliar.FieldByName('Cid_IBGE').AsInteger;
        Nome       := DModulo.fdqAuxiliar.FieldByName('Cid_Nome').AsString;
        Est_Codigo := DModulo.fdqAuxiliar.FieldByName('Est_Codigo').AsInteger;
      end;
      ListaCidades[DModulo.fdqAuxiliar.RecNo - 1] := Cidade;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaCidades;
    Finalize(ListaCidades);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetCidades. ' + e.Message);
  end;
end;

function TWSFutSystem.GetEstados: TListEstados;
var
  ListaUF: TListEstados;
  Estado : TEstado;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ESTADOS');
      Open();
      Last;
      First;
    end;

    SetLength(ListaUF, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de estados do servidor
      with Estado do
      begin
        Estado := TEstado.Create;
        Codigo := DModulo.fdqAuxiliar.FieldByName('Est_Codigo').AsInteger;
        Nome   := DModulo.fdqAuxiliar.FieldByName('Est_Nome').AsString;
        Sigla  := DModulo.fdqAuxiliar.FieldByName('Est_Sigla').AsString;
      end;
      ListaUF[DModulo.fdqAuxiliar.RecNo - 1] := Estado;

      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaUF;
    Finalize(ListaUF);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetEstados. ' + e.Message);
  end;
end;

function TWSFutSystem.GetPartidas(const Codigo: Integer = 0): TListPartidas;
var
  ListaPartidas: TListPartidas;
  Partida : TPartida;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Partidas');
      if Codigo > 0 then
      begin
        SQL.Add('WHERE');
        SQL.Add('  Par_Codigo = :Codigo');
        ParamByName('Codigo').AsInteger := Codigo;
      end;
      Open();
      Last;
      First;
    end;

    SetLength(ListaPartidas, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de partidas
      with Partida do
      begin
        Partida   := TPartida.Create;
        Codigo    := DModulo.fdqAuxiliar.FieldByName('Par_Codigo').AsInteger;
        Data      := DModulo.fdqAuxiliar.FieldByName('Par_Data').AsDateTime;
        Horario   := DModulo.fdqAuxiliar.FieldByName('Par_Horario').AsDateTime;
        Cam_Codigo:= DModulo.fdqAuxiliar.FieldByName('Cam_Codigo').AsInteger;
        Status    := iif(DModulo.fdqAuxiliar.FieldByName('Par_Status').AsString = 'A', tsAtivo, tsInativo);
        TimeA     := DModulo.fdqAuxiliar.FieldByName('Par_TimeA').AsInteger;
        TimeB     := DModulo.fdqAuxiliar.FieldByName('Par_TimeB').AsInteger;
      end;
      ListaPartidas[DModulo.fdqAuxiliar.RecNo - 1] := Partida;

      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaPartidas;
    Finalize(ListaPartidas);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetPartidas. ' + e.Message);
  end;
end;

function TWSFutSystem.GetPartidasAtletas(const Par_Codigo: Integer = 0; const Atl_Codigo: Integer = 0): TListPartidasAtletas;
var
  ListaPartAtletas: TListPartidasAtletas;
  PartidaAtletas : TPartidaAtleta;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Partidas_Atletas');
      if (Par_Codigo > 0) or (Atl_Codigo > 0) then
      begin
        SQL.Add('WHERE');
        if Par_Codigo > 0 then
        begin
          SQL.Add('  Par_Codigo = :Codigo');
          ParamByName('Codigo').AsInteger := Par_Codigo;
        end
        else
        begin
          SQL.Add('  Atl_Codigo = :Codigo');
          ParamByName('Codigo').AsInteger := Atl_Codigo;
        end;
      end;
      Open();
      Last;
      First;
    end;

    SetLength(ListaPartAtletas, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de atletas das partidas
      with PartidaAtletas do
      begin
        PartidaAtletas := TPartidaAtleta.Create;
        Atl_Codigo     := DModulo.fdqAuxiliar.FieldByName('Atl_Codigo').AsInteger;
        Par_Codigo     := DModulo.fdqAuxiliar.FieldByName('Par_Codigo').AsInteger;
        Tim_Codigo     := DModulo.fdqAuxiliar.FieldByName('Tim_Codigo').AsInteger;
        Gols           := DModulo.fdqAuxiliar.FieldByName('Pta_Gols').AsInteger;
        CartAmarelo    := DModulo.fdqAuxiliar.FieldByName('Pta_CAmarelos').AsInteger;
        CartVermelho   := DModulo.fdqAuxiliar.FieldByName('Pta_CVermelhos').AsInteger;
        Assistencias   := DModulo.fdqAuxiliar.FieldByName('Pta_Assistencias').AsInteger;
        Compareceu     := iif(DModulo.fdqAuxiliar.FieldByName('Pta_Compareceu').AsString = 'S', True, False);
      end;
      ListaPartAtletas[DModulo.fdqAuxiliar.RecNo - 1] := PartidaAtletas;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaPartAtletas;
    Finalize(ListaPartAtletas);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetPartidasAtletas. ' + e.Message);
  end;
end;

function TWSFutSystem.GetTimes(const Codigo: Integer = 0; const Cid_IBGE: Integer = 0): TListTimes;
var
  ListaTimes: TListTimes;
  Equipe  : TTimes;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Times');
      SQL.Add('WHERE 1 > 0');
      if Codigo > 0 then
        SQL.Add('AND Tim_Codigo = :Tim_Codigo');
      if Cid_IBGE > 0 then
        SQL.Add('AND Cid_IBGE = :Cid_IBGE');
      if Codigo > 0 then
        ParamByName('Codigo').AsInteger  := Codigo;
      if Cid_IBGE > 0 then
        ParamByName('Cid_IBGE').AsInteger:= Cid_IBGE;
      Open();
      Last;
      First;
    end;

    SetLength(ListaTimes, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de times
      with Equipe do
      begin
        Equipe       := TTimes.Create;
        Codigo       := DModulo.fdqAuxiliar.FieldByName('Tim_Codigo').AsInteger;
        Nome         := DModulo.fdqAuxiliar.FieldByName('Tim_Nome').AsString;
        DataFundacao := DModulo.fdqAuxiliar.FieldByName('Tim_DataFundacao').AsDateTime;
        Atl_Codigo   := DModulo.fdqAuxiliar.FieldByName('Atl_Codigo').AsInteger;
      end;
      ListaTimes[DModulo.fdqAuxiliar.RecNo - 1]  := Equipe;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaTimes;
    Finalize(ListaTimes);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetTimes. ' + e.Message);
  end;
end;

function TWSFutSystem.GetTimesAtletas(const Tim_Codigo: Integer = 0; const Atl_Codigo: Integer = 0): TListTimesAtletas;
var
  ListaTimesAtletas: TListTimesAtletas;
  TimeAtletas : TTimeAtleta;
begin
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Times_Atletas');
      if (Tim_Codigo > 0) or (Atl_Codigo > 0) then
      begin
        SQL.Add('WHERE');
        if Tim_Codigo > 0 then
        begin
          SQL.Add('  Tim_Codigo = :Codigo');
          ParamByName('Codigo').AsInteger := Tim_Codigo;
        end
        else
        begin
          SQL.Add('  Atl_Codigo = :Codigo');
          ParamByName('Codigo').AsInteger := Atl_Codigo;
        end;
      end;
      Open();
      Last;
      First;
    end;

    SetLength(ListaTimesAtletas, DModulo.fdqAuxiliar.RecordCount);

    while not DModulo.fdqAuxiliar.Eof do
    begin
      //puxa lista de atletas dos times
      with TimeAtletas do
      begin
        TimeAtletas:= TTimeAtleta.Create;
        Atl_Codigo := DModulo.fdqAuxiliar.FieldByName('Atl_Codigo').AsInteger;
        Tim_Codigo := DModulo.fdqAuxiliar.FieldByName('Tim_Codigo').AsInteger;
      end;
      ListaTimesAtletas[DModulo.fdqAuxiliar.RecordCount -1] := TimeAtletas;
      DModulo.fdqAuxiliar.Next;
    end;

    Result := ListaTimesAtletas;
    Finalize(ListaTimesAtletas);
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo GetTimesAtletas. ' + e.Message);
  end;
end;

function TWSFutSystem.SetAtleta(Atleta: TAtleta): Boolean;
begin
  Result:= False;
  try
    if Atleta.Codigo = 0 then
      Atleta.Codigo := DModulo.RetornaProxCodigo('Atletas', 'Atl_Codigo');

    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Atl_Codigo FROM Atletas');
      SQL.Add('WHERE Atl_Codigo = :Atl_Codigo');
      ParamByName('Atl_Codigo').AsInteger  := Atleta.Codigo;
      Open();

      DModulo.DBStartTrans;

      Close;
      SQL.Clear;
      if IsEmpty then
      begin
        SQL.Add('INSERT INTO Atletas');
        SQL.Add('(Atl_Codigo, Atl_NomeCompleto, Atl_DataNasc, Atl_Sexo, Atl_Status,');
        SQL.Add('Atl_Telefone, Atl_Celular, Atl_Endereco, Atl_Bairro, Atl_NumEndereco,');
        SQL.Add('Atl_CEP, Cid_IBGE, Atl_Email, Atl_Senha, Atl_Posicao, Atl_Obs, Atl_Caracteristica)');
        SQL.Add('VALUES');
        SQL.Add('(:Atl_Codigo, :Atl_NomeCompleto, :Atl_DataNasc, :Atl_Sexo, :Atl_Status,');
        SQL.Add(':Atl_Telefone, :Atl_Celular, :Atl_Endereco, :Atl_Bairro, :Atl_NumEndereco,');
        SQL.Add(':Atl_CEP, :Cid_IBGE, :Atl_Email, :Atl_Senha, :Atl_Posicao, :Atl_Obs, :Atl_Caracteristica)');
      end
      else
      begin
        SQL.Add('UPDATE Atletas SET');
        SQL.Add('  Atl_NomeCompleto   = :Atl_NomeCompleto,');
        SQL.Add('  Atl_DataNasc       = :Atl_DataNasc,');
        SQL.Add('  Atl_Sexo           = :Atl_Sexo,');
        SQL.Add('  Atl_Status         = :Atl_Status,');
        SQL.Add('  Atl_Telefone       = :Atl_Telefone,');
        SQL.Add('  Atl_Celular        = :Atl_Celular,');
        SQL.Add('  Atl_Endereco       = :Atl_Endereco,');
        SQL.Add('  Atl_Bairro         = :Atl_Bairro,');
        SQL.Add('  Atl_NumEndereco    = :Atl_NumEndereco,');
        SQL.Add('  Atl_CEP            = :Atl_CEP,');
        SQL.Add('  Cid_IBGE           = :Cid_IBGE,');
        SQL.Add('  Atl_Email          = :Atl_Email,');
        SQL.Add('  Atl_Senha          = :Atl_Senha,');
        SQL.Add('  Atl_Posicao        = :Atl_Posicao,');
        SQL.Add('  Atl_Obs            = :Atl_Obs,');
        SQL.Add('  Atl_Caracteristica = :Atl_Caracteristica');
        SQL.Add('WHERE');
        SQL.Add('  Atl_Codigo = :Atl_Codigo');
      end;
      ParamByName('Atl_Codigo').AsInteger       := Atleta.Codigo;
      ParamByName('Atl_NomeCompleto').AsString  := Atleta.NomeCompleto;
      ParamByName('Atl_DataNasc').AsDateTime    := Atleta.DataNasc;
      ParamByName('Atl_Sexo').AsString          := iif(Atleta.Sexo = tsMasculino, 'M', 'F');
      ParamByName('Atl_Status').AsString        := iif(Atleta.Status = tsAtivo, 'A', 'I');
      ParamByName('Atl_Telefone').AsString      := Atleta.Telefone;
      ParamByName('Atl_Celular').AsString       := Atleta.Celular;
      ParamByName('Atl_Endereco').AsString      := Atleta.Endereco;
      ParamByName('Atl_Bairro').AsString        := Atleta.Bairro;
      ParamByName('Atl_NumEndereco').AsInteger  := Atleta.NumEndereco;
      ParamByName('Atl_CEP').AsString           := Atleta.CEP;
      ParamByName('Cid_IBGE').AsInteger         := Atleta.Cid_IBGE;
      ParamByName('Atl_Email').AsString         := Atleta.Email;
      ParamByName('Atl_Senha').AsString         := Atleta.Senha;
      ParamByName('Atl_Posicao').AsInteger      := Ord(Atleta.Posicao);
      ParamByName('Atl_Obs').AsString           := Atleta.Observacao;
      ParamByName('Atl_Caracteristica').AsString:= Atleta.Caracteristicas;
      ExecSQL;

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetAtleta. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.SetCampo(Campo: TCampo): Boolean;
begin
  Result:= False;
  try
    if Campo.Codigo = 0 then
      Campo.Codigo := DModulo.RetornaProxCodigo('Campos', 'Cam_Codigo');

    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Cam_Codigo FROM Campos');
      SQL.Add('WHERE Cam_Codigo = :Cam_Codigo');
      ParamByName('Cam_Codigo').AsInteger  := Campo.Codigo;
      Open();

      DModulo.DBStartTrans;

      Close;
      SQL.Clear;
      if IsEmpty then
      begin
        SQL.Add('INSERT INTO Campos');
        SQL.Add('(Cam_Codigo, Cam_Nome, Cam_Responsavel, Cam_Status,');
        SQL.Add('Cam_Telefone, Cam_Celular, Cam_Endereco, Cam_Bairro, Cam_NumEndereco,');
        SQL.Add('Cam_CEP, Cid_IBGE, Cam_Email, Cam_Senha, Cam_TipoCampo, Cam_Obs)');
        SQL.Add('VALUES');
        SQL.Add('(:Cam_Codigo, :Cam_Nome, :Cam_Responsavel, :Cam_Status,');
        SQL.Add(':Cam_Telefone, :Cam_Celular, :Cam_Endereco, :Cam_Bairro, :Cam_NumEndereco,');
        SQL.Add(':Cam_CEP, :Cid_IBGE, :Cam_Email, :Cam_Senha, :Cam_TipoCampo, :Cam_Obs)');
      end
      else
      begin
        SQL.Add('UPDATE Campos SET');
        SQL.Add('  Cam_Nome        = :Cam_Nome,');
        SQL.Add('  Cam_Status      = :Cam_Status,');
        SQL.Add('  Cam_Telefone    = :Cam_Telefone,');
        SQL.Add('  Cam_Celular     = :Cam_Celular,');
        SQL.Add('  Cam_Endereco    = :Cam_Endereco,');
        SQL.Add('  Cam_Bairro      = :Cam_Bairro,');
        SQL.Add('  Cam_NumEndereco = :Cam_NumEndereco,');
        SQL.Add('  Cam_CEP         = :Cam_CEP,');
        SQL.Add('  Cid_IBGE        = :Cid_IBGE,');
        SQL.Add('  Cam_Email       = :Cam_Email,');
        SQL.Add('  Cam_Senha       = :Cam_Senha,');
        SQL.Add('  Cam_TipoCampo   = :Cam_TipoCampo,');
        SQL.Add('  Cam_Obs         = :Cam_Obs,');
        SQL.Add('  Cam_Responsavel = :Cam_Responsavel');
        SQL.Add('WHERE');
        SQL.Add('  Cam_Codigo = :Cam_Codigo');
      end;
      ParamByName('Cam_Codigo').AsInteger       := Campo.Codigo;
      ParamByName('Cam_Nome').AsString          := Campo.Nome;
      ParamByName('Cam_Status').AsString        := iif(Campo.Status = tsAtivo, 'A', 'I');
      ParamByName('Cam_Telefone').AsString      := Campo.Telefone;
      ParamByName('Cam_Celular').AsString       := Campo.Celular;
      ParamByName('Cam_Endereco').AsString      := Campo.Endereco;
      ParamByName('Cam_Bairro').AsString        := Campo.Bairro;
      ParamByName('Cam_NumEndereco').AsInteger  := Campo.NumEndereco;
      ParamByName('Cam_CEP').AsString           := Campo.CEP;
      ParamByName('Cid_IBGE').AsInteger         := Campo.Cid_IBGE;
      ParamByName('Cam_Email').AsString         := Campo.Email;
      ParamByName('Cam_Senha').AsString         := Campo.Senha;
      ParamByName('Cam_TipoCampo').AsInteger    := Ord(Campo.TipoCampo);
      ParamByName('Cam_Obs').AsString           := Campo.Observacao;
      ParamByName('Cam_Responsavel').AsString   := Campo.Responsavel;
      ExecSQL;

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetCampo. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.SetPartida(Partida: TPartida): Boolean;
begin
  Result:= False;
  try
    if Partida.Codigo = 0 then
      Partida.Codigo := DModulo.RetornaProxCodigo('Partidas', 'Par_Codigo');

    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Par_Codigo FROM Partidas');
      SQL.Add('WHERE Par_Codigo = :Par_Codigo');
      ParamByName('Par_Codigo').AsInteger  := Partida.Codigo;
      Open();

      DModulo.DBStartTrans;

      Close;
      SQL.Clear;
      if IsEmpty then
      begin
        SQL.Add('INSERT INTO Partidas');
        SQL.Add('(Par_Codigo, Par_Data, Par_Horario, Cam_Codigo, Par_Status,');
        SQL.Add('Par_TimeA, Par_TimeB)');
        SQL.Add('VALUES');
        SQL.Add('(:Par_Codigo, :Par_Data, :Par_Horario, :Cam_Codigo, :Par_Status,');
        SQL.Add(':Par_TimeA, :Par_TimeB)');
      end
      else
      begin
        SQL.Add('UPDATE Partidas SET');
        SQL.Add('  Par_Data    = :Par_Data,');
        SQL.Add('  Par_Horario = :Par_Horario,');
        SQL.Add('  Cam_Codigo  = :Cam_Codigo,');
        SQL.Add('  Par_Status  = :Par_Status,');
        SQL.Add('  Par_TimeA   = :Par_TimeA,');
        SQL.Add('  Par_TimeB   = :Par_TimeB');
        SQL.Add('WHERE');
        SQL.Add('  Par_Codigo  = :Par_Codigo');
      end;
      ParamByName('Par_Codigo').AsInteger  := Partida.Codigo;
      ParamByName('Par_Data').AsDateTime   := Partida.Data;
      ParamByName('Par_Horario').AsDateTime:= Partida.Horario;
      ParamByName('Cam_Codigo').AsInteger  := Partida.Cam_Codigo;
      ParamByName('Par_Status').AsString   := iif(Partida.Status = tsAtivo, 'A', 'I');
      ParamByName('Par_TimeA').AsInteger   := Partida.TimeA;
      ParamByName('Par_TimeB').AsInteger   := Partida.TimeB;
      ExecSQL;

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetPartida. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.SetPartidaAtletas(Atletas_Partida: TListPartidasAtletas): Boolean;
var
  I: Integer;
begin
  Result:= False;
  try
    for I := Low(Atletas_Partida) to High(Atletas_Partida) do
    begin
      //pesquisa no banco de dados
      with DModulo.fdqAuxiliar do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM Times_Atletas');
        SQL.Add('WHERE Par_Codigo = :Par_Codigo AND');
        SQL.Add('      Tim_Codigo = :Tim_Codigo and Atl_Codigo = :Atl_Codigo');
        ParamByName('Par_Codigo').AsInteger  := Atletas_Partida[I].Par_Codigo;
        ParamByName('Tim_Codigo').AsInteger  := Atletas_Partida[I].Tim_Codigo;
        ParamByName('Atl_Codigo').AsInteger  := Atletas_Partida[I].Atl_Codigo;
        Open();

        DModulo.DBStartTrans;
        Close;
        SQL.Clear;
        if IsEmpty then
        begin
          SQL.Add('INSERT INTO Partidas_Atletas');
          SQL.Add('(Par_Codigo, Tim_Codigo, Atl_Codigo, Pta_Gols,');
          SQL.Add('Pta_Assistencias, Pta_CVermelhos, Pta_CAmarelos, Pta_Compareceu)');
          SQL.Add('VALUES');
          SQL.Add('(:Par_Codigo, :Tim_Codigo, :Atl_Codigo, :Pta_Gols,');
          SQL.Add(':Pta_Assistencias, :Pta_CVermelhos, :Pta_CAmarelos, :Pta_Compareceu)');
        end
        else
        begin
          SQL.add('UPDATE Partidas_Atletas SET');
          SQL.Add('   Pta_Gols         = :Pta_Gols,');
          SQL.Add('   Pta_Assistencias = :Pta_Assistencias,');
          SQL.Add('   Pta_CVermelhos   = :Pta_CVermelhos,');
          SQL.Add('   Pta_CAmarelos    = :Pta_CAmarelos,');
          SQL.Add('   Pta_Compareceu   = :Pta_Compareceu');
          SQL.Add('WHERE');
          SQL.Add('   Tim_Codigo       = :Tim_Codigo AND');
          SQL.Add('   Atl_Codigo       = :Atl_Codigo AND');
          SQL.Add('   Par_Codigo       = :Par_Codigo');
        end;
        ParamByName('Tim_Codigo').AsInteger      := Atletas_Partida[I].Tim_Codigo;
        ParamByName('Atl_Codigo').AsInteger      := Atletas_Partida[I].Atl_Codigo;
        ParamByName('Par_Codigo').AsInteger      := Atletas_Partida[I].Par_Codigo;
        ParamByName('Pta_Gols').AsInteger        := Atletas_Partida[I].Gols;
        ParamByName('Pta_Assistencias').AsInteger:= Atletas_Partida[I].Assistencias;
        ParamByName('Pta_CVermelhos').AsInteger  := Atletas_Partida[I].CartVermelho;
        ParamByName('Pta_CAmarelos').AsInteger   := Atletas_Partida[I].CartAmarelo;
        ParamByName('Pta_Compareceu').AsString   := iif( Atletas_Partida[I].Compareceu, 'S', 'N');
        ExecSQL;
        DModulo.DBCommit;
      end;
    end;
    Finalize(Atletas_Partida);
    Result := True;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetPartidaAtletas. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.SetTime(Equipe: TTimes): Boolean;
begin
  Result:= False;
  try
    if Equipe.Codigo = 0 then
      Equipe.Codigo := DModulo.RetornaProxCodigo('Times', 'Tim_Codigo');

    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Tim_Codigo FROM Times');
      SQL.Add('WHERE Tim_Codigo = :Codigo');
      ParamByName('Codigo').AsInteger  := Equipe.Codigo;
      Open();

      DModulo.DBStartTrans;

      Close;
      SQL.Clear;
      if IsEmpty then
      begin
        SQL.Add('INSERT INTO Times');
        SQL.Add('(Tim_Codigo, Tim_Nome, Tim_DataFundacao, Atl_Codigo)');
        SQL.Add('VALUES');
        SQL.Add('(:Tim_Codigo, :Tim_Nome, :Tim_DataFundacao, :Atl_Codigo)');
      end
      else
      begin
        SQL.Add('UPDATE Times SET');
        SQL.Add('  Tim_Nome         = :Tim_Nome,');
        SQL.Add('  Tim_DataFundacao = :Tim_DataFundacao,');
        SQL.Add('  Atl_Codigo       = :Atl_Codigo,');
        SQL.Add('WHERE');
        SQL.Add('  Tim_Codigo = :Tim_Codigo');
      end;
      ParamByName('Tim_Codigo').AsInteger       := Equipe.Codigo;
      ParamByName('Tim_Nome').AsString          := Equipe.Nome;
      ParamByName('Tim_DataFundacao').AsDateTime:= Equipe.DataFundacao;
      ParamByName('Atl_Codigo').AsInteger       := Equipe.Atl_Codigo;
      ExecSQL;

      DModulo.DBCommit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetTime. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.SetTimeAtletas(Atletas_Times: TListTimesAtletas): Boolean;
var
  I: Integer;
begin
  Result:= False;
  try
    for I := Low(Atletas_Times) to High(Atletas_Times) do
    begin
      //pesquisa no banco de dados
      with DModulo.fdqAuxiliar do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM Times_Atletas');
        SQL.Add('WHERE Tim_Codigo = :Tim_Codigo and Atl_Codigo = :Atl_Codigo');
        ParamByName('Tim_Codigo').AsInteger  := Atletas_Times[I].Tim_Codigo;
        ParamByName('Atl_Codigo').AsInteger  := Atletas_Times[I].Atl_Codigo;
        Open();

        if IsEmpty then
        begin
          DModulo.DBStartTrans;

          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO Times_Atletas');
          SQL.Add('(Tim_Codigo, Atl_Codigo)');
          SQL.Add('VALUES');
          SQL.Add('(:Tim_Codigo, :Atl_Codigo)');
          ParamByName('Tim_Codigo').AsInteger := Atletas_Times[I].Tim_Codigo;
          ParamByName('Atl_Codigo').AsInteger := Atletas_Times[I].Atl_Codigo;
          ExecSQL;

          DModulo.DBCommit;
        end;
      end;
    end;

    Finalize(Atletas_Times);
    Result := True;
  except
    on E: Exception do
    begin
      DModulo.DBRollback;
      GravaErro('Falha na chamada do m�todo SetTimeAtletas. ' + e.Message);;
    end;
  end;
end;

function TWSFutSystem.ValidaLogin(Email, Senha: string;
  TipoLogin: TTipoLogin): Integer;
begin
  Result:= 0;
  try
    //pesquisa no banco de dados
    with DModulo.fdqAuxiliar do
    begin
      Close;
      SQL.Clear;
      if TipoLogin = tlAtleta then
      begin
        SQL.Add('SELECT Atl_Codigo as CODIGO FROM Atletas');
        SQL.Add('WHERE');
        SQL.Add('  Atl_Email = :Email AND');
        SQL.Add('  Atl_Senha = :Senha');
      end
      else
      begin
        SQL.Add('SELECT Cam_Codigo as CODIGO FROM Campos');
        SQL.Add('WHERE');
        SQL.Add('  Cam_Email = :Email AND');
        SQL.Add('  Cam_Senha = :Senha');
      end;
      ParamByName('Email').AsString := Email;
      ParamByName('Senha').AsString := Senha;
      Open();

      if not IsEmpty then
        Result := FieldByName('CODIGO').AsInteger;
    end;
  except
    on E: Exception do
      GravaErro('Falha na chamada do m�todo ValidaLogin. ' + e.Message);
  end;
end;

initialization
{ Invokable classes must be registered }
  InvRegistry.RegisterInvokableClass(TWSFutSystem);

end.

