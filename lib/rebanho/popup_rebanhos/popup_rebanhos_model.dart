import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'popup_rebanhos_widget.dart' show PopupRebanhosWidget;
import 'package:flutter/material.dart';

class PopupRebanhosModel extends FlutterFlowModel<PopupRebanhosWidget> {
  ///  Local state fields for this component.

  int? limit = 10;

  int offset = 0;

  /// Cached Future para evitar re-queries em cada rebuild do FutureBuilder.
  Future<List<BuscaRebanhoPopupRow>>? buscaRebanhoFuture;

  /// Parâmetros da última busca (para detectar mudanças).
  String _lastPesquisa = '';
  String? _lastIdPropriedade;
  String? _lastSexo;
  String? _lastStatusRebanho;
  String? _lastCategoria;
  String? _lastCategoriaExcluir;
  String? _lastExcludeIdRebanho;

  /// Atualiza a busca somente se os parâmetros mudaram.
  Future<List<BuscaRebanhoPopupRow>> getBuscaRebanhoFuture({
    required String? idPropriedade,
    required String pesquisa,
    String? sexo,
    String? statusRebanho,
    String? categoria,
    String? categoriaExcluir,
    String? excludeIdRebanho,
  }) {
    if (buscaRebanhoFuture == null ||
        pesquisa != _lastPesquisa ||
        idPropriedade != _lastIdPropriedade ||
        sexo != _lastSexo ||
        statusRebanho != _lastStatusRebanho ||
        categoria != _lastCategoria ||
        categoriaExcluir != _lastCategoriaExcluir ||
        excludeIdRebanho != _lastExcludeIdRebanho) {
      _lastPesquisa = pesquisa;
      _lastIdPropriedade = idPropriedade;
      _lastSexo = sexo;
      _lastStatusRebanho = statusRebanho;
      _lastCategoria = categoria;
      _lastCategoriaExcluir = categoriaExcluir;
      _lastExcludeIdRebanho = excludeIdRebanho;
      buscaRebanhoFuture = SQLiteManager.instance.buscaRebanhoPopup(
        idPropriedade: idPropriedade,
        pesquisa: pesquisa,
        sexo: sexo,
        statusRebanho: statusRebanho,
        categoria: categoria,
        categoriaExcluir: categoriaExcluir,
        excludeIdRebanho: excludeIdRebanho,
      );
    }
    return buscaRebanhoFuture!;
  }

  /// Invalida o cache para forçar nova busca no próximo build.
  void invalidateBuscaCache() {
    buscaRebanhoFuture = null;
  }

  ///  State fields for stateful widgets in this component.

  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode1;
  TextEditingController? pesquisarTextController1;
  String? Function(BuildContext, String?)? pesquisarTextController1Validator;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode2;
  TextEditingController? pesquisarTextController2;
  String? Function(BuildContext, String?)? pesquisarTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pesquisarFocusNode1?.dispose();
    pesquisarTextController1?.dispose();

    pesquisarFocusNode2?.dispose();
    pesquisarTextController2?.dispose();
  }
}
