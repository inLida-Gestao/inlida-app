// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SanidadeStruct extends BaseStruct {
  SanidadeStruct({
    String? idPropriedade,
    String? idRebanho,
    String? dataSanidade,
    String? idLote,
    double? porcentagemLote,
    String? idSanidade,
    String? updatedAt,
    String? deletado,
    String? vacinacao,
    String? vacOutros,
    String? vacObs,
    String? antiparasitario,
    String? antiOutros,
    String? antiObs,
    String? tratamento,
    String? tratOutros,
    String? tratObs,
    String? protocoloReprodutivo,
    String? reproOutros,
    String? reproObs,
    String? createdAt,
    String? protocoloD0,
    String? protocoloRetirada,
    String? protocoloIatf,
    int? id,
  })  : _idPropriedade = idPropriedade,
        _idRebanho = idRebanho,
        _dataSanidade = dataSanidade,
        _idLote = idLote,
        _porcentagemLote = porcentagemLote,
        _idSanidade = idSanidade,
        _updatedAt = updatedAt,
        _deletado = deletado,
        _vacinacao = vacinacao,
        _vacOutros = vacOutros,
        _vacObs = vacObs,
        _antiparasitario = antiparasitario,
        _antiOutros = antiOutros,
        _antiObs = antiObs,
        _tratamento = tratamento,
        _tratOutros = tratOutros,
        _tratObs = tratObs,
        _protocoloReprodutivo = protocoloReprodutivo,
        _reproOutros = reproOutros,
        _reproObs = reproObs,
        _createdAt = createdAt,
        _protocoloD0 = protocoloD0,
        _protocoloRetirada = protocoloRetirada,
        _protocoloIatf = protocoloIatf,
        _id = id;

  // "id_propriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "id_rebanho" field.
  String? _idRebanho;
  String get idRebanho => _idRebanho ?? '';
  set idRebanho(String? val) => _idRebanho = val;

  bool hasIdRebanho() => _idRebanho != null;

  // "data_sanidade" field.
  String? _dataSanidade;
  String get dataSanidade => _dataSanidade ?? '';
  set dataSanidade(String? val) => _dataSanidade = val;

  bool hasDataSanidade() => _dataSanidade != null;

  // "id_lote" field.
  String? _idLote;
  String get idLote => _idLote ?? '';
  set idLote(String? val) => _idLote = val;

  bool hasIdLote() => _idLote != null;

  // "porcentagem_lote" field.
  double? _porcentagemLote;
  double get porcentagemLote => _porcentagemLote ?? 0.0;
  set porcentagemLote(double? val) => _porcentagemLote = val;

  void incrementPorcentagemLote(double amount) =>
      porcentagemLote = porcentagemLote + amount;

  bool hasPorcentagemLote() => _porcentagemLote != null;

  // "id_sanidade" field.
  String? _idSanidade;
  String get idSanidade => _idSanidade ?? '';
  set idSanidade(String? val) => _idSanidade = val;

  bool hasIdSanidade() => _idSanidade != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "deletado" field.
  String? _deletado;
  String get deletado => _deletado ?? '';
  set deletado(String? val) => _deletado = val;

  bool hasDeletado() => _deletado != null;

  // "vacinacao" field.
  String? _vacinacao;
  String get vacinacao => _vacinacao ?? '';
  set vacinacao(String? val) => _vacinacao = val;

  bool hasVacinacao() => _vacinacao != null;

  // "vac_outros" field.
  String? _vacOutros;
  String get vacOutros => _vacOutros ?? '';
  set vacOutros(String? val) => _vacOutros = val;

  bool hasVacOutros() => _vacOutros != null;

  // "vac_obs" field.
  String? _vacObs;
  String get vacObs => _vacObs ?? '';
  set vacObs(String? val) => _vacObs = val;

  bool hasVacObs() => _vacObs != null;

  // "antiparasitario" field.
  String? _antiparasitario;
  String get antiparasitario => _antiparasitario ?? '';
  set antiparasitario(String? val) => _antiparasitario = val;

  bool hasAntiparasitario() => _antiparasitario != null;

  // "anti_outros" field.
  String? _antiOutros;
  String get antiOutros => _antiOutros ?? '';
  set antiOutros(String? val) => _antiOutros = val;

  bool hasAntiOutros() => _antiOutros != null;

  // "anti_obs" field.
  String? _antiObs;
  String get antiObs => _antiObs ?? '';
  set antiObs(String? val) => _antiObs = val;

  bool hasAntiObs() => _antiObs != null;

  // "tratamento" field.
  String? _tratamento;
  String get tratamento => _tratamento ?? '';
  set tratamento(String? val) => _tratamento = val;

  bool hasTratamento() => _tratamento != null;

  // "trat_outros" field.
  String? _tratOutros;
  String get tratOutros => _tratOutros ?? '';
  set tratOutros(String? val) => _tratOutros = val;

  bool hasTratOutros() => _tratOutros != null;

  // "trat_obs" field.
  String? _tratObs;
  String get tratObs => _tratObs ?? '';
  set tratObs(String? val) => _tratObs = val;

  bool hasTratObs() => _tratObs != null;

  // "protocolo_reprodutivo" field.
  String? _protocoloReprodutivo;
  String get protocoloReprodutivo => _protocoloReprodutivo ?? '';
  set protocoloReprodutivo(String? val) => _protocoloReprodutivo = val;

  bool hasProtocoloReprodutivo() => _protocoloReprodutivo != null;

  // "repro_outros" field.
  String? _reproOutros;
  String get reproOutros => _reproOutros ?? '';
  set reproOutros(String? val) => _reproOutros = val;

  bool hasReproOutros() => _reproOutros != null;

  // "repro_obs" field.
  String? _reproObs;
  String get reproObs => _reproObs ?? '';
  set reproObs(String? val) => _reproObs = val;

  bool hasReproObs() => _reproObs != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "protocolo_d0" field.
  String? _protocoloD0;
  String get protocoloD0 => _protocoloD0 ?? '';
  set protocoloD0(String? val) => _protocoloD0 = val;

  bool hasProtocoloD0() => _protocoloD0 != null;

  // "protocolo_retirada" field.
  String? _protocoloRetirada;
  String get protocoloRetirada => _protocoloRetirada ?? '';
  set protocoloRetirada(String? val) => _protocoloRetirada = val;

  bool hasProtocoloRetirada() => _protocoloRetirada != null;

  // "protocolo_iatf" field.
  String? _protocoloIatf;
  String get protocoloIatf => _protocoloIatf ?? '';
  set protocoloIatf(String? val) => _protocoloIatf = val;

  bool hasProtocoloIatf() => _protocoloIatf != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  static SanidadeStruct fromMap(Map<String, dynamic> data) => SanidadeStruct(
        idPropriedade: data['id_propriedade'] as String?,
        idRebanho: data['id_rebanho'] as String?,
        dataSanidade: data['data_sanidade'] as String?,
        idLote: data['id_lote'] as String?,
        porcentagemLote: castToType<double>(data['porcentagem_lote']),
        idSanidade: data['id_sanidade'] as String?,
        updatedAt: data['updated_at'] as String?,
        deletado: data['deletado'] as String?,
        vacinacao: data['vacinacao'] as String?,
        vacOutros: data['vac_outros'] as String?,
        vacObs: data['vac_obs'] as String?,
        antiparasitario: data['antiparasitario'] as String?,
        antiOutros: data['anti_outros'] as String?,
        antiObs: data['anti_obs'] as String?,
        tratamento: data['tratamento'] as String?,
        tratOutros: data['trat_outros'] as String?,
        tratObs: data['trat_obs'] as String?,
        protocoloReprodutivo: data['protocolo_reprodutivo'] as String?,
        reproOutros: data['repro_outros'] as String?,
        reproObs: data['repro_obs'] as String?,
        createdAt: data['created_at'] as String?,
        protocoloD0: data['protocolo_d0'] as String?,
        protocoloRetirada: data['protocolo_retirada'] as String?,
        protocoloIatf: data['protocolo_iatf'] as String?,
        id: castToType<int>(data['id']),
      );

  static SanidadeStruct? maybeFromMap(dynamic data) =>
      data is Map ? SanidadeStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id_propriedade': _idPropriedade,
        'id_rebanho': _idRebanho,
        'data_sanidade': _dataSanidade,
        'id_lote': _idLote,
        'porcentagem_lote': _porcentagemLote,
        'id_sanidade': _idSanidade,
        'updated_at': _updatedAt,
        'deletado': _deletado,
        'vacinacao': _vacinacao,
        'vac_outros': _vacOutros,
        'vac_obs': _vacObs,
        'antiparasitario': _antiparasitario,
        'anti_outros': _antiOutros,
        'anti_obs': _antiObs,
        'tratamento': _tratamento,
        'trat_outros': _tratOutros,
        'trat_obs': _tratObs,
        'protocolo_reprodutivo': _protocoloReprodutivo,
        'repro_outros': _reproOutros,
        'repro_obs': _reproObs,
        'created_at': _createdAt,
        'protocolo_d0': _protocoloD0,
        'protocolo_retirada': _protocoloRetirada,
        'protocolo_iatf': _protocoloIatf,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id_propriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'id_rebanho': serializeParam(
          _idRebanho,
          ParamType.String,
        ),
        'data_sanidade': serializeParam(
          _dataSanidade,
          ParamType.String,
        ),
        'id_lote': serializeParam(
          _idLote,
          ParamType.String,
        ),
        'porcentagem_lote': serializeParam(
          _porcentagemLote,
          ParamType.double,
        ),
        'id_sanidade': serializeParam(
          _idSanidade,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
        'deletado': serializeParam(
          _deletado,
          ParamType.String,
        ),
        'vacinacao': serializeParam(
          _vacinacao,
          ParamType.String,
        ),
        'vac_outros': serializeParam(
          _vacOutros,
          ParamType.String,
        ),
        'vac_obs': serializeParam(
          _vacObs,
          ParamType.String,
        ),
        'antiparasitario': serializeParam(
          _antiparasitario,
          ParamType.String,
        ),
        'anti_outros': serializeParam(
          _antiOutros,
          ParamType.String,
        ),
        'anti_obs': serializeParam(
          _antiObs,
          ParamType.String,
        ),
        'tratamento': serializeParam(
          _tratamento,
          ParamType.String,
        ),
        'trat_outros': serializeParam(
          _tratOutros,
          ParamType.String,
        ),
        'trat_obs': serializeParam(
          _tratObs,
          ParamType.String,
        ),
        'protocolo_reprodutivo': serializeParam(
          _protocoloReprodutivo,
          ParamType.String,
        ),
        'repro_outros': serializeParam(
          _reproOutros,
          ParamType.String,
        ),
        'repro_obs': serializeParam(
          _reproObs,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'protocolo_d0': serializeParam(
          _protocoloD0,
          ParamType.String,
        ),
        'protocolo_retirada': serializeParam(
          _protocoloRetirada,
          ParamType.String,
        ),
        'protocolo_iatf': serializeParam(
          _protocoloIatf,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
      }.withoutNulls;

  static SanidadeStruct fromSerializableMap(Map<String, dynamic> data) =>
      SanidadeStruct(
        idPropriedade: deserializeParam(
          data['id_propriedade'],
          ParamType.String,
          false,
        ),
        idRebanho: deserializeParam(
          data['id_rebanho'],
          ParamType.String,
          false,
        ),
        dataSanidade: deserializeParam(
          data['data_sanidade'],
          ParamType.String,
          false,
        ),
        idLote: deserializeParam(
          data['id_lote'],
          ParamType.String,
          false,
        ),
        porcentagemLote: deserializeParam(
          data['porcentagem_lote'],
          ParamType.double,
          false,
        ),
        idSanidade: deserializeParam(
          data['id_sanidade'],
          ParamType.String,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.String,
          false,
        ),
        deletado: deserializeParam(
          data['deletado'],
          ParamType.String,
          false,
        ),
        vacinacao: deserializeParam(
          data['vacinacao'],
          ParamType.String,
          false,
        ),
        vacOutros: deserializeParam(
          data['vac_outros'],
          ParamType.String,
          false,
        ),
        vacObs: deserializeParam(
          data['vac_obs'],
          ParamType.String,
          false,
        ),
        antiparasitario: deserializeParam(
          data['antiparasitario'],
          ParamType.String,
          false,
        ),
        antiOutros: deserializeParam(
          data['anti_outros'],
          ParamType.String,
          false,
        ),
        antiObs: deserializeParam(
          data['anti_obs'],
          ParamType.String,
          false,
        ),
        tratamento: deserializeParam(
          data['tratamento'],
          ParamType.String,
          false,
        ),
        tratOutros: deserializeParam(
          data['trat_outros'],
          ParamType.String,
          false,
        ),
        tratObs: deserializeParam(
          data['trat_obs'],
          ParamType.String,
          false,
        ),
        protocoloReprodutivo: deserializeParam(
          data['protocolo_reprodutivo'],
          ParamType.String,
          false,
        ),
        reproOutros: deserializeParam(
          data['repro_outros'],
          ParamType.String,
          false,
        ),
        reproObs: deserializeParam(
          data['repro_obs'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        protocoloD0: deserializeParam(
          data['protocolo_d0'],
          ParamType.String,
          false,
        ),
        protocoloRetirada: deserializeParam(
          data['protocolo_retirada'],
          ParamType.String,
          false,
        ),
        protocoloIatf: deserializeParam(
          data['protocolo_iatf'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SanidadeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SanidadeStruct &&
        idPropriedade == other.idPropriedade &&
        idRebanho == other.idRebanho &&
        dataSanidade == other.dataSanidade &&
        idLote == other.idLote &&
        porcentagemLote == other.porcentagemLote &&
        idSanidade == other.idSanidade &&
        updatedAt == other.updatedAt &&
        deletado == other.deletado &&
        vacinacao == other.vacinacao &&
        vacOutros == other.vacOutros &&
        vacObs == other.vacObs &&
        antiparasitario == other.antiparasitario &&
        antiOutros == other.antiOutros &&
        antiObs == other.antiObs &&
        tratamento == other.tratamento &&
        tratOutros == other.tratOutros &&
        tratObs == other.tratObs &&
        protocoloReprodutivo == other.protocoloReprodutivo &&
        reproOutros == other.reproOutros &&
        reproObs == other.reproObs &&
        createdAt == other.createdAt &&
        protocoloD0 == other.protocoloD0 &&
        protocoloRetirada == other.protocoloRetirada &&
        protocoloIatf == other.protocoloIatf &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idPropriedade,
        idRebanho,
        dataSanidade,
        idLote,
        porcentagemLote,
        idSanidade,
        updatedAt,
        deletado,
        vacinacao,
        vacOutros,
        vacObs,
        antiparasitario,
        antiOutros,
        antiObs,
        tratamento,
        tratOutros,
        tratObs,
        protocoloReprodutivo,
        reproOutros,
        reproObs,
        createdAt,
        protocoloD0,
        protocoloRetirada,
        protocoloIatf,
        id
      ]);
}

SanidadeStruct createSanidadeStruct({
  String? idPropriedade,
  String? idRebanho,
  String? dataSanidade,
  String? idLote,
  double? porcentagemLote,
  String? idSanidade,
  String? updatedAt,
  String? deletado,
  String? vacinacao,
  String? vacOutros,
  String? vacObs,
  String? antiparasitario,
  String? antiOutros,
  String? antiObs,
  String? tratamento,
  String? tratOutros,
  String? tratObs,
  String? protocoloReprodutivo,
  String? reproOutros,
  String? reproObs,
  String? createdAt,
  String? protocoloD0,
  String? protocoloRetirada,
  String? protocoloIatf,
  int? id,
}) =>
    SanidadeStruct(
      idPropriedade: idPropriedade,
      idRebanho: idRebanho,
      dataSanidade: dataSanidade,
      idLote: idLote,
      porcentagemLote: porcentagemLote,
      idSanidade: idSanidade,
      updatedAt: updatedAt,
      deletado: deletado,
      vacinacao: vacinacao,
      vacOutros: vacOutros,
      vacObs: vacObs,
      antiparasitario: antiparasitario,
      antiOutros: antiOutros,
      antiObs: antiObs,
      tratamento: tratamento,
      tratOutros: tratOutros,
      tratObs: tratObs,
      protocoloReprodutivo: protocoloReprodutivo,
      reproOutros: reproOutros,
      reproObs: reproObs,
      createdAt: createdAt,
      protocoloD0: protocoloD0,
      protocoloRetirada: protocoloRetirada,
      protocoloIatf: protocoloIatf,
      id: id,
    );
