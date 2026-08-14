import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/utils/lote_dropdown_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lotes/edit_lote/edit_lote_widget.dart';
import '/rebanho/view_rebanho/view_rebanho_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_lote_model.dart';
export 'view_lote_model.dart';

class _LoteGmdAnimalResult {
  const _LoteGmdAnimalResult({
    required this.animal,
    this.pesoInicial,
    this.pesoFinal,
    this.dataInicial,
    this.dataFinal,
    this.diasAvaliados,
    this.gmd,
    this.motivoNaoCalculavel,
  });

  final RebanhoStruct animal;
  final double? pesoInicial;
  final double? pesoFinal;
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final int? diasAvaliados;
  final double? gmd;
  final String? motivoNaoCalculavel;

  bool get calculavel => gmd != null;
}

class _LoteGmdPesagem {
  const _LoteGmdPesagem({
    required this.data,
    required this.peso,
  });

  final DateTime data;
  final double peso;
}

class _LoteGmdCalculationResult {
  const _LoteGmdCalculationResult({
    required this.pesagensValidas,
    required this.results,
    required this.dataInicial,
    required this.dataFinal,
    required this.periodoInvalido,
    required this.resultsCalculaveisCount,
    this.gmdMedio,
    this.pesoMedioInicial,
    this.pesoMedioFinal,
  });

  final List<_LoteGmdPesagem> pesagensValidas;
  final List<_LoteGmdAnimalResult> results;
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final bool periodoInvalido;
  final int resultsCalculaveisCount;
  final double? gmdMedio;
  final double? pesoMedioInicial;
  final double? pesoMedioFinal;
}

class LoteCategoriaResumo {
  const LoteCategoriaResumo({
    required this.categoria,
    required this.quantidade,
    required this.proporcao,
  });

  final String categoria;
  final int quantidade;
  final double proporcao;
}

const _categoriasResumoLote = [
  'Bezerra',
  'Bezerro',
  'Boi Gordo',
  'Boi Magro',
  'Garrote',
  'Novilha',
  'Rufião',
  'Touro',
  'Vaca Multipara',
  'Vaca Primipara',
];

String _normalizarCategoriaResumoLote(String? categoria) {
  final value = (categoria ?? '').trim().toLowerCase();
  return value
      .replaceAll('á', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('â', 'a')
      .replaceAll('à', 'a')
      .replaceAll('é', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c');
}

String _rotuloCategoriaResumoLote(String categoria) {
  switch (_normalizarCategoriaResumoLote(categoria)) {
    case 'vaca multipara':
      return 'Vaca multípara';
    case 'vaca primipara':
      return 'Vaca primípara';
    default:
      return categoria;
  }
}

List<LoteCategoriaResumo> buildLoteCategoriaResumo(
  List<RebanhoStruct> animais, {
  List<String>? categorias,
}) {
  final categoriasBase = categorias == null || categorias.isEmpty
      ? _categoriasResumoLote
      : categorias;
  final categoriasNormalizadas = <String, String>{};
  for (final categoria in categoriasBase) {
    final chave = _normalizarCategoriaResumoLote(categoria);
    if (chave.isNotEmpty && !categoriasNormalizadas.containsKey(chave)) {
      categoriasNormalizadas[chave] = _rotuloCategoriaResumoLote(categoria);
    }
  }

  final contagens = <String, int>{};
  for (final animal in animais) {
    final chave = _normalizarCategoriaResumoLote(animal.categoria);
    if (categoriasNormalizadas.containsKey(chave)) {
      contagens[chave] = (contagens[chave] ?? 0) + 1;
    }
  }

  final total = animais.length;
  return categoriasNormalizadas.entries.map((entry) {
    final quantidade = contagens[entry.key] ?? 0;
    final proporcao = total == 0 ? 0.0 : quantidade / total;
    return LoteCategoriaResumo(
      categoria: entry.value,
      quantidade: quantidade,
      proporcao: proporcao.clamp(0.0, 1.0),
    );
  }).toList();
}

class ViewLoteWidget extends StatefulWidget {
  const ViewLoteWidget({
    super.key,
    required this.idLote,
  });

  final String? idLote;

  @override
  State<ViewLoteWidget> createState() => _ViewLoteWidgetState();
}

class _ViewLoteWidgetState extends State<ViewLoteWidget>
    with TickerProviderStateMixin {
  late ViewLoteModel _model;
  static const int _gmdLoteCalculationBatchSize = 60;
  static const int _gmdLoteRowsPageSize = 50;

  String? _gmdLoteCalculationKey;
  Future<_LoteGmdCalculationResult>? _gmdLoteCalculationFuture;
  int _gmdLoteProgressCurrent = 0;
  int _gmdLoteProgressTotal = 0;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewLoteModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.inputLoginFocusNode1 ??= FocusNode();

    _model.inputLoginFocusNode2 ??= FocusNode();

    _model.nAnimalFocusNode1 ??= FocusNode();

    _model.nAnimalFocusNode2 ??= FocusNode();

    _model.nAnimalFocusNode3 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  AnimaisStruct _criaMatrizToAnimaisStruct(
    BuscarCriasRebanhoMatrizRow cria,
  ) =>
      AnimaisStruct(
        idRebanho: cria.idRebanho,
        sexo: cria.sexo,
        numeroAnimal: cria.numeroAnimal,
        nome: cria.nome,
        dataNascimento: cria.dataNascimento,
        categoria: cria.categoria,
        raca: cria.raca,
        loteNome: cria.loteNome,
        rebanhoIdMatriz: cria.rebanhoIdMatriz,
        rebanhoIdReprodutor: cria.rebanhoIdReprodutor,
        numeroMatriz: cria.numeroMatriz,
        nomeMatriz: cria.nomeMatriz,
        dataNascMatriz: cria.dataNascMatriz,
        racaMatriz: cria.racaMatriz,
        numeroReprodutor: cria.numeroReprodutor,
        nomeReprodutor: cria.nomeReprodutor,
        dataNascReprodutor: cria.dataNascReprodutor,
        racaReprodutor: cria.racaReprodutor,
      );

  AnimaisStruct _criaReprodutorToAnimaisStruct(
    BuscarCriasRebanhoReprodutorRow cria,
  ) =>
      AnimaisStruct(
        idRebanho: cria.idRebanho,
        sexo: cria.sexo,
        numeroAnimal: cria.numeroAnimal,
        nome: cria.nome,
        dataNascimento: cria.dataNascimento,
        categoria: cria.categoria,
        raca: cria.raca,
        loteNome: cria.loteNome,
        rebanhoIdMatriz: cria.rebanhoIdMatriz,
        rebanhoIdReprodutor: cria.rebanhoIdReprodutor,
        numeroMatriz: cria.numeroMatriz,
        nomeMatriz: cria.nomeMatriz,
        dataNascMatriz: cria.dataNascMatriz,
        racaMatriz: cria.racaMatriz,
        numeroReprodutor: cria.numeroReprodutor,
        nomeReprodutor: cria.nomeReprodutor,
        dataNascReprodutor: cria.dataNascReprodutor,
        racaReprodutor: cria.racaReprodutor,
      );

  HistoricoPesagensStruct _pesagemToHistoricoStruct(
    BuscaHistPesagensRow pesagem,
  ) =>
      HistoricoPesagensStruct(
        idRebanho: pesagem.idRebanho,
        dataPesagem: pesagem.dataPesagem,
        tipo: pesagem.tipo,
        deletado: pesagem.deletado,
        createdAt: pesagem.createdAt,
        id: pesagem.id,
        peso: pesagem.peso,
      );

  Future<void> _prepareRebanhoStateForDialog(String idRebanho) async {
    final criasMatriz = await SQLiteManager.instance.buscarCriasRebanhoMatriz(
      idRebanho: idRebanho,
    );
    final criasReprodutor =
        await SQLiteManager.instance.buscarCriasRebanhoReprodutor(
      idRebanho: idRebanho,
    );
    final histPesagens = await SQLiteManager.instance.buscaHistPesagens(
      idRebanho: idRebanho,
    );
    final lotes = await SQLiteManager.instance.buscarLotes(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    );

    FFAppState().crias = [
      ...criasMatriz.map(_criaMatrizToAnimaisStruct),
      ...criasReprodutor.map(_criaReprodutorToAnimaisStruct),
    ];
    FFAppState().histPesagens =
        histPesagens.map(_pesagemToHistoricoStruct).toList();
    FFAppState().rebanhoLotesSelecionar = buildRebanhoLoteOptions(lotes);
  }

  Future<void> _openRebanhoDialog(String? idRebanho) async {
    final normalizedId = idRebanho?.trim();
    if (normalizedId == null || normalizedId.isEmpty) {
      return;
    }

    await _prepareRebanhoStateForDialog(normalizedId);
    if (!mounted) return;

    await showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: ViewRebanhoWidget(
            idRebanho: normalizedId,
          ),
        );
      },
    );

    if (mounted) {
      safeSetState(() {});
    }
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  String _normalizeIdRebanho(String? value) => value?.trim() ?? '';

  bool _pesagemLoteAtiva(BuscaHistPesagensRow pesagem) =>
      pesagem.deletado?.trim().toUpperCase() != 'SIM';

  DateTime? _parseLoteDate(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null ||
        trimmed.isEmpty ||
        trimmed.toLowerCase() == 'null' ||
        trimmed == '-') {
      return null;
    }

    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) return parsed;

    final parts = trimmed.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  int _comparePesagensLote(BuscaHistPesagensRow a, BuscaHistPesagensRow b) {
    final dataA = _parseLoteDate(a.dataPesagem);
    final dataB = _parseLoteDate(b.dataPesagem);
    final dataCompare =
        (dataA ?? DateTime(1900)).compareTo(dataB ?? DateTime(1900));
    if (dataCompare != 0) return dataCompare;

    final createdA = DateTime.tryParse(a.createdAt ?? '');
    final createdB = DateTime.tryParse(b.createdAt ?? '');
    final createdCompare =
        (createdA ?? DateTime(1900)).compareTo(createdB ?? DateTime(1900));
    if (createdCompare != 0) return createdCompare;

    return (a.id ?? 0).compareTo(b.id ?? 0);
  }

  String _gmdLoteAnimaisKey(List<RebanhoStruct> animais) {
    final ids = animais
        .map((animal) {
          final id = _normalizeIdRebanho(animal.idRebanho);
          if (id.isEmpty) return '';
          return [
            id,
            animal.hasPesoAtual() ? animal.pesoAtual.toString() : '',
            animal.dataUltimaPesagem,
          ].join(':');
        })
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ids.join('|');
  }

  String _formatKg(double? value) {
    if (value == null) return '-';
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} kg';
  }

  String _formatKgDia(double? value) {
    if (value == null) return '-';
    final prefix = value > 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(3).replaceAll('.', ',')} kg/d';
  }

  String _formatGmdLoteDate(DateTime? value) {
    if (value == null) return 'Selecionar';
    return dateTimeFormat(
      'd/M/y',
      value,
      locale: FFLocalizations.of(context).languageCode,
    );
  }

  Color _gmdLoteColor(double? value) {
    final theme = FlutterFlowTheme.of(context);
    if (value == null || value == 0) return theme.accent3;
    return value > 0 ? theme.success : theme.error;
  }

  double? _average(Iterable<double?> values) {
    final list = values.whereType<double>().toList();
    if (list.isEmpty) return null;
    return list.reduce((a, b) => a + b) / list.length;
  }

  Widget _buildLoteCategoriaResumo(List<RebanhoStruct> animais) {
    final resumo = buildLoteCategoriaResumo(
      animais,
      categorias: FFAppState().categoriasRebanho,
    );
    final total = animais.length;

    TextStyle textStyle({
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
    }) {
      return FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            color: color,
            fontSize: fontSize,
            letterSpacing: 0.0,
            fontWeight: fontWeight,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
          );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Animais no lote por categoria',
              style: textStyle(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Total: $total ${total == 1 ? 'animal' : 'animais'}',
              style: textStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 20.0),
            ...resumo.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Semantics(
                  label:
                      '${item.categoria}: ${item.quantidade} ${item.quantidade == 1 ? 'animal' : 'animais'}',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.categoria,
                              style: textStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            item.quantidade.toString(),
                            textAlign: TextAlign.end,
                            style: textStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          height: 8.0,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: const Color(0xFFEAEAEA)),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: item.proporcao,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _animalGmdLabel(RebanhoStruct animal) {
    if (animal.numeroAnimal.trim().isNotEmpty) return animal.numeroAnimal;
    if (animal.nome.trim().isNotEmpty) return animal.nome;
    if (animal.chip.trim().isNotEmpty) return animal.chip;
    return animal.idRebanho.trim().isNotEmpty ? animal.idRebanho : 'Animal';
  }

  Future<List<BuscaHistPesagensRow>> _loadPesagensDoLote(
    List<RebanhoStruct> animais,
  ) async {
    final ids = animais
        .map((animal) => _normalizeIdRebanho(animal.idRebanho))
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    if (ids.isEmpty) return [];

    final rows = await SQLiteManager.instance.buscaHistPesagensPorRebanhos(
      idRebanhos: ids,
    );
    final pesagens = <BuscaHistPesagensRow>[];
    final pesagensKeys = <String>{};
    for (final row in rows) {
      if (!_pesagemLoteAtiva(row)) continue;
      final key = row.id != null
          ? 'id:${row.id}'
          : [
              row.idRebanho,
              row.idPesagem,
              row.dataPesagem,
              row.peso?.toString(),
              row.createdAt,
            ].join('|');
      if (pesagensKeys.add(key)) {
        pesagens.add(row);
      }
    }

    return pesagens..sort(_comparePesagensLote);
  }

  Map<String, List<BuscaHistPesagensRow>> _indexPesagensGmdLote(
    List<BuscaHistPesagensRow> pesagens,
  ) {
    final indexed = <String, List<BuscaHistPesagensRow>>{};
    for (final pesagem in pesagens) {
      final id = _normalizeIdRebanho(pesagem.idRebanho);
      if (id.isEmpty || !_pesagemLoteAtiva(pesagem)) continue;
      (indexed[id] ??= <BuscaHistPesagensRow>[]).add(pesagem);
    }
    for (final rows in indexed.values) {
      rows.sort(_comparePesagensLote);
    }
    return indexed;
  }

  List<_LoteGmdPesagem> _buildPesagensGmdAnimal(
    RebanhoStruct animal,
    Map<String, List<BuscaHistPesagensRow>> pesagensPorAnimal,
  ) {
    final idRebanho = _normalizeIdRebanho(animal.idRebanho);
    final porDia = <DateTime, _LoteGmdPesagem>{};

    void addPesagem(DateTime? data, double? peso) {
      if (data == null || peso == null || peso <= 0) return;
      final dataDia = _dateOnly(data);
      porDia[dataDia] = _LoteGmdPesagem(data: dataDia, peso: peso);
    }

    if (animal.hasPesoNascimento()) {
      addPesagem(_parseLoteDate(animal.dataNascimento), animal.pesoNascimento);
    }
    if (animal.hasPesoDesmama()) {
      addPesagem(_parseLoteDate(animal.dataDesmama), animal.pesoDesmama);
    }
    if (animal.hasPesoAtual()) {
      addPesagem(_parseLoteDate(animal.dataUltimaPesagem), animal.pesoAtual);
    }

    final pesagensHistorico = idRebanho.isEmpty
        ? const <BuscaHistPesagensRow>[]
        : pesagensPorAnimal[idRebanho] ?? const <BuscaHistPesagensRow>[];
    for (final pesagem in pesagensHistorico) {
      if (_parseLoteDate(pesagem.dataPesagem) == null ||
          pesagem.peso == null ||
          !_pesagemLoteAtiva(pesagem)) {
        continue;
      }
      addPesagem(_parseLoteDate(pesagem.dataPesagem), pesagem.peso);
    }

    return porDia.values.toList()..sort((a, b) => a.data.compareTo(b.data));
  }

  String _gmdLoteCalculationCacheKey(
    List<RebanhoStruct> animais,
    List<BuscaHistPesagensRow> pesagens,
  ) {
    final firstPesagem = pesagens.isNotEmpty ? pesagens.first : null;
    final lastPesagem = pesagens.isNotEmpty ? pesagens.last : null;
    final pesagensKey = [
      firstPesagem?.id ?? '',
      firstPesagem?.dataPesagem ?? '',
      firstPesagem?.createdAt ?? '',
      lastPesagem?.id ?? '',
      lastPesagem?.dataPesagem ?? '',
      lastPesagem?.createdAt ?? '',
    ].join(':');
    return [
      _gmdLoteAnimaisKey(animais),
      _model.gmdLoteDataInicial?.toIso8601String() ?? '',
      _model.gmdLoteDataFinal?.toIso8601String() ?? '',
      pesagens.length,
      pesagensKey,
    ].join('#');
  }

  Future<_LoteGmdCalculationResult> _calculateGmdLoteAsync(
    List<RebanhoStruct> animais,
    List<BuscaHistPesagensRow> pesagens,
    String calculationKey,
  ) async {
    if (animais.isEmpty) {
      return const _LoteGmdCalculationResult(
        pesagensValidas: [],
        results: [],
        dataInicial: null,
        dataFinal: null,
        periodoInvalido: false,
        resultsCalculaveisCount: 0,
      );
    }

    final pesagensPorAnimal = _indexPesagensGmdLote(pesagens);
    final pontosPorAnimal = <String, List<_LoteGmdPesagem>>{};
    final todasPesagens = <_LoteGmdPesagem>[];
    for (var index = 0; index < animais.length; index++) {
      final animal = animais[index];
      final idRebanho = _normalizeIdRebanho(animal.idRebanho);
      final pontos = _buildPesagensGmdAnimal(animal, pesagensPorAnimal);
      if (idRebanho.isNotEmpty) {
        pontosPorAnimal[idRebanho] = pontos;
      }
      todasPesagens.addAll(pontos);

      final shouldYield = (index + 1) % _gmdLoteCalculationBatchSize == 0 ||
          index == animais.length - 1;
      if (shouldYield) {
        await Future<void>.delayed(Duration.zero);
      }
    }
    todasPesagens.sort((a, b) => a.data.compareTo(b.data));

    if (todasPesagens.isEmpty) {
      return _LoteGmdCalculationResult(
        pesagensValidas: const [],
        results: animais
            .map((animal) => _LoteGmdAnimalResult(
                  animal: animal,
                  motivoNaoCalculavel: 'Sem pesagens cadastradas',
                ))
            .toList(),
        dataInicial: null,
        dataFinal: null,
        periodoInvalido: false,
        resultsCalculaveisCount: 0,
      );
    }

    final dataInicial =
        _dateOnly(_model.gmdLoteDataInicial ?? todasPesagens.first.data);
    final dataFinal =
        _dateOnly(_model.gmdLoteDataFinal ?? todasPesagens.last.data);

    if (dataFinal.isBefore(dataInicial)) {
      return _LoteGmdCalculationResult(
        pesagensValidas: todasPesagens,
        results: const [],
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        periodoInvalido: true,
        resultsCalculaveisCount: 0,
      );
    }

    final results = <_LoteGmdAnimalResult>[];
    for (var index = 0; index < animais.length; index++) {
      final animal = animais[index];
      final idRebanho = _normalizeIdRebanho(animal.idRebanho);
      if (idRebanho.isEmpty) {
        results.add(_LoteGmdAnimalResult(
          animal: animal,
          motivoNaoCalculavel: 'Animal sem idRebanho',
        ));
      } else {
        final animalPesagens =
            (pontosPorAnimal[idRebanho] ?? const <_LoteGmdPesagem>[])
                .where((pesagem) =>
                    !pesagem.data.isBefore(dataInicial) &&
                    !pesagem.data.isAfter(dataFinal))
                .toList();

        if (animalPesagens.length < 2) {
          results.add(_LoteGmdAnimalResult(
            animal: animal,
            motivoNaoCalculavel: 'Menos de duas datas de pesagem no período',
          ));
        } else {
          final inicial = animalPesagens[animalPesagens.length - 2];
          final finalPesagem = animalPesagens.last;
          final diasAvaliados =
              finalPesagem.data.difference(inicial.data).inDays;

          if (diasAvaliados <= 0) {
            results.add(_LoteGmdAnimalResult(
              animal: animal,
              pesoInicial: inicial.peso,
              pesoFinal: finalPesagem.peso,
              dataInicial: inicial.data,
              dataFinal: finalPesagem.data,
              motivoNaoCalculavel: 'Pesagens na mesma data',
            ));
          } else {
            results.add(_LoteGmdAnimalResult(
              animal: animal,
              pesoInicial: inicial.peso,
              pesoFinal: finalPesagem.peso,
              dataInicial: inicial.data,
              dataFinal: finalPesagem.data,
              diasAvaliados: diasAvaliados,
              gmd: (finalPesagem.peso - inicial.peso) / diasAvaliados,
            ));
          }
        }
      }

      final shouldYield = (index + 1) % _gmdLoteCalculationBatchSize == 0 ||
          index == animais.length - 1;
      if (shouldYield) {
        if (mounted && _gmdLoteCalculationKey == calculationKey) {
          safeSetState(() {
            _gmdLoteProgressCurrent = index + 1;
            _gmdLoteProgressTotal = animais.length;
          });
        }
        await Future<void>.delayed(Duration.zero);
      }
    }

    final resultsCalculaveis = results.where((r) => r.calculavel).toList();
    return _LoteGmdCalculationResult(
      pesagensValidas: todasPesagens,
      results: results,
      dataInicial: dataInicial,
      dataFinal: dataFinal,
      periodoInvalido: false,
      resultsCalculaveisCount: resultsCalculaveis.length,
      gmdMedio: _average(resultsCalculaveis.map((r) => r.gmd)),
      pesoMedioInicial: _average(resultsCalculaveis.map((r) => r.pesoInicial)),
      pesoMedioFinal: _average(resultsCalculaveis.map((r) => r.pesoFinal)),
    );
  }

  void _invalidateGmdLoteCalculation({bool resetVisibleRows = true}) {
    _gmdLoteCalculationKey = null;
    _gmdLoteCalculationFuture = null;
    _gmdLoteProgressCurrent = 0;
    _gmdLoteProgressTotal = 0;
    if (resetVisibleRows) {
      _model.gmdLoteVisibleRows = _gmdLoteRowsPageSize;
    }
  }

  Future<_LoteGmdCalculationResult> _gmdLoteCalculationFor(
    List<RebanhoStruct> animais,
    List<BuscaHistPesagensRow> pesagens,
  ) {
    final key = _gmdLoteCalculationCacheKey(animais, pesagens);
    if (_gmdLoteCalculationKey != key || _gmdLoteCalculationFuture == null) {
      _gmdLoteCalculationKey = key;
      _gmdLoteProgressCurrent = 0;
      _gmdLoteProgressTotal = animais.length;
      _model.gmdLoteVisibleRows = _gmdLoteRowsPageSize;
      _gmdLoteCalculationFuture =
          _calculateGmdLoteAsync(animais, pesagens, key);
    }
    return _gmdLoteCalculationFuture!;
  }

  Future<void> _pickGmdLoteDate({
    required bool isStart,
    required List<_LoteGmdPesagem> pesagens,
  }) async {
    final datas = pesagens.map((p) => _dateOnly(p.data)).toList()..sort();
    final fallback = datas.isNotEmpty ? datas.first : getCurrentTimestamp;
    final current =
        isStart ? _model.gmdLoteDataInicial : _model.gmdLoteDataFinal;

    final picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate:
          current ?? (isStart || datas.isEmpty ? fallback : datas.last),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: FlutterFlowTheme.of(context).primary,
          headerForegroundColor: FlutterFlowTheme.of(context).info,
          headerTextStyle: FlutterFlowTheme.of(context).headlineLarge.override(
                fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                fontSize: 32.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).headlineLargeIsCustom,
              ),
          pickerBackgroundColor:
              FlutterFlowTheme.of(context).secondaryBackground,
          pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
          selectedDateTimeBackgroundColor: FlutterFlowTheme.of(context).primary,
          selectedDateTimeForegroundColor: FlutterFlowTheme.of(context).info,
          actionButtonForegroundColor: FlutterFlowTheme.of(context).primaryText,
          iconSize: 24.0,
        );
      },
    );

    if (picked == null) return;
    safeSetState(() {
      if (isStart) {
        _model.gmdLoteDataInicial = _dateOnly(picked);
      } else {
        _model.gmdLoteDataFinal = _dateOnly(picked);
      }
      _invalidateGmdLoteCalculation();
    });
  }

  Widget _buildGmdLoteDateFilter({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150.0, maxWidth: 260.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 56.0,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF8E8E8E),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Text(
                      _formatGmdLoteDate(value),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: value == null
                                ? const Color(0xFFBEBEBE)
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF181818),
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGmdLoteMetricCard({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x1F000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).accent3,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: valueColor ?? FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGmdLoteEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: FlutterFlowTheme.of(context).accent3, size: 36.0),
          const SizedBox(height: 12.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).accent3,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGmdLoteTableCell(
    String text, {
    required double width,
    bool isHeader = false,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        child: Text(
          text,
          maxLines: isHeader ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: color ??
                    (isHeader
                        ? FlutterFlowTheme.of(context).primaryText
                        : FlutterFlowTheme.of(context).secondaryText),
                fontSize: isHeader ? 13.0 : 14.0,
                letterSpacing: 0.0,
                fontWeight: fontWeight ??
                    (isHeader ? FontWeight.w700 : FontWeight.w500),
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
        ),
      ),
    );
  }

  Widget _buildGmdLoteAnimalValues(List<_LoteGmdAnimalResult> results) {
    final visibleCount = _model.gmdLoteVisibleRows < results.length
        ? _model.gmdLoteVisibleRows
        : results.length;
    final visibleResults = results.take(visibleCount).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valores por animal',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Cada linha usa as duas últimas datas de pesagem válidas do animal dentro do período.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).accent3,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1080.0,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F7F8),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEDEDED)),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildGmdLoteTableCell('Animal',
                            width: 160.0, isHeader: true),
                        _buildGmdLoteTableCell('Data inicial',
                            width: 120.0, isHeader: true),
                        _buildGmdLoteTableCell('Peso inicial',
                            width: 130.0, isHeader: true),
                        _buildGmdLoteTableCell('Data final',
                            width: 120.0, isHeader: true),
                        _buildGmdLoteTableCell('Peso final',
                            width: 130.0, isHeader: true),
                        _buildGmdLoteTableCell('Dias',
                            width: 80.0, isHeader: true),
                        _buildGmdLoteTableCell('GMD',
                            width: 140.0, isHeader: true),
                        _buildGmdLoteTableCell('Status',
                            width: 200.0, isHeader: true),
                      ],
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleResults.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    itemBuilder: (context, index) {
                      final result = visibleResults[index];
                      return Row(
                        children: [
                          _buildGmdLoteTableCell(
                            _animalGmdLabel(result.animal),
                            width: 160.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                          _buildGmdLoteTableCell(
                              _formatGmdLoteDate(result.dataInicial),
                              width: 120.0),
                          _buildGmdLoteTableCell(_formatKg(result.pesoInicial),
                              width: 130.0),
                          _buildGmdLoteTableCell(
                              _formatGmdLoteDate(result.dataFinal),
                              width: 120.0),
                          _buildGmdLoteTableCell(_formatKg(result.pesoFinal),
                              width: 130.0),
                          _buildGmdLoteTableCell(
                              result.diasAvaliados?.toString() ?? '-',
                              width: 80.0),
                          _buildGmdLoteTableCell(
                            _formatKgDia(result.gmd),
                            width: 140.0,
                            color: _gmdLoteColor(result.gmd),
                            fontWeight: FontWeight.w700,
                          ),
                          _buildGmdLoteTableCell(
                            result.calculavel
                                ? 'Calculado'
                                : result.motivoNaoCalculavel ??
                                    'Não calculável',
                            width: 200.0,
                            color: result.calculavel
                                ? FlutterFlowTheme.of(context).success
                                : FlutterFlowTheme.of(context).accent3,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (visibleCount < results.length) ...[
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  safeSetState(() {
                    _model.gmdLoteVisibleRows += _gmdLoteRowsPageSize;
                  });
                },
                child: Text(
                  'Carregar mais (${results.length - visibleCount} restantes)',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGmdLoteContent({
    required _LoteGmdCalculationResult calculation,
  }) {
    final pesagensValidas = calculation.pesagensValidas;
    final dataInicial = calculation.dataInicial;
    final dataFinal = calculation.dataFinal;
    final periodoInvalido = calculation.periodoInvalido;
    final results = calculation.results;

    final content = <Widget>[
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GMD do lote',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Média dos GMDs individuais calculados com as duas últimas datas de pesagem válidas de cada animal no período.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).accent3,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildGmdLoteDateFilter(
                  label: 'Data inicial',
                  value: dataInicial,
                  onTap: () => _pickGmdLoteDate(
                    isStart: true,
                    pesagens: pesagensValidas,
                  ),
                ),
                _buildGmdLoteDateFilter(
                  label: 'Data final',
                  value: dataFinal,
                  onTap: () => _pickGmdLoteDate(
                    isStart: false,
                    pesagens: pesagensValidas,
                  ),
                ),
                if (_model.gmdLoteDataInicial != null ||
                    _model.gmdLoteDataFinal != null)
                  TextButton(
                    onPressed: () {
                      safeSetState(() {
                        _model.gmdLoteDataInicial = null;
                        _model.gmdLoteDataFinal = null;
                        _invalidateGmdLoteCalculation();
                      });
                    },
                    child: const Text('Limpar filtros'),
                  ),
              ],
            ),
          ],
        ),
      ),
    ];

    if (pesagensValidas.isEmpty) {
      content.add(_buildGmdLoteEmptyState(
        icon: Icons.monitor_weight_outlined,
        title: 'Nenhuma pesagem encontrada',
        description:
            'Cadastre pelo menos duas pesagens para os animais deste lote para calcular o GMD.',
      ));
    } else if (periodoInvalido) {
      content.add(_buildGmdLoteEmptyState(
        icon: Icons.date_range_outlined,
        title: 'Período inválido',
        description:
            'A data final precisa ser igual ou posterior à data inicial.',
      ));
    } else if (results.isEmpty) {
      content.add(_buildGmdLoteEmptyState(
        icon: Icons.table_chart_outlined,
        title: 'Sem animais avaliáveis no período',
        description:
            'Cada animal precisa ter pelo menos duas datas de pesagem válidas no período.',
      ));
    } else {
      content.addAll([
        Text(
          'Resumo do lote',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
        ),
        _buildGmdLoteMetricCard(
          label: 'Número de animais avaliados',
          value: results.length.toString(),
        ),
        _buildGmdLoteMetricCard(
          label: 'Com GMD calculado',
          value: calculation.resultsCalculaveisCount.toString(),
        ),
        _buildGmdLoteMetricCard(
          label: 'GMD médio (kg/dia)',
          value: _formatKgDia(calculation.gmdMedio),
          valueColor: _gmdLoteColor(calculation.gmdMedio),
        ),
        _buildGmdLoteMetricCard(
          label: 'Peso médio inicial',
          value: _formatKg(calculation.pesoMedioInicial),
        ),
        _buildGmdLoteMetricCard(
          label: 'Peso médio final',
          value: _formatKg(calculation.pesoMedioFinal),
        ),
        _buildGmdLoteAnimalValues(results),
      ]);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .expand((widget) => [widget, const SizedBox(height: 24.0)])
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }

  Widget _buildGmdLoteProgressState(List<RebanhoStruct> animais) {
    final total =
        _gmdLoteProgressTotal > 0 ? _gmdLoteProgressTotal : animais.length;
    final current =
        _gmdLoteProgressCurrent > total ? total : _gmdLoteProgressCurrent;
    final progress = total > 0 ? current / total : null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 42.0,
                height: 42.0,
                child: CircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                total > 0
                    ? 'Calculando GMD: $current/$total animais'
                    : 'Preparando cálculo do GMD...',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'A tela continuará responsiva enquanto o lote grande é processado em blocos.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).accent3,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGmdLoteTab(List<RebanhoStruct> animais) {
    if (animais.isEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildGmdLoteEmptyState(
            icon: Icons.groups_outlined,
            title: 'Nenhum animal no lote',
            description:
                'Adicione animais ao lote para acompanhar o ganho médio diário.',
          ),
        ),
      );
    }

    final animaisKey = _gmdLoteAnimaisKey(animais);
    if (_model.gmdLoteAnimaisKey != animaisKey) {
      _model.gmdLoteAnimaisKey = animaisKey;
      _model.gmdLotePesagensCompleter = null;
      _invalidateGmdLoteCalculation();
    }

    return FutureBuilder<List<BuscaHistPesagensRow>>(
      future: (_model.gmdLotePesagensCompleter ??=
              Completer<List<BuscaHistPesagensRow>>()
                ..complete(_loadPesagensDoLote(animais)))
          .future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        return FutureBuilder<_LoteGmdCalculationResult>(
          future: _gmdLoteCalculationFor(animais, snapshot.data!),
          builder: (context, calculationSnapshot) {
            if (calculationSnapshot.hasError) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildGmdLoteEmptyState(
                    icon: Icons.error_outline,
                    title: 'Não foi possível calcular o GMD',
                    description: calculationSnapshot.error.toString(),
                  ),
                ),
              );
            }
            if (!calculationSnapshot.hasData) {
              return _buildGmdLoteProgressState(animais);
            }

            return _buildGmdLoteContent(
              calculation: calculationSnapshot.data!,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<List<BuscarLoteRow>>(
      future: SQLiteManager.instance.buscarLote(
        idLote: widget.idLote,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        final containerBuscarLoteRowList = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().rebanhosLote = [];
                            safeSetState(() {});
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 26.0,
                          ),
                        ),
                        Text(
                          'Lotes',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: const Color(0xFF232908),
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ].divide(const SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lote',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: const Color(0xFF8E8E8E),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          containerBuscarLoteRowList.firstOrNull?.nome,
                          'Nome',
                        ),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: const Color(0xFF181818),
                              fontSize: 24.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(0.0, 0),
                        child: TabBar(
                          labelColor: const Color(0xFF1E7A4C),
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                lineHeight: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleMediumIsCustom,
                              ),
                          unselectedLabelStyle: const TextStyle(),
                          indicatorColor: const Color(0xFF1E7A4C),
                          tabs: const [
                            Tab(
                              text: 'Informações',
                            ),
                            Tab(
                              text: 'Animais',
                            ),
                            Tab(
                              text: 'GMD',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, -1.0),
                                                child: Text(
                                                  'Nome do lote*',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: const Color(
                                                            0xFF2F2F2F),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: _model
                                                        .inputLoginTextController1 ??=
                                                    TextEditingController(
                                                  text:
                                                      containerBuscarLoteRowList
                                                          .firstOrNull?.nome,
                                                ),
                                                focusNode:
                                                    _model.inputLoginFocusNode1,
                                                autofocus: false,
                                                readOnly: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  hintText: 'Nome do lote',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: const Color(
                                                            0xFFBEBEBE),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0x0028A365),
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  filled: true,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: const Color(
                                                          0xFF474747),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                cursorColor:
                                                    const Color(0xFF28A365),
                                                validator: _model
                                                    .inputLoginTextController1Validator
                                                    .asValidator(context),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -1.0, -1.0),
                                                  child: Text(
                                                    'Anotações',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: const Color(
                                                              0xFF2F2F2F),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: _model
                                                          .inputLoginTextController2 ??=
                                                      TextEditingController(
                                                    text:
                                                        valueOrDefault<String>(
                                                      valueOrDefault<String>(
                                                                containerBuscarLoteRowList
                                                                    .firstOrNull
                                                                    ?.anotacoes,
                                                                'Sem anotações.',
                                                              ) ==
                                                              'null'
                                                          ? 'Sem anotações.'
                                                          : valueOrDefault<
                                                              String>(
                                                              containerBuscarLoteRowList
                                                                  .firstOrNull
                                                                  ?.anotacoes,
                                                              'Sem anotações.',
                                                            ),
                                                      'Sem anotações.',
                                                    ),
                                                  ),
                                                  focusNode: _model
                                                      .inputLoginFocusNode2,
                                                  autofocus: false,
                                                  readOnly: true,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: 'Escreva algo...',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0x0028A365),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    errorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    filled: true,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: const Color(
                                                            0xFF474747),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  maxLines: 5,
                                                  cursorColor:
                                                      const Color(0xFF28A365),
                                                  validator: _model
                                                      .inputLoginTextController2Validator
                                                      .asValidator(context),
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x41000000),
                                                  offset: Offset(
                                                    2.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(6.0),
                                                bottomRight:
                                                    Radius.circular(6.0),
                                                topLeft: Radius.circular(6.0),
                                                topRight: Radius.circular(6.0),
                                              ),
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Este lote está ativo?',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFF474747),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  Switch.adaptive(
                                                    value: _model
                                                            .switchValue ??=
                                                        containerBuscarLoteRowList
                                                                    .firstOrNull
                                                                    ?.ativo ==
                                                                'Ativo'
                                                            ? true
                                                            : false,
                                                    onChanged:
                                                        (newValue) async {
                                                      safeSetState(() =>
                                                          _model.switchValue =
                                                              newValue);
                                                    },
                                                    activeColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    activeTrackColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    inactiveTrackColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    inactiveThumbColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (containerBuscarLoteRowList
                                                .firstOrNull?.ativo ==
                                            'Inativo')
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 150.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Motivo',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF1F1F1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalTextController1 ??=
                                                                              TextEditingController(
                                                                        text: valueOrDefault<
                                                                            String>(
                                                                          containerBuscarLoteRowList.firstOrNull?.motivo == 'null'
                                                                              ? 'N/A'
                                                                              : containerBuscarLoteRowList.firstOrNull?.motivo,
                                                                          'N/A',
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalFocusNode1,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Motivo',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: const Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalTextController1Validator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Data',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF1F1F1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalTextController2 ??=
                                                                              TextEditingController(
                                                                        text:
                                                                            dateTimeFormat(
                                                                          "d/M/y",
                                                                          functions.converterParaData(containerBuscarLoteRowList
                                                                              .firstOrNull
                                                                              ?.dataMotivo),
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalFocusNode2,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Peso desmama',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: const Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalTextController2Validator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 24.0)),
                                            ),
                                          ),
                                        if (containerBuscarLoteRowList
                                                .firstOrNull?.ativo ==
                                            'Inativo')
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Valor venda',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: const Color(
                                                                0xFF474747),
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFF1F1F1),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(6.0),
                                                      bottomRight:
                                                          Radius.circular(6.0),
                                                      topLeft:
                                                          Radius.circular(6.0),
                                                      topRight:
                                                          Radius.circular(6.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                TextFormField(
                                                              controller: _model
                                                                      .nAnimalTextController3 ??=
                                                                  TextEditingController(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  formatNumber(
                                                                    containerBuscarLoteRowList
                                                                        .firstOrNull
                                                                        ?.valorVenda,
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        'R\$ ',
                                                                  ),
                                                                  'R\$ 0,00',
                                                                ),
                                                              ),
                                                              focusNode: _model
                                                                  .nAnimalFocusNode3,
                                                              autofocus: true,
                                                              readOnly: true,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  formatNumber(
                                                                    containerBuscarLoteRowList
                                                                        .firstOrNull
                                                                        ?.valorVenda,
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        'R\$ ',
                                                                  ),
                                                                  'R\$ 0,00',
                                                                ),
                                                                hintStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: const Color(
                                                                          0xFFBEBEBE),
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color(
                                                                        0x00E0E3E7),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color(
                                                                        0x004B39EF),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                errorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedErrorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                              validator: _model
                                                                  .nAnimalTextController3Validator
                                                                  .asValidator(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x40000000),
                                                  offset: Offset(
                                                    2.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(6.0),
                                                bottomRight:
                                                    Radius.circular(6.0),
                                                topLeft: Radius.circular(6.0),
                                                topRight: Radius.circular(6.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 24.0, 24.0, 24.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 24.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'Animais neste lote (${valueOrDefault<String>(
                                                                    FFAppState()
                                                                        .rebanhosLote
                                                                        .length
                                                                        .toString(),
                                                                    '0',
                                                                  )})',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: const Color(
                                                                            0xFF474747),
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              if (responsiveVisibility(
                                                                context:
                                                                    context,
                                                                phone: false,
                                                                tablet: false,
                                                                tabletLandscape:
                                                                    false,
                                                                desktop: false,
                                                              ))
                                                                Text(
                                                                  'Ver todos',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: const Color(
                                                                            0xFF1E7A4C),
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                            ],
                                                          ),
                                                          Text(
                                                            'Mostrando os primeiros 5 da lista',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (!(FFAppState()
                                                      .rebanhosLote
                                                      .isNotEmpty))
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/images/Rebanho.svg',
                                                                width: 77.0,
                                                                height: 58.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Nenhum animal foi adicionado',
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    lineHeight:
                                                                        1.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  if (FFAppState()
                                                      .rebanhosLote
                                                      .isNotEmpty)
                                                    Builder(
                                                      builder: (context) {
                                                        final rebanho =
                                                            FFAppState()
                                                                .rebanhosLote
                                                                .take(5)
                                                                .toList();

                                                        return ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              rebanho.length,
                                                          itemBuilder: (context,
                                                              rebanhoIndex) {
                                                            final rebanhoItem =
                                                                rebanho[
                                                                    rebanhoIndex];
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      await _openRebanhoDialog(
                                                                          rebanhoItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children:
                                                                            [
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/Group_11_3_(1).png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.scaleDown,
                                                                                      ),
                                                                                    ),
                                                                                    if (rebanhoItem.sexo == 'Macho')
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                        child: Image.asset(
                                                                                          'assets/images/Sexomacho.png',
                                                                                          width: 24.0,
                                                                                          height: 24.0,
                                                                                          fit: BoxFit.scaleDown,
                                                                                        ),
                                                                                      ),
                                                                                    if (rebanhoItem.sexo == 'Fêmea')
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                        child: Image.asset(
                                                                                          'assets/images/Sexofemea.png',
                                                                                          width: 24.0,
                                                                                          height: 24.0,
                                                                                          fit: BoxFit.scaleDown,
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${valueOrDefault<String>(
                                                                                        rebanhoItem.numeroAnimal,
                                                                                        'numero',
                                                                                      )} • ${valueOrDefault<String>(
                                                                                        () {
                                                                                          if (valueOrDefault<String>(
                                                                                                rebanhoItem.nome,
                                                                                                'nome',
                                                                                              ) ==
                                                                                              'null') {
                                                                                            return 'S/N';
                                                                                          } else if (valueOrDefault<String>(
                                                                                                rebanhoItem.nome,
                                                                                                'nome',
                                                                                              ) ==
                                                                                              '') {
                                                                                            return 'S/N';
                                                                                          } else {
                                                                                            return valueOrDefault<String>(
                                                                                              rebanhoItem.nome,
                                                                                              'nome',
                                                                                            );
                                                                                          }
                                                                                        }(),
                                                                                        'S/N',
                                                                                      )} • ${dateTimeFormat(
                                                                                        "d/M/y",
                                                                                        functions.converterParaData(rebanhoItem.dataNascimento),
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      )}',
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 4.0)),
                                                                                ),
                                                                              ),
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        rebanhoItem.categoria,
                                                                                        'Sem categoria',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      '•',
                                                                                      maxLines: 1,
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      () {
                                                                                        if (valueOrDefault<String>(
                                                                                              rebanhoItem.raca,
                                                                                              'Sem raça',
                                                                                            ) ==
                                                                                            ' ') {
                                                                                          return 'Sem raça';
                                                                                        } else if (valueOrDefault<String>(
                                                                                              rebanhoItem.raca,
                                                                                              'Sem raça',
                                                                                            ) ==
                                                                                            '') {
                                                                                          return 'Sem raça';
                                                                                        } else if (valueOrDefault<String>(
                                                                                              rebanhoItem.raca,
                                                                                              'Sem raça',
                                                                                            ) ==
                                                                                            'null') {
                                                                                          return 'Sem raça';
                                                                                        } else {
                                                                                          return valueOrDefault<String>(
                                                                                            rebanhoItem.raca,
                                                                                            'Sem raça',
                                                                                          );
                                                                                        }
                                                                                      }(),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 4.0)),
                                                                                ),
                                                                              ),
                                                                            ].divide(const SizedBox(height: 8.0)),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 8.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFEDEDED),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 25.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        FFAppState()
                                                            .rebanhosLote = [];
                                                        safeSetState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      text: 'Cancelar',
                                                      options: FFButtonOptions(
                                                        width: 156.0,
                                                        height: 56.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(24.0,
                                                                0.0, 24.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color: const Color(
                                                            0x004B39EF),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: const Color(
                                                                      0xFF1E7A4C),
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF1E7A4C),
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        safeSetState(() {
                                                          _model
                                                              .tabBarController!
                                                              .animateTo(
                                                            min(
                                                                _model.tabBarController!
                                                                        .length -
                                                                    1,
                                                                _model.tabBarController!
                                                                        .index +
                                                                    1),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            curve: Curves.ease,
                                                          );
                                                        });
                                                      },
                                                      text: 'Próximo',
                                                      options: FFButtonOptions(
                                                        width: 156.0,
                                                        height: 56.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(24.0,
                                                                0.0, 24.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color: const Color(
                                                            0xFF28A365),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(const SizedBox(
                                                    width: 16.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 24.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 24.0, 0.0, 30.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6.0),
                                                  bottomRight:
                                                      Radius.circular(6.0),
                                                  topLeft: Radius.circular(6.0),
                                                  topRight:
                                                      Radius.circular(6.0),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Animais no lote (${valueOrDefault<String>(
                                                              FFAppState()
                                                                  .rebanhosLote
                                                                  .length
                                                                  .toString(),
                                                              '0',
                                                            )})',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF474747),
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                        if (responsiveVisibility(
                                                          context: context,
                                                          phone: false,
                                                          tablet: false,
                                                          tabletLandscape:
                                                              false,
                                                          desktop: false,
                                                        ))
                                                          Text(
                                                            'Ver todos',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF1E7A4C),
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              24.0, 0.0, 0.0),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller: _model
                                                              .textController6,
                                                          focusNode: _model
                                                              .textFieldFocusNode,
                                                          onChanged: (_) =>
                                                              EasyDebounce
                                                                  .debounce(
                                                            '_model.textController6',
                                                            const Duration(
                                                                milliseconds:
                                                                    2000),
                                                            () async {
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                          ),
                                                          autofocus: false,
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                            hintText:
                                                                'Pesquisar',
                                                            hintStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .labelMediumIsCustom,
                                                                    ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFBEBEBE),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .accent4,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                            filled: true,
                                                            fillColor: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .search_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 24.0,
                                                            ),
                                                            suffixIcon: _model
                                                                    .textController6!
                                                                    .text
                                                                    .isNotEmpty
                                                                ? InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      _model
                                                                          .textController6
                                                                          ?.clear();
                                                                      safeSetState(
                                                                          () {});
                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent3,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  )
                                                                : null,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                          cursorColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          validator: _model
                                                              .textController6Validator
                                                              .asValidator(
                                                                  context),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (FFAppState()
                                                      .rebanhosLote
                                                      .isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              12.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final rebanho = FFAppState()
                                                                .rebanhosLote
                                                                .where((e) =>
                                                                    (_model.textController6
                                                                            .text ==
                                                                        '') ||
                                                                    ((_model.textController6.text ==
                                                                            '') ||
                                                                        ((e.nome).toLowerCase().contains(_model
                                                                            .textController6
                                                                            .text
                                                                            .toLowerCase())) ||
                                                                        ((e.numeroAnimal).toLowerCase().contains(_model
                                                                            .textController6
                                                                            .text
                                                                            .toLowerCase())) ||
                                                                        ((e.chip)
                                                                            .toLowerCase()
                                                                            .contains(_model.textController6.text.toLowerCase()))))
                                                                .toList()
                                                                .take(_model.mostrarAnimais)
                                                                .toList();

                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: List.generate(
                                                                      rebanho
                                                                          .length,
                                                                      (rebanhoIndex) {
                                                                final rebanhoItem =
                                                                    rebanho[
                                                                        rebanhoIndex];
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          await _openRebanhoDialog(
                                                                              rebanhoItem.idRebanho);
                                                                        },
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children:
                                                                                [
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                          child: Image.asset(
                                                                                            'assets/images/Group_11_3_(1).png',
                                                                                            width: 24.0,
                                                                                            height: 24.0,
                                                                                            fit: BoxFit.scaleDown,
                                                                                          ),
                                                                                        ),
                                                                                        if (rebanhoItem.sexo == 'Macho')
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexomacho.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                        if (rebanhoItem.sexo == 'Fêmea')
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexofemea.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${valueOrDefault<String>(
                                                                                            rebanhoItem.numeroAnimal,
                                                                                            'numero',
                                                                                          )} • ${valueOrDefault<String>(
                                                                                            () {
                                                                                              if (valueOrDefault<String>(
                                                                                                    rebanhoItem.nome,
                                                                                                    'nome',
                                                                                                  ) ==
                                                                                                  'null') {
                                                                                                return 'S/N';
                                                                                              } else if (valueOrDefault<String>(
                                                                                                    rebanhoItem.nome,
                                                                                                    'nome',
                                                                                                  ) ==
                                                                                                  '') {
                                                                                                return 'S/N';
                                                                                              } else {
                                                                                                return valueOrDefault<String>(
                                                                                                  rebanhoItem.nome,
                                                                                                  'nome',
                                                                                                );
                                                                                              }
                                                                                            }(),
                                                                                            'S/N',
                                                                                          )} • ${dateTimeFormat(
                                                                                            "d/M/y",
                                                                                            functions.converterParaData(rebanhoItem.dataNascimento),
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          )}',
                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                font: GoogleFonts.plusJakartaSans(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                                color: const Color(0xFF474747),
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(const SizedBox(width: 4.0)),
                                                                                    ),
                                                                                  ),
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            rebanhoItem.categoria,
                                                                                            'Sem categoria',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                font: GoogleFonts.plusJakartaSans(
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                                color: const Color(0xFF5F5F5F),
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          '•',
                                                                                          maxLines: 1,
                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                font: GoogleFonts.plusJakartaSans(
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                                color: const Color(0xFF474747),
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            () {
                                                                                              if (rebanhoItem.raca == ' ') {
                                                                                                return 'Sem raça';
                                                                                              } else if (rebanhoItem.raca == '') {
                                                                                                return 'Sem raça';
                                                                                              } else if (rebanhoItem.raca == 'null') {
                                                                                                return 'Sem raça';
                                                                                              } else {
                                                                                                return rebanhoItem.raca;
                                                                                              }
                                                                                            }(),
                                                                                            'Sem raça',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                font: GoogleFonts.plusJakartaSans(
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                                color: const Color(0xFF5F5F5F),
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(const SizedBox(width: 4.0)),
                                                                                    ),
                                                                                  ),
                                                                                ].divide(const SizedBox(height: 8.0)),
                                                                              ),
                                                                            ].divide(const SizedBox(width: 8.0)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          1.0,
                                                                      color: Color(
                                                                          0xFFEDEDED),
                                                                    ),
                                                                  ],
                                                                );
                                                              })
                                                                  .divide(const SizedBox(
                                                                      height:
                                                                          10.0))
                                                                  .around(const SizedBox(
                                                                      height:
                                                                          10.0)),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  if (!(FFAppState()
                                                      .rebanhosLote
                                                      .isNotEmpty))
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              48.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/images/Rebanho.svg',
                                                                  width: 77.0,
                                                                  height: 58.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Nenhum animal foi adicionado',
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      lineHeight:
                                                                          1.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              if (_model.mostrarAnimais > 5)
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.mostrarAnimais =
                                                        _model.mostrarAnimais +
                                                            -5;
                                                    safeSetState(() {});
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Mostrar menos',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(
                                                        Icons.keyboard_arrow_up,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              if (_model.mostrarAnimais <
                                                  FFAppState()
                                                      .rebanhosLote
                                                      .length)
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.mostrarAnimais =
                                                        _model.mostrarAnimais +
                                                            5;
                                                    safeSetState(() {});
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Mostrar mais',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: Color(0xFFEDEDED),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Unidade Animal (UA)',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          (double.parse((functions.soma(FFAppState()
                                                                          .rebanhosLote
                                                                          .map((e) => e
                                                                              .pesoAtual)
                                                                          .toList()) /
                                                                      450)
                                                                  .toStringAsFixed(
                                                                      2)))
                                                              .toString(),
                                                          '0',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Peso médio (kg)',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          functions
                                                              .pesoMedio(FFAppState()
                                                                  .rebanhosLote
                                                                  .map((e) => e
                                                                      .pesoAtual)
                                                                  .toList())
                                                              .toString(),
                                                          '0',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: Color(0xFFEDEDED),
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 16.0)),
                                            ),
                                          ),
                                          _buildLoteCategoriaResumo(
                                              FFAppState().rebanhosLote),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                24.0, 0.0, 24.0, 24.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: FFButtonWidget(
                                                    onPressed: () async {
                                                      safeSetState(() {
                                                        _model.tabBarController!
                                                            .animateTo(
                                                          max(
                                                              0,
                                                              _model.tabBarController!
                                                                      .index -
                                                                  1),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.ease,
                                                        );
                                                      });
                                                    },
                                                    text: 'Voltar',
                                                    options: FFButtonOptions(
                                                      width: 156.0,
                                                      height: 56.0,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              0.0, 24.0, 0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      color: const Color(
                                                          0x004B39EF),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmallFamily,
                                                                color: const Color(
                                                                    0xFF1E7A4C),
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmallIsCustom,
                                                              ),
                                                      elevation: 0.0,
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF1E7A4C),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Builder(
                                                    builder: (context) =>
                                                        FFButtonWidget(
                                                      onPressed: () async {
                                                        final navigator =
                                                            Navigator.of(
                                                                context);
                                                        navigator.pop();
                                                        await Future.delayed(
                                                            Duration.zero);
                                                        await showDialog(
                                                          barrierColor: Colors
                                                              .transparent,
                                                          barrierDismissible:
                                                              false,
                                                          context:
                                                              navigator.context,
                                                          builder:
                                                              (dialogContext) {
                                                            return Dialog(
                                                              elevation: 0,
                                                              insetPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              alignment: const AlignmentDirectional(
                                                                      0.0, 0.0)
                                                                  .resolve(Directionality
                                                                      .of(navigator
                                                                          .context)),
                                                              child:
                                                                  EditLoteWidget(
                                                                idLote: widget
                                                                    .idLote!,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      text: 'Editar',
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 24.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: 156.0,
                                                        height: 56.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(24.0,
                                                                0.0, 24.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color: const Color(
                                                            0xFF28A365),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 16.0)),
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildGmdLoteTab(FFAppState().rebanhosLote),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ].divide(const SizedBox(height: 24.0)),
          ),
        );
      },
    );
  }
}
