// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReproducaoDTStruct extends BaseStruct {
  ReproducaoDTStruct({
    int? id,
    String? createdAt,
    String? idPropriedade,
    String? tipoReproducao,
    String? idRebanhoMatriz,
    double? scoreCorporal,
    String? idRebanhoReprodutor,
    String? dataInseminacao,
    String? dataPartidaSemen,
    int? partidaSemen,
    String? previsaoParto,
    String? idLote,
    String? dataInicial,
    String? dataFinal,
    String? statusReproducao,
    String? inseminador,
    String? anotacoes,
    String? idReproducao,
    String? deletado,
    String? updatedAt,
    String? categoria,
    String? numMatriz,
    String? nomeMatriz,
    String? nascimentoMatriz,
    String? numReprodutor,
    String? nomeReprodutor,
    String? nascimentoReprodutor,
    String? loteNome,
    String? dataStatus,
    String? racaMatriz,
    String? racaReprodutor,
    String? ressinc,
    String? parida,
    String? dataParto,
    String? gnrh,
    String? cio,
  })  : _id = id,
        _createdAt = createdAt,
        _idPropriedade = idPropriedade,
        _tipoReproducao = tipoReproducao,
        _idRebanhoMatriz = idRebanhoMatriz,
        _scoreCorporal = scoreCorporal,
        _idRebanhoReprodutor = idRebanhoReprodutor,
        _dataInseminacao = dataInseminacao,
        _dataPartidaSemen = dataPartidaSemen,
        _partidaSemen = partidaSemen,
        _previsaoParto = previsaoParto,
        _idLote = idLote,
        _dataInicial = dataInicial,
        _dataFinal = dataFinal,
        _statusReproducao = statusReproducao,
        _inseminador = inseminador,
        _anotacoes = anotacoes,
        _idReproducao = idReproducao,
        _deletado = deletado,
        _updatedAt = updatedAt,
        _categoria = categoria,
        _numMatriz = numMatriz,
        _nomeMatriz = nomeMatriz,
        _nascimentoMatriz = nascimentoMatriz,
        _numReprodutor = numReprodutor,
        _nomeReprodutor = nomeReprodutor,
        _nascimentoReprodutor = nascimentoReprodutor,
        _loteNome = loteNome,
        _dataStatus = dataStatus,
        _racaMatriz = racaMatriz,
        _racaReprodutor = racaReprodutor,
        _ressinc = ressinc,
        _parida = parida,
        _dataParto = dataParto,
        _gnrh = gnrh,
        _cio = cio;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "id_propriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "tipo_reproducao" field.
  String? _tipoReproducao;
  String get tipoReproducao => _tipoReproducao ?? '';
  set tipoReproducao(String? val) => _tipoReproducao = val;

  bool hasTipoReproducao() => _tipoReproducao != null;

  // "id_rebanho_matriz" field.
  String? _idRebanhoMatriz;
  String get idRebanhoMatriz => _idRebanhoMatriz ?? '';
  set idRebanhoMatriz(String? val) => _idRebanhoMatriz = val;

  bool hasIdRebanhoMatriz() => _idRebanhoMatriz != null;

  // "score_corporal" field.
  double? _scoreCorporal;
  double get scoreCorporal => _scoreCorporal ?? 0.0;
  set scoreCorporal(double? val) => _scoreCorporal = val;

  void incrementScoreCorporal(double amount) =>
      scoreCorporal = scoreCorporal + amount;

  bool hasScoreCorporal() => _scoreCorporal != null;

  // "id_rebanho_reprodutor" field.
  String? _idRebanhoReprodutor;
  String get idRebanhoReprodutor => _idRebanhoReprodutor ?? '';
  set idRebanhoReprodutor(String? val) => _idRebanhoReprodutor = val;

  bool hasIdRebanhoReprodutor() => _idRebanhoReprodutor != null;

  // "data_inseminacao" field.
  String? _dataInseminacao;
  String get dataInseminacao => _dataInseminacao ?? '';
  set dataInseminacao(String? val) => _dataInseminacao = val;

  bool hasDataInseminacao() => _dataInseminacao != null;

  // "data_partida_semen" field.
  String? _dataPartidaSemen;
  String get dataPartidaSemen => _dataPartidaSemen ?? '';
  set dataPartidaSemen(String? val) => _dataPartidaSemen = val;

  bool hasDataPartidaSemen() => _dataPartidaSemen != null;

  // "partida_semen" field.
  int? _partidaSemen;
  int get partidaSemen => _partidaSemen ?? 0;
  set partidaSemen(int? val) => _partidaSemen = val;

  void incrementPartidaSemen(int amount) =>
      partidaSemen = partidaSemen + amount;

  bool hasPartidaSemen() => _partidaSemen != null;

  // "previsao_parto" field.
  String? _previsaoParto;
  String get previsaoParto => _previsaoParto ?? '';
  set previsaoParto(String? val) => _previsaoParto = val;

  bool hasPrevisaoParto() => _previsaoParto != null;

  // "id_lote" field.
  String? _idLote;
  String get idLote => _idLote ?? '';
  set idLote(String? val) => _idLote = val;

  bool hasIdLote() => _idLote != null;

  // "data_inicial" field.
  String? _dataInicial;
  String get dataInicial => _dataInicial ?? '';
  set dataInicial(String? val) => _dataInicial = val;

  bool hasDataInicial() => _dataInicial != null;

  // "data_final" field.
  String? _dataFinal;
  String get dataFinal => _dataFinal ?? '';
  set dataFinal(String? val) => _dataFinal = val;

  bool hasDataFinal() => _dataFinal != null;

  // "status_reproducao" field.
  String? _statusReproducao;
  String get statusReproducao => _statusReproducao ?? '';
  set statusReproducao(String? val) => _statusReproducao = val;

  bool hasStatusReproducao() => _statusReproducao != null;

  // "inseminador" field.
  String? _inseminador;
  String get inseminador => _inseminador ?? '';
  set inseminador(String? val) => _inseminador = val;

  bool hasInseminador() => _inseminador != null;

  // "anotacoes" field.
  String? _anotacoes;
  String get anotacoes => _anotacoes ?? '';
  set anotacoes(String? val) => _anotacoes = val;

  bool hasAnotacoes() => _anotacoes != null;

  // "id_reproducao" field.
  String? _idReproducao;
  String get idReproducao => _idReproducao ?? '';
  set idReproducao(String? val) => _idReproducao = val;

  bool hasIdReproducao() => _idReproducao != null;

  // "deletado" field.
  String? _deletado;
  String get deletado => _deletado ?? '';
  set deletado(String? val) => _deletado = val;

  bool hasDeletado() => _deletado != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "numMatriz" field.
  String? _numMatriz;
  String get numMatriz => _numMatriz ?? '';
  set numMatriz(String? val) => _numMatriz = val;

  bool hasNumMatriz() => _numMatriz != null;

  // "nomeMatriz" field.
  String? _nomeMatriz;
  String get nomeMatriz => _nomeMatriz ?? '';
  set nomeMatriz(String? val) => _nomeMatriz = val;

  bool hasNomeMatriz() => _nomeMatriz != null;

  // "nascimentoMatriz" field.
  String? _nascimentoMatriz;
  String get nascimentoMatriz => _nascimentoMatriz ?? '';
  set nascimentoMatriz(String? val) => _nascimentoMatriz = val;

  bool hasNascimentoMatriz() => _nascimentoMatriz != null;

  // "numReprodutor" field.
  String? _numReprodutor;
  String get numReprodutor => _numReprodutor ?? '';
  set numReprodutor(String? val) => _numReprodutor = val;

  bool hasNumReprodutor() => _numReprodutor != null;

  // "nomeReprodutor" field.
  String? _nomeReprodutor;
  String get nomeReprodutor => _nomeReprodutor ?? '';
  set nomeReprodutor(String? val) => _nomeReprodutor = val;

  bool hasNomeReprodutor() => _nomeReprodutor != null;

  // "nascimentoReprodutor" field.
  String? _nascimentoReprodutor;
  String get nascimentoReprodutor => _nascimentoReprodutor ?? '';
  set nascimentoReprodutor(String? val) => _nascimentoReprodutor = val;

  bool hasNascimentoReprodutor() => _nascimentoReprodutor != null;

  // "loteNome" field.
  String? _loteNome;
  String get loteNome => _loteNome ?? '';
  set loteNome(String? val) => _loteNome = val;

  bool hasLoteNome() => _loteNome != null;

  // "data_status" field.
  String? _dataStatus;
  String get dataStatus => _dataStatus ?? '';
  set dataStatus(String? val) => _dataStatus = val;

  bool hasDataStatus() => _dataStatus != null;

  // "racaMatriz" field.
  String? _racaMatriz;
  String get racaMatriz => _racaMatriz ?? '';
  set racaMatriz(String? val) => _racaMatriz = val;

  bool hasRacaMatriz() => _racaMatriz != null;

  // "racaReprodutor" field.
  String? _racaReprodutor;
  String get racaReprodutor => _racaReprodutor ?? '';
  set racaReprodutor(String? val) => _racaReprodutor = val;

  bool hasRacaReprodutor() => _racaReprodutor != null;

  // "ressinc" field.
  String? _ressinc;
  String get ressinc => _ressinc ?? '';
  set ressinc(String? val) => _ressinc = val;

  bool hasRessinc() => _ressinc != null;

  // "parida" field.
  String? _parida;
  String get parida => _parida ?? '';
  set parida(String? val) => _parida = val;

  bool hasParida() => _parida != null;

  // "data_parto" field.
  String? _dataParto;
  String get dataParto => _dataParto ?? '';
  set dataParto(String? val) => _dataParto = val;

  bool hasDataParto() => _dataParto != null;

  // "gnrh" field.
  String? _gnrh;
  String get gnrh => _gnrh ?? '';
  set gnrh(String? val) => _gnrh = val;

  bool hasGnrh() => _gnrh != null;

  // "cio" field.
  String? _cio;
  String get cio => _cio ?? '';
  set cio(String? val) => _cio = val;

  bool hasCio() => _cio != null;

  static ReproducaoDTStruct fromMap(Map<String, dynamic> data) =>
      ReproducaoDTStruct(
        id: castToType<int>(data['id']),
        createdAt: data['created_at'] as String?,
        idPropriedade: data['id_propriedade'] as String?,
        tipoReproducao: data['tipo_reproducao'] as String?,
        idRebanhoMatriz: data['id_rebanho_matriz'] as String?,
        scoreCorporal: castToType<double>(data['score_corporal']),
        idRebanhoReprodutor: data['id_rebanho_reprodutor'] as String?,
        dataInseminacao: data['data_inseminacao'] as String?,
        dataPartidaSemen: data['data_partida_semen'] as String?,
        partidaSemen: castToType<int>(data['partida_semen']),
        previsaoParto: data['previsao_parto'] as String?,
        idLote: data['id_lote'] as String?,
        dataInicial: data['data_inicial'] as String?,
        dataFinal: data['data_final'] as String?,
        statusReproducao: data['status_reproducao'] as String?,
        inseminador: data['inseminador'] as String?,
        anotacoes: data['anotacoes'] as String?,
        idReproducao: data['id_reproducao'] as String?,
        deletado: data['deletado'] as String?,
        updatedAt: data['updated_at'] as String?,
        categoria: data['categoria'] as String?,
        numMatriz: data['numMatriz'] as String?,
        nomeMatriz: data['nomeMatriz'] as String?,
        nascimentoMatriz: data['nascimentoMatriz'] as String?,
        numReprodutor: data['numReprodutor'] as String?,
        nomeReprodutor: data['nomeReprodutor'] as String?,
        nascimentoReprodutor: data['nascimentoReprodutor'] as String?,
        loteNome: data['loteNome'] as String?,
        dataStatus: data['data_status'] as String?,
        racaMatriz: data['racaMatriz'] as String?,
        racaReprodutor: data['racaReprodutor'] as String?,
        ressinc: data['ressinc'] as String?,
        parida: data['parida'] as String?,
        dataParto: data['data_parto'] as String?,
        gnrh: data['gnrh'] as String?,
        cio: data['cio'] as String?,
      );

  static ReproducaoDTStruct? maybeFromMap(dynamic data) => data is Map
      ? ReproducaoDTStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'id_propriedade': _idPropriedade,
        'tipo_reproducao': _tipoReproducao,
        'id_rebanho_matriz': _idRebanhoMatriz,
        'score_corporal': _scoreCorporal,
        'id_rebanho_reprodutor': _idRebanhoReprodutor,
        'data_inseminacao': _dataInseminacao,
        'data_partida_semen': _dataPartidaSemen,
        'partida_semen': _partidaSemen,
        'previsao_parto': _previsaoParto,
        'id_lote': _idLote,
        'data_inicial': _dataInicial,
        'data_final': _dataFinal,
        'status_reproducao': _statusReproducao,
        'inseminador': _inseminador,
        'anotacoes': _anotacoes,
        'id_reproducao': _idReproducao,
        'deletado': _deletado,
        'updated_at': _updatedAt,
        'categoria': _categoria,
        'numMatriz': _numMatriz,
        'nomeMatriz': _nomeMatriz,
        'nascimentoMatriz': _nascimentoMatriz,
        'numReprodutor': _numReprodutor,
        'nomeReprodutor': _nomeReprodutor,
        'nascimentoReprodutor': _nascimentoReprodutor,
        'loteNome': _loteNome,
        'data_status': _dataStatus,
        'racaMatriz': _racaMatriz,
        'racaReprodutor': _racaReprodutor,
        'ressinc': _ressinc,
        'parida': _parida,
        'data_parto': _dataParto,
        'gnrh': _gnrh,
        'cio': _cio,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'id_propriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'tipo_reproducao': serializeParam(
          _tipoReproducao,
          ParamType.String,
        ),
        'id_rebanho_matriz': serializeParam(
          _idRebanhoMatriz,
          ParamType.String,
        ),
        'score_corporal': serializeParam(
          _scoreCorporal,
          ParamType.double,
        ),
        'id_rebanho_reprodutor': serializeParam(
          _idRebanhoReprodutor,
          ParamType.String,
        ),
        'data_inseminacao': serializeParam(
          _dataInseminacao,
          ParamType.String,
        ),
        'data_partida_semen': serializeParam(
          _dataPartidaSemen,
          ParamType.String,
        ),
        'partida_semen': serializeParam(
          _partidaSemen,
          ParamType.int,
        ),
        'previsao_parto': serializeParam(
          _previsaoParto,
          ParamType.String,
        ),
        'id_lote': serializeParam(
          _idLote,
          ParamType.String,
        ),
        'data_inicial': serializeParam(
          _dataInicial,
          ParamType.String,
        ),
        'data_final': serializeParam(
          _dataFinal,
          ParamType.String,
        ),
        'status_reproducao': serializeParam(
          _statusReproducao,
          ParamType.String,
        ),
        'inseminador': serializeParam(
          _inseminador,
          ParamType.String,
        ),
        'anotacoes': serializeParam(
          _anotacoes,
          ParamType.String,
        ),
        'id_reproducao': serializeParam(
          _idReproducao,
          ParamType.String,
        ),
        'deletado': serializeParam(
          _deletado,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'numMatriz': serializeParam(
          _numMatriz,
          ParamType.String,
        ),
        'nomeMatriz': serializeParam(
          _nomeMatriz,
          ParamType.String,
        ),
        'nascimentoMatriz': serializeParam(
          _nascimentoMatriz,
          ParamType.String,
        ),
        'numReprodutor': serializeParam(
          _numReprodutor,
          ParamType.String,
        ),
        'nomeReprodutor': serializeParam(
          _nomeReprodutor,
          ParamType.String,
        ),
        'nascimentoReprodutor': serializeParam(
          _nascimentoReprodutor,
          ParamType.String,
        ),
        'loteNome': serializeParam(
          _loteNome,
          ParamType.String,
        ),
        'data_status': serializeParam(
          _dataStatus,
          ParamType.String,
        ),
        'racaMatriz': serializeParam(
          _racaMatriz,
          ParamType.String,
        ),
        'racaReprodutor': serializeParam(
          _racaReprodutor,
          ParamType.String,
        ),
        'ressinc': serializeParam(
          _ressinc,
          ParamType.String,
        ),
        'parida': serializeParam(
          _parida,
          ParamType.String,
        ),
        'data_parto': serializeParam(
          _dataParto,
          ParamType.String,
        ),
        'gnrh': serializeParam(
          _gnrh,
          ParamType.String,
        ),
        'cio': serializeParam(
          _cio,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReproducaoDTStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReproducaoDTStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        idPropriedade: deserializeParam(
          data['id_propriedade'],
          ParamType.String,
          false,
        ),
        tipoReproducao: deserializeParam(
          data['tipo_reproducao'],
          ParamType.String,
          false,
        ),
        idRebanhoMatriz: deserializeParam(
          data['id_rebanho_matriz'],
          ParamType.String,
          false,
        ),
        scoreCorporal: deserializeParam(
          data['score_corporal'],
          ParamType.double,
          false,
        ),
        idRebanhoReprodutor: deserializeParam(
          data['id_rebanho_reprodutor'],
          ParamType.String,
          false,
        ),
        dataInseminacao: deserializeParam(
          data['data_inseminacao'],
          ParamType.String,
          false,
        ),
        dataPartidaSemen: deserializeParam(
          data['data_partida_semen'],
          ParamType.String,
          false,
        ),
        partidaSemen: deserializeParam(
          data['partida_semen'],
          ParamType.int,
          false,
        ),
        previsaoParto: deserializeParam(
          data['previsao_parto'],
          ParamType.String,
          false,
        ),
        idLote: deserializeParam(
          data['id_lote'],
          ParamType.String,
          false,
        ),
        dataInicial: deserializeParam(
          data['data_inicial'],
          ParamType.String,
          false,
        ),
        dataFinal: deserializeParam(
          data['data_final'],
          ParamType.String,
          false,
        ),
        statusReproducao: deserializeParam(
          data['status_reproducao'],
          ParamType.String,
          false,
        ),
        inseminador: deserializeParam(
          data['inseminador'],
          ParamType.String,
          false,
        ),
        anotacoes: deserializeParam(
          data['anotacoes'],
          ParamType.String,
          false,
        ),
        idReproducao: deserializeParam(
          data['id_reproducao'],
          ParamType.String,
          false,
        ),
        deletado: deserializeParam(
          data['deletado'],
          ParamType.String,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        numMatriz: deserializeParam(
          data['numMatriz'],
          ParamType.String,
          false,
        ),
        nomeMatriz: deserializeParam(
          data['nomeMatriz'],
          ParamType.String,
          false,
        ),
        nascimentoMatriz: deserializeParam(
          data['nascimentoMatriz'],
          ParamType.String,
          false,
        ),
        numReprodutor: deserializeParam(
          data['numReprodutor'],
          ParamType.String,
          false,
        ),
        nomeReprodutor: deserializeParam(
          data['nomeReprodutor'],
          ParamType.String,
          false,
        ),
        nascimentoReprodutor: deserializeParam(
          data['nascimentoReprodutor'],
          ParamType.String,
          false,
        ),
        loteNome: deserializeParam(
          data['loteNome'],
          ParamType.String,
          false,
        ),
        dataStatus: deserializeParam(
          data['data_status'],
          ParamType.String,
          false,
        ),
        racaMatriz: deserializeParam(
          data['racaMatriz'],
          ParamType.String,
          false,
        ),
        racaReprodutor: deserializeParam(
          data['racaReprodutor'],
          ParamType.String,
          false,
        ),
        ressinc: deserializeParam(
          data['ressinc'],
          ParamType.String,
          false,
        ),
        parida: deserializeParam(
          data['parida'],
          ParamType.String,
          false,
        ),
        dataParto: deserializeParam(
          data['data_parto'],
          ParamType.String,
          false,
        ),
        gnrh: deserializeParam(
          data['gnrh'],
          ParamType.String,
          false,
        ),
        cio: deserializeParam(
          data['cio'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReproducaoDTStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReproducaoDTStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        idPropriedade == other.idPropriedade &&
        tipoReproducao == other.tipoReproducao &&
        idRebanhoMatriz == other.idRebanhoMatriz &&
        scoreCorporal == other.scoreCorporal &&
        idRebanhoReprodutor == other.idRebanhoReprodutor &&
        dataInseminacao == other.dataInseminacao &&
        dataPartidaSemen == other.dataPartidaSemen &&
        partidaSemen == other.partidaSemen &&
        previsaoParto == other.previsaoParto &&
        idLote == other.idLote &&
        dataInicial == other.dataInicial &&
        dataFinal == other.dataFinal &&
        statusReproducao == other.statusReproducao &&
        inseminador == other.inseminador &&
        anotacoes == other.anotacoes &&
        idReproducao == other.idReproducao &&
        deletado == other.deletado &&
        updatedAt == other.updatedAt &&
        categoria == other.categoria &&
        numMatriz == other.numMatriz &&
        nomeMatriz == other.nomeMatriz &&
        nascimentoMatriz == other.nascimentoMatriz &&
        numReprodutor == other.numReprodutor &&
        nomeReprodutor == other.nomeReprodutor &&
        nascimentoReprodutor == other.nascimentoReprodutor &&
        loteNome == other.loteNome &&
        dataStatus == other.dataStatus &&
        racaMatriz == other.racaMatriz &&
        racaReprodutor == other.racaReprodutor &&
        ressinc == other.ressinc &&
        parida == other.parida &&
        dataParto == other.dataParto &&
        gnrh == other.gnrh &&
        cio == other.cio;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        idPropriedade,
        tipoReproducao,
        idRebanhoMatriz,
        scoreCorporal,
        idRebanhoReprodutor,
        dataInseminacao,
        dataPartidaSemen,
        partidaSemen,
        previsaoParto,
        idLote,
        dataInicial,
        dataFinal,
        statusReproducao,
        inseminador,
        anotacoes,
        idReproducao,
        deletado,
        updatedAt,
        categoria,
        numMatriz,
        nomeMatriz,
        nascimentoMatriz,
        numReprodutor,
        nomeReprodutor,
        nascimentoReprodutor,
        loteNome,
        dataStatus,
        racaMatriz,
        racaReprodutor,
        ressinc,
        parida,
        dataParto,
        gnrh,
        cio
      ]);
}

ReproducaoDTStruct createReproducaoDTStruct({
  int? id,
  String? createdAt,
  String? idPropriedade,
  String? tipoReproducao,
  String? idRebanhoMatriz,
  double? scoreCorporal,
  String? idRebanhoReprodutor,
  String? dataInseminacao,
  String? dataPartidaSemen,
  int? partidaSemen,
  String? previsaoParto,
  String? idLote,
  String? dataInicial,
  String? dataFinal,
  String? statusReproducao,
  String? inseminador,
  String? anotacoes,
  String? idReproducao,
  String? deletado,
  String? updatedAt,
  String? categoria,
  String? numMatriz,
  String? nomeMatriz,
  String? nascimentoMatriz,
  String? numReprodutor,
  String? nomeReprodutor,
  String? nascimentoReprodutor,
  String? loteNome,
  String? dataStatus,
  String? racaMatriz,
  String? racaReprodutor,
  String? ressinc,
  String? parida,
  String? dataParto,
  String? gnrh,
  String? cio,
}) =>
    ReproducaoDTStruct(
      id: id,
      createdAt: createdAt,
      idPropriedade: idPropriedade,
      tipoReproducao: tipoReproducao,
      idRebanhoMatriz: idRebanhoMatriz,
      scoreCorporal: scoreCorporal,
      idRebanhoReprodutor: idRebanhoReprodutor,
      dataInseminacao: dataInseminacao,
      dataPartidaSemen: dataPartidaSemen,
      partidaSemen: partidaSemen,
      previsaoParto: previsaoParto,
      idLote: idLote,
      dataInicial: dataInicial,
      dataFinal: dataFinal,
      statusReproducao: statusReproducao,
      inseminador: inseminador,
      anotacoes: anotacoes,
      idReproducao: idReproducao,
      deletado: deletado,
      updatedAt: updatedAt,
      categoria: categoria,
      numMatriz: numMatriz,
      nomeMatriz: nomeMatriz,
      nascimentoMatriz: nascimentoMatriz,
      numReprodutor: numReprodutor,
      nomeReprodutor: nomeReprodutor,
      nascimentoReprodutor: nascimentoReprodutor,
      loteNome: loteNome,
      dataStatus: dataStatus,
      racaMatriz: racaMatriz,
      racaReprodutor: racaReprodutor,
      ressinc: ressinc,
      parida: parida,
      dataParto: dataParto,
      gnrh: gnrh,
      cio: cio,
    );
