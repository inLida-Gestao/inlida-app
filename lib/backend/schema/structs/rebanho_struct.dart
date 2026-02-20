// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RebanhoStruct extends BaseStruct {
  RebanhoStruct({
    String? idPropriedade,
    String? numeroAnimal,
    String? chip,
    String? codRegistro,
    String? nome,
    String? sexo,
    String? categoria,
    String? dataNascimento,
    double? pesoNascimento,
    String? porte,
    String? raca,
    String? loteId,
    String? dataEntradaLote,
    String? rebanhoIdMatriz,
    String? rebanhoIdReprodutor,
    String? dataDesmama,
    double? pesoDesmama,
    double? pesoAtual,
    String? status,
    String? origem,
    String? anotacoes,
    String? idRebanho,
    String? tipo,
    String? dataAcao,
    double? valorCompra,
    String? dataUltimaPesagem,
    String? nomeConcat,
    String? loteNome,
    String? movimentacaoentrada,
    String? dataVenda,
    double? valorVenda,
    String? numeroMatriz,
    String? nomeMatriz,
    String? dataNascMatriz,
    String? racaMatriz,
    String? numeroReprodutor,
    String? nomeReprodutor,
    String? dataNascReprodutor,
    String? racaReprodutor,
    String? movimentacaosaida,
    String? datamorte,
    String? motivoMorte,
    String? categoriaMatriz,
  })  : _idPropriedade = idPropriedade,
        _numeroAnimal = numeroAnimal,
        _chip = chip,
        _codRegistro = codRegistro,
        _nome = nome,
        _sexo = sexo,
        _categoria = categoria,
        _dataNascimento = dataNascimento,
        _pesoNascimento = pesoNascimento,
        _porte = porte,
        _raca = raca,
        _loteId = loteId,
        _dataEntradaLote = dataEntradaLote,
        _rebanhoIdMatriz = rebanhoIdMatriz,
        _rebanhoIdReprodutor = rebanhoIdReprodutor,
        _dataDesmama = dataDesmama,
        _pesoDesmama = pesoDesmama,
        _pesoAtual = pesoAtual,
        _status = status,
        _origem = origem,
        _anotacoes = anotacoes,
        _idRebanho = idRebanho,
        _tipo = tipo,
        _dataAcao = dataAcao,
        _valorCompra = valorCompra,
        _dataUltimaPesagem = dataUltimaPesagem,
        _nomeConcat = nomeConcat,
        _loteNome = loteNome,
        _movimentacaoentrada = movimentacaoentrada,
        _dataVenda = dataVenda,
        _valorVenda = valorVenda,
        _numeroMatriz = numeroMatriz,
        _nomeMatriz = nomeMatriz,
        _dataNascMatriz = dataNascMatriz,
        _racaMatriz = racaMatriz,
        _numeroReprodutor = numeroReprodutor,
        _nomeReprodutor = nomeReprodutor,
        _dataNascReprodutor = dataNascReprodutor,
        _racaReprodutor = racaReprodutor,
        _movimentacaosaida = movimentacaosaida,
        _datamorte = datamorte,
        _motivoMorte = motivoMorte,
        _categoriaMatriz = categoriaMatriz;

  // "id_propriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "numero_animal" field.
  String? _numeroAnimal;
  String get numeroAnimal => _numeroAnimal ?? '';
  set numeroAnimal(String? val) => _numeroAnimal = val;

  bool hasNumeroAnimal() => _numeroAnimal != null;

  // "chip" field.
  String? _chip;
  String get chip => _chip ?? '';
  set chip(String? val) => _chip = val;

  bool hasChip() => _chip != null;

  // "cod_registro" field.
  String? _codRegistro;
  String get codRegistro => _codRegistro ?? '';
  set codRegistro(String? val) => _codRegistro = val;

  bool hasCodRegistro() => _codRegistro != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "sexo" field.
  String? _sexo;
  String get sexo => _sexo ?? '';
  set sexo(String? val) => _sexo = val;

  bool hasSexo() => _sexo != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "data_nascimento" field.
  String? _dataNascimento;
  String get dataNascimento => _dataNascimento ?? '';
  set dataNascimento(String? val) => _dataNascimento = val;

  bool hasDataNascimento() => _dataNascimento != null;

  // "peso_nascimento" field.
  double? _pesoNascimento;
  double get pesoNascimento => _pesoNascimento ?? 0.0;
  set pesoNascimento(double? val) => _pesoNascimento = val;

  void incrementPesoNascimento(double amount) =>
      pesoNascimento = pesoNascimento + amount;

  bool hasPesoNascimento() => _pesoNascimento != null;

  // "porte" field.
  String? _porte;
  String get porte => _porte ?? '';
  set porte(String? val) => _porte = val;

  bool hasPorte() => _porte != null;

  // "raca" field.
  String? _raca;
  String get raca => _raca ?? '';
  set raca(String? val) => _raca = val;

  bool hasRaca() => _raca != null;

  // "lote_id" field.
  String? _loteId;
  String get loteId => _loteId ?? '';
  set loteId(String? val) => _loteId = val;

  bool hasLoteId() => _loteId != null;

  // "data_entrada_lote" field.
  String? _dataEntradaLote;
  String get dataEntradaLote => _dataEntradaLote ?? '';
  set dataEntradaLote(String? val) => _dataEntradaLote = val;

  bool hasDataEntradaLote() => _dataEntradaLote != null;

  // "rebanho_id_matriz" field.
  String? _rebanhoIdMatriz;
  String get rebanhoIdMatriz => _rebanhoIdMatriz ?? '';
  set rebanhoIdMatriz(String? val) => _rebanhoIdMatriz = val;

  bool hasRebanhoIdMatriz() => _rebanhoIdMatriz != null;

  // "rebanho_id_reprodutor" field.
  String? _rebanhoIdReprodutor;
  String get rebanhoIdReprodutor => _rebanhoIdReprodutor ?? '';
  set rebanhoIdReprodutor(String? val) => _rebanhoIdReprodutor = val;

  bool hasRebanhoIdReprodutor() => _rebanhoIdReprodutor != null;

  // "data_desmama" field.
  String? _dataDesmama;
  String get dataDesmama => _dataDesmama ?? '';
  set dataDesmama(String? val) => _dataDesmama = val;

  bool hasDataDesmama() => _dataDesmama != null;

  // "peso_desmama" field.
  double? _pesoDesmama;
  double get pesoDesmama => _pesoDesmama ?? 0.0;
  set pesoDesmama(double? val) => _pesoDesmama = val;

  void incrementPesoDesmama(double amount) =>
      pesoDesmama = pesoDesmama + amount;

  bool hasPesoDesmama() => _pesoDesmama != null;

  // "peso_atual" field.
  double? _pesoAtual;
  double get pesoAtual => _pesoAtual ?? 0.0;
  set pesoAtual(double? val) => _pesoAtual = val;

  void incrementPesoAtual(double amount) => pesoAtual = pesoAtual + amount;

  bool hasPesoAtual() => _pesoAtual != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "origem" field.
  String? _origem;
  String get origem => _origem ?? '';
  set origem(String? val) => _origem = val;

  bool hasOrigem() => _origem != null;

  // "anotacoes" field.
  String? _anotacoes;
  String get anotacoes => _anotacoes ?? '';
  set anotacoes(String? val) => _anotacoes = val;

  bool hasAnotacoes() => _anotacoes != null;

  // "id_rebanho" field.
  String? _idRebanho;
  String get idRebanho => _idRebanho ?? '';
  set idRebanho(String? val) => _idRebanho = val;

  bool hasIdRebanho() => _idRebanho != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  set tipo(String? val) => _tipo = val;

  bool hasTipo() => _tipo != null;

  // "dataAcao" field.
  String? _dataAcao;
  String get dataAcao => _dataAcao ?? '';
  set dataAcao(String? val) => _dataAcao = val;

  bool hasDataAcao() => _dataAcao != null;

  // "valorCompra" field.
  double? _valorCompra;
  double get valorCompra => _valorCompra ?? 0.0;
  set valorCompra(double? val) => _valorCompra = val;

  void incrementValorCompra(double amount) =>
      valorCompra = valorCompra + amount;

  bool hasValorCompra() => _valorCompra != null;

  // "dataUltimaPesagem" field.
  String? _dataUltimaPesagem;
  String get dataUltimaPesagem => _dataUltimaPesagem ?? '';
  set dataUltimaPesagem(String? val) => _dataUltimaPesagem = val;

  bool hasDataUltimaPesagem() => _dataUltimaPesagem != null;

  // "nomeConcat" field.
  String? _nomeConcat;
  String get nomeConcat => _nomeConcat ?? '';
  set nomeConcat(String? val) => _nomeConcat = val;

  bool hasNomeConcat() => _nomeConcat != null;

  // "loteNome" field.
  String? _loteNome;
  String get loteNome => _loteNome ?? '';
  set loteNome(String? val) => _loteNome = val;

  bool hasLoteNome() => _loteNome != null;

  // "movimentacaoentrada" field.
  String? _movimentacaoentrada;
  String get movimentacaoentrada => _movimentacaoentrada ?? '';
  set movimentacaoentrada(String? val) => _movimentacaoentrada = val;

  bool hasMovimentacaoentrada() => _movimentacaoentrada != null;

  // "dataVenda" field.
  String? _dataVenda;
  String get dataVenda => _dataVenda ?? '';
  set dataVenda(String? val) => _dataVenda = val;

  bool hasDataVenda() => _dataVenda != null;

  // "valorVenda" field.
  double? _valorVenda;
  double get valorVenda => _valorVenda ?? 0.0;
  set valorVenda(double? val) => _valorVenda = val;

  void incrementValorVenda(double amount) => valorVenda = valorVenda + amount;

  bool hasValorVenda() => _valorVenda != null;

  // "numeroMatriz" field.
  String? _numeroMatriz;
  String get numeroMatriz => _numeroMatriz ?? '';
  set numeroMatriz(String? val) => _numeroMatriz = val;

  bool hasNumeroMatriz() => _numeroMatriz != null;

  // "nomeMatriz" field.
  String? _nomeMatriz;
  String get nomeMatriz => _nomeMatriz ?? '';
  set nomeMatriz(String? val) => _nomeMatriz = val;

  bool hasNomeMatriz() => _nomeMatriz != null;

  // "dataNascMatriz" field.
  String? _dataNascMatriz;
  String get dataNascMatriz => _dataNascMatriz ?? '';
  set dataNascMatriz(String? val) => _dataNascMatriz = val;

  bool hasDataNascMatriz() => _dataNascMatriz != null;

  // "racaMatriz" field.
  String? _racaMatriz;
  String get racaMatriz => _racaMatriz ?? '';
  set racaMatriz(String? val) => _racaMatriz = val;

  bool hasRacaMatriz() => _racaMatriz != null;

  // "numeroReprodutor" field.
  String? _numeroReprodutor;
  String get numeroReprodutor => _numeroReprodutor ?? '';
  set numeroReprodutor(String? val) => _numeroReprodutor = val;

  bool hasNumeroReprodutor() => _numeroReprodutor != null;

  // "nomeReprodutor" field.
  String? _nomeReprodutor;
  String get nomeReprodutor => _nomeReprodutor ?? '';
  set nomeReprodutor(String? val) => _nomeReprodutor = val;

  bool hasNomeReprodutor() => _nomeReprodutor != null;

  // "dataNascReprodutor" field.
  String? _dataNascReprodutor;
  String get dataNascReprodutor => _dataNascReprodutor ?? '';
  set dataNascReprodutor(String? val) => _dataNascReprodutor = val;

  bool hasDataNascReprodutor() => _dataNascReprodutor != null;

  // "racaReprodutor" field.
  String? _racaReprodutor;
  String get racaReprodutor => _racaReprodutor ?? '';
  set racaReprodutor(String? val) => _racaReprodutor = val;

  bool hasRacaReprodutor() => _racaReprodutor != null;

  // "movimentacaosaida" field.
  String? _movimentacaosaida;
  String get movimentacaosaida => _movimentacaosaida ?? '';
  set movimentacaosaida(String? val) => _movimentacaosaida = val;

  bool hasMovimentacaosaida() => _movimentacaosaida != null;

  // "datamorte" field.
  String? _datamorte;
  String get datamorte => _datamorte ?? '';
  set datamorte(String? val) => _datamorte = val;

  bool hasDatamorte() => _datamorte != null;

  // "motivo_morte" field.
  String? _motivoMorte;
  String get motivoMorte => _motivoMorte ?? '';
  set motivoMorte(String? val) => _motivoMorte = val;

  bool hasMotivoMorte() => _motivoMorte != null;

  // "categoria_matriz" field.
  String? _categoriaMatriz;
  String get categoriaMatriz => _categoriaMatriz ?? '';
  set categoriaMatriz(String? val) => _categoriaMatriz = val;

  bool hasCategoriaMatriz() => _categoriaMatriz != null;

  static RebanhoStruct fromMap(Map<String, dynamic> data) => RebanhoStruct(
        idPropriedade: data['id_propriedade'] as String?,
        numeroAnimal: data['numero_animal'] as String?,
        chip: data['chip'] as String?,
        codRegistro: data['cod_registro'] as String?,
        nome: data['nome'] as String?,
        sexo: data['sexo'] as String?,
        categoria: data['categoria'] as String?,
        dataNascimento: data['data_nascimento'] as String?,
        pesoNascimento: castToType<double>(data['peso_nascimento']),
        porte: data['porte'] as String?,
        raca: data['raca'] as String?,
        loteId: data['lote_id'] as String?,
        dataEntradaLote: data['data_entrada_lote'] as String?,
        rebanhoIdMatriz: data['rebanho_id_matriz'] as String?,
        rebanhoIdReprodutor: data['rebanho_id_reprodutor'] as String?,
        dataDesmama: data['data_desmama'] as String?,
        pesoDesmama: castToType<double>(data['peso_desmama']),
        pesoAtual: castToType<double>(data['peso_atual']),
        status: data['status'] as String?,
        origem: data['origem'] as String?,
        anotacoes: data['anotacoes'] as String?,
        idRebanho: data['id_rebanho'] as String?,
        tipo: data['tipo'] as String?,
        dataAcao: data['dataAcao'] as String?,
        valorCompra: castToType<double>(data['valorCompra']),
        dataUltimaPesagem: data['dataUltimaPesagem'] as String?,
        nomeConcat: data['nomeConcat'] as String?,
        loteNome: data['loteNome'] as String?,
        movimentacaoentrada: data['movimentacaoentrada'] as String?,
        dataVenda: data['dataVenda'] as String?,
        valorVenda: castToType<double>(data['valorVenda']),
        numeroMatriz: data['numeroMatriz'] as String?,
        nomeMatriz: data['nomeMatriz'] as String?,
        dataNascMatriz: data['dataNascMatriz'] as String?,
        racaMatriz: data['racaMatriz'] as String?,
        numeroReprodutor: data['numeroReprodutor'] as String?,
        nomeReprodutor: data['nomeReprodutor'] as String?,
        dataNascReprodutor: data['dataNascReprodutor'] as String?,
        racaReprodutor: data['racaReprodutor'] as String?,
        movimentacaosaida: data['movimentacaosaida'] as String?,
        datamorte: data['datamorte'] as String?,
        motivoMorte: data['motivo_morte'] as String?,
        categoriaMatriz: data['categoria_matriz'] as String?,
      );

  static RebanhoStruct? maybeFromMap(dynamic data) =>
      data is Map ? RebanhoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id_propriedade': _idPropriedade,
        'numero_animal': _numeroAnimal,
        'chip': _chip,
        'cod_registro': _codRegistro,
        'nome': _nome,
        'sexo': _sexo,
        'categoria': _categoria,
        'data_nascimento': _dataNascimento,
        'peso_nascimento': _pesoNascimento,
        'porte': _porte,
        'raca': _raca,
        'lote_id': _loteId,
        'data_entrada_lote': _dataEntradaLote,
        'rebanho_id_matriz': _rebanhoIdMatriz,
        'rebanho_id_reprodutor': _rebanhoIdReprodutor,
        'data_desmama': _dataDesmama,
        'peso_desmama': _pesoDesmama,
        'peso_atual': _pesoAtual,
        'status': _status,
        'origem': _origem,
        'anotacoes': _anotacoes,
        'id_rebanho': _idRebanho,
        'tipo': _tipo,
        'dataAcao': _dataAcao,
        'valorCompra': _valorCompra,
        'dataUltimaPesagem': _dataUltimaPesagem,
        'nomeConcat': _nomeConcat,
        'loteNome': _loteNome,
        'movimentacaoentrada': _movimentacaoentrada,
        'dataVenda': _dataVenda,
        'valorVenda': _valorVenda,
        'numeroMatriz': _numeroMatriz,
        'nomeMatriz': _nomeMatriz,
        'dataNascMatriz': _dataNascMatriz,
        'racaMatriz': _racaMatriz,
        'numeroReprodutor': _numeroReprodutor,
        'nomeReprodutor': _nomeReprodutor,
        'dataNascReprodutor': _dataNascReprodutor,
        'racaReprodutor': _racaReprodutor,
        'movimentacaosaida': _movimentacaosaida,
        'datamorte': _datamorte,
        'motivo_morte': _motivoMorte,
        'categoria_matriz': _categoriaMatriz,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id_propriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'numero_animal': serializeParam(
          _numeroAnimal,
          ParamType.String,
        ),
        'chip': serializeParam(
          _chip,
          ParamType.String,
        ),
        'cod_registro': serializeParam(
          _codRegistro,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'sexo': serializeParam(
          _sexo,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'data_nascimento': serializeParam(
          _dataNascimento,
          ParamType.String,
        ),
        'peso_nascimento': serializeParam(
          _pesoNascimento,
          ParamType.double,
        ),
        'porte': serializeParam(
          _porte,
          ParamType.String,
        ),
        'raca': serializeParam(
          _raca,
          ParamType.String,
        ),
        'lote_id': serializeParam(
          _loteId,
          ParamType.String,
        ),
        'data_entrada_lote': serializeParam(
          _dataEntradaLote,
          ParamType.String,
        ),
        'rebanho_id_matriz': serializeParam(
          _rebanhoIdMatriz,
          ParamType.String,
        ),
        'rebanho_id_reprodutor': serializeParam(
          _rebanhoIdReprodutor,
          ParamType.String,
        ),
        'data_desmama': serializeParam(
          _dataDesmama,
          ParamType.String,
        ),
        'peso_desmama': serializeParam(
          _pesoDesmama,
          ParamType.double,
        ),
        'peso_atual': serializeParam(
          _pesoAtual,
          ParamType.double,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'origem': serializeParam(
          _origem,
          ParamType.String,
        ),
        'anotacoes': serializeParam(
          _anotacoes,
          ParamType.String,
        ),
        'id_rebanho': serializeParam(
          _idRebanho,
          ParamType.String,
        ),
        'tipo': serializeParam(
          _tipo,
          ParamType.String,
        ),
        'dataAcao': serializeParam(
          _dataAcao,
          ParamType.String,
        ),
        'valorCompra': serializeParam(
          _valorCompra,
          ParamType.double,
        ),
        'dataUltimaPesagem': serializeParam(
          _dataUltimaPesagem,
          ParamType.String,
        ),
        'nomeConcat': serializeParam(
          _nomeConcat,
          ParamType.String,
        ),
        'loteNome': serializeParam(
          _loteNome,
          ParamType.String,
        ),
        'movimentacaoentrada': serializeParam(
          _movimentacaoentrada,
          ParamType.String,
        ),
        'dataVenda': serializeParam(
          _dataVenda,
          ParamType.String,
        ),
        'valorVenda': serializeParam(
          _valorVenda,
          ParamType.double,
        ),
        'numeroMatriz': serializeParam(
          _numeroMatriz,
          ParamType.String,
        ),
        'nomeMatriz': serializeParam(
          _nomeMatriz,
          ParamType.String,
        ),
        'dataNascMatriz': serializeParam(
          _dataNascMatriz,
          ParamType.String,
        ),
        'racaMatriz': serializeParam(
          _racaMatriz,
          ParamType.String,
        ),
        'numeroReprodutor': serializeParam(
          _numeroReprodutor,
          ParamType.String,
        ),
        'nomeReprodutor': serializeParam(
          _nomeReprodutor,
          ParamType.String,
        ),
        'dataNascReprodutor': serializeParam(
          _dataNascReprodutor,
          ParamType.String,
        ),
        'racaReprodutor': serializeParam(
          _racaReprodutor,
          ParamType.String,
        ),
        'movimentacaosaida': serializeParam(
          _movimentacaosaida,
          ParamType.String,
        ),
        'datamorte': serializeParam(
          _datamorte,
          ParamType.String,
        ),
        'motivo_morte': serializeParam(
          _motivoMorte,
          ParamType.String,
        ),
        'categoria_matriz': serializeParam(
          _categoriaMatriz,
          ParamType.String,
        ),
      }.withoutNulls;

  static RebanhoStruct fromSerializableMap(Map<String, dynamic> data) =>
      RebanhoStruct(
        idPropriedade: deserializeParam(
          data['id_propriedade'],
          ParamType.String,
          false,
        ),
        numeroAnimal: deserializeParam(
          data['numero_animal'],
          ParamType.String,
          false,
        ),
        chip: deserializeParam(
          data['chip'],
          ParamType.String,
          false,
        ),
        codRegistro: deserializeParam(
          data['cod_registro'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        sexo: deserializeParam(
          data['sexo'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        dataNascimento: deserializeParam(
          data['data_nascimento'],
          ParamType.String,
          false,
        ),
        pesoNascimento: deserializeParam(
          data['peso_nascimento'],
          ParamType.double,
          false,
        ),
        porte: deserializeParam(
          data['porte'],
          ParamType.String,
          false,
        ),
        raca: deserializeParam(
          data['raca'],
          ParamType.String,
          false,
        ),
        loteId: deserializeParam(
          data['lote_id'],
          ParamType.String,
          false,
        ),
        dataEntradaLote: deserializeParam(
          data['data_entrada_lote'],
          ParamType.String,
          false,
        ),
        rebanhoIdMatriz: deserializeParam(
          data['rebanho_id_matriz'],
          ParamType.String,
          false,
        ),
        rebanhoIdReprodutor: deserializeParam(
          data['rebanho_id_reprodutor'],
          ParamType.String,
          false,
        ),
        dataDesmama: deserializeParam(
          data['data_desmama'],
          ParamType.String,
          false,
        ),
        pesoDesmama: deserializeParam(
          data['peso_desmama'],
          ParamType.double,
          false,
        ),
        pesoAtual: deserializeParam(
          data['peso_atual'],
          ParamType.double,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        origem: deserializeParam(
          data['origem'],
          ParamType.String,
          false,
        ),
        anotacoes: deserializeParam(
          data['anotacoes'],
          ParamType.String,
          false,
        ),
        idRebanho: deserializeParam(
          data['id_rebanho'],
          ParamType.String,
          false,
        ),
        tipo: deserializeParam(
          data['tipo'],
          ParamType.String,
          false,
        ),
        dataAcao: deserializeParam(
          data['dataAcao'],
          ParamType.String,
          false,
        ),
        valorCompra: deserializeParam(
          data['valorCompra'],
          ParamType.double,
          false,
        ),
        dataUltimaPesagem: deserializeParam(
          data['dataUltimaPesagem'],
          ParamType.String,
          false,
        ),
        nomeConcat: deserializeParam(
          data['nomeConcat'],
          ParamType.String,
          false,
        ),
        loteNome: deserializeParam(
          data['loteNome'],
          ParamType.String,
          false,
        ),
        movimentacaoentrada: deserializeParam(
          data['movimentacaoentrada'],
          ParamType.String,
          false,
        ),
        dataVenda: deserializeParam(
          data['dataVenda'],
          ParamType.String,
          false,
        ),
        valorVenda: deserializeParam(
          data['valorVenda'],
          ParamType.double,
          false,
        ),
        numeroMatriz: deserializeParam(
          data['numeroMatriz'],
          ParamType.String,
          false,
        ),
        nomeMatriz: deserializeParam(
          data['nomeMatriz'],
          ParamType.String,
          false,
        ),
        dataNascMatriz: deserializeParam(
          data['dataNascMatriz'],
          ParamType.String,
          false,
        ),
        racaMatriz: deserializeParam(
          data['racaMatriz'],
          ParamType.String,
          false,
        ),
        numeroReprodutor: deserializeParam(
          data['numeroReprodutor'],
          ParamType.String,
          false,
        ),
        nomeReprodutor: deserializeParam(
          data['nomeReprodutor'],
          ParamType.String,
          false,
        ),
        dataNascReprodutor: deserializeParam(
          data['dataNascReprodutor'],
          ParamType.String,
          false,
        ),
        racaReprodutor: deserializeParam(
          data['racaReprodutor'],
          ParamType.String,
          false,
        ),
        movimentacaosaida: deserializeParam(
          data['movimentacaosaida'],
          ParamType.String,
          false,
        ),
        datamorte: deserializeParam(
          data['datamorte'],
          ParamType.String,
          false,
        ),
        motivoMorte: deserializeParam(
          data['motivo_morte'],
          ParamType.String,
          false,
        ),
        categoriaMatriz: deserializeParam(
          data['categoria_matriz'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RebanhoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RebanhoStruct &&
        idPropriedade == other.idPropriedade &&
        numeroAnimal == other.numeroAnimal &&
        chip == other.chip &&
        codRegistro == other.codRegistro &&
        nome == other.nome &&
        sexo == other.sexo &&
        categoria == other.categoria &&
        dataNascimento == other.dataNascimento &&
        pesoNascimento == other.pesoNascimento &&
        porte == other.porte &&
        raca == other.raca &&
        loteId == other.loteId &&
        dataEntradaLote == other.dataEntradaLote &&
        rebanhoIdMatriz == other.rebanhoIdMatriz &&
        rebanhoIdReprodutor == other.rebanhoIdReprodutor &&
        dataDesmama == other.dataDesmama &&
        pesoDesmama == other.pesoDesmama &&
        pesoAtual == other.pesoAtual &&
        status == other.status &&
        origem == other.origem &&
        anotacoes == other.anotacoes &&
        idRebanho == other.idRebanho &&
        tipo == other.tipo &&
        dataAcao == other.dataAcao &&
        valorCompra == other.valorCompra &&
        dataUltimaPesagem == other.dataUltimaPesagem &&
        nomeConcat == other.nomeConcat &&
        loteNome == other.loteNome &&
        movimentacaoentrada == other.movimentacaoentrada &&
        dataVenda == other.dataVenda &&
        valorVenda == other.valorVenda &&
        numeroMatriz == other.numeroMatriz &&
        nomeMatriz == other.nomeMatriz &&
        dataNascMatriz == other.dataNascMatriz &&
        racaMatriz == other.racaMatriz &&
        numeroReprodutor == other.numeroReprodutor &&
        nomeReprodutor == other.nomeReprodutor &&
        dataNascReprodutor == other.dataNascReprodutor &&
        racaReprodutor == other.racaReprodutor &&
        movimentacaosaida == other.movimentacaosaida &&
        datamorte == other.datamorte &&
        motivoMorte == other.motivoMorte &&
        categoriaMatriz == other.categoriaMatriz;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idPropriedade,
        numeroAnimal,
        chip,
        codRegistro,
        nome,
        sexo,
        categoria,
        dataNascimento,
        pesoNascimento,
        porte,
        raca,
        loteId,
        dataEntradaLote,
        rebanhoIdMatriz,
        rebanhoIdReprodutor,
        dataDesmama,
        pesoDesmama,
        pesoAtual,
        status,
        origem,
        anotacoes,
        idRebanho,
        tipo,
        dataAcao,
        valorCompra,
        dataUltimaPesagem,
        nomeConcat,
        loteNome,
        movimentacaoentrada,
        dataVenda,
        valorVenda,
        numeroMatriz,
        nomeMatriz,
        dataNascMatriz,
        racaMatriz,
        numeroReprodutor,
        nomeReprodutor,
        dataNascReprodutor,
        racaReprodutor,
        movimentacaosaida,
        datamorte,
        motivoMorte,
        categoriaMatriz
      ]);
}

RebanhoStruct createRebanhoStruct({
  String? idPropriedade,
  String? numeroAnimal,
  String? chip,
  String? codRegistro,
  String? nome,
  String? sexo,
  String? categoria,
  String? dataNascimento,
  double? pesoNascimento,
  String? porte,
  String? raca,
  String? loteId,
  String? dataEntradaLote,
  String? rebanhoIdMatriz,
  String? rebanhoIdReprodutor,
  String? dataDesmama,
  double? pesoDesmama,
  double? pesoAtual,
  String? status,
  String? origem,
  String? anotacoes,
  String? idRebanho,
  String? tipo,
  String? dataAcao,
  double? valorCompra,
  String? dataUltimaPesagem,
  String? nomeConcat,
  String? loteNome,
  String? movimentacaoentrada,
  String? dataVenda,
  double? valorVenda,
  String? numeroMatriz,
  String? nomeMatriz,
  String? dataNascMatriz,
  String? racaMatriz,
  String? numeroReprodutor,
  String? nomeReprodutor,
  String? dataNascReprodutor,
  String? racaReprodutor,
  String? movimentacaosaida,
  String? datamorte,
  String? motivoMorte,
  String? categoriaMatriz,
}) =>
    RebanhoStruct(
      idPropriedade: idPropriedade,
      numeroAnimal: numeroAnimal,
      chip: chip,
      codRegistro: codRegistro,
      nome: nome,
      sexo: sexo,
      categoria: categoria,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
      porte: porte,
      raca: raca,
      loteId: loteId,
      dataEntradaLote: dataEntradaLote,
      rebanhoIdMatriz: rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhoIdReprodutor,
      dataDesmama: dataDesmama,
      pesoDesmama: pesoDesmama,
      pesoAtual: pesoAtual,
      status: status,
      origem: origem,
      anotacoes: anotacoes,
      idRebanho: idRebanho,
      tipo: tipo,
      dataAcao: dataAcao,
      valorCompra: valorCompra,
      dataUltimaPesagem: dataUltimaPesagem,
      nomeConcat: nomeConcat,
      loteNome: loteNome,
      movimentacaoentrada: movimentacaoentrada,
      dataVenda: dataVenda,
      valorVenda: valorVenda,
      numeroMatriz: numeroMatriz,
      nomeMatriz: nomeMatriz,
      dataNascMatriz: dataNascMatriz,
      racaMatriz: racaMatriz,
      numeroReprodutor: numeroReprodutor,
      nomeReprodutor: nomeReprodutor,
      dataNascReprodutor: dataNascReprodutor,
      racaReprodutor: racaReprodutor,
      movimentacaosaida: movimentacaosaida,
      datamorte: datamorte,
      motivoMorte: motivoMorte,
      categoriaMatriz: categoriaMatriz,
    );
