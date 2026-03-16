import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_lote_widget.dart' show AddLoteWidget;
import 'package:flutter/material.dart';

class AddLoteModel extends FlutterFlowModel<AddLoteWidget> {
  ///  Local state fields for this component.

  List<BuscaRebanhoPaginadaPesquisaRow> rebanhosSelecionados = [];
  void addToRebanhosSelecionados(BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosSelecionados.add(item);
  void removeFromRebanhosSelecionados(BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosSelecionados.remove(item);
  void removeAtIndexFromRebanhosSelecionados(int index) =>
      rebanhosSelecionados.removeAt(index);
  void insertAtIndexInRebanhosSelecionados(
          int index, BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosSelecionados.insert(index, item);
  void updateRebanhosSelecionadosAtIndex(
          int index, Function(BuscaRebanhoPaginadaPesquisaRow) updateFn) =>
      rebanhosSelecionados[index] = updateFn(rebanhosSelecionados[index]);

  List<BuscaRebanhoPaginadaPesquisaRow> rebanhosAplicados = [];
  void addToRebanhosAplicados(BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosAplicados.add(item);
  void removeFromRebanhosAplicados(BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosAplicados.remove(item);
  void removeAtIndexFromRebanhosAplicados(int index) =>
      rebanhosAplicados.removeAt(index);
  void insertAtIndexInRebanhosAplicados(
          int index, BuscaRebanhoPaginadaPesquisaRow item) =>
      rebanhosAplicados.insert(index, item);
  void updateRebanhosAplicadosAtIndex(
          int index, Function(BuscaRebanhoPaginadaPesquisaRow) updateFn) =>
      rebanhosAplicados[index] = updateFn(rebanhosAplicados[index]);

  List<String> lotesRemover = [];
  void addToLotesRemover(String item) => lotesRemover.add(item);
  void removeFromLotesRemover(String item) => lotesRemover.remove(item);
  void removeAtIndexFromLotesRemover(int index) => lotesRemover.removeAt(index);
  void insertAtIndexInLotesRemover(int index, String item) =>
      lotesRemover.insert(index, item);
  void updateLotesRemoverAtIndex(int index, Function(String) updateFn) =>
      lotesRemover[index] = updateFn(lotesRemover[index]);

  String? idLote;

  int index = 0;

  List<String> rebanhoIdSelecionados = [];
  void addToRebanhoIdSelecionados(String item) =>
      rebanhoIdSelecionados.add(item);
  void removeFromRebanhoIdSelecionados(String item) =>
      rebanhoIdSelecionados.remove(item);
  void removeAtIndexFromRebanhoIdSelecionados(int index) =>
      rebanhoIdSelecionados.removeAt(index);
  void insertAtIndexInRebanhoIdSelecionados(int index, String item) =>
      rebanhoIdSelecionados.insert(index, item);
  void updateRebanhoIdSelecionadosAtIndex(
          int index, Function(String) updateFn) =>
      rebanhoIdSelecionados[index] = updateFn(rebanhoIdSelecionados[index]);

  List<String> rebanhoIAplicados = [];
  void addToRebanhoIAplicados(String item) => rebanhoIAplicados.add(item);
  void removeFromRebanhoIAplicados(String item) =>
      rebanhoIAplicados.remove(item);
  void removeAtIndexFromRebanhoIAplicados(int index) =>
      rebanhoIAplicados.removeAt(index);
  void insertAtIndexInRebanhoIAplicados(int index, String item) =>
      rebanhoIAplicados.insert(index, item);
  void updateRebanhoIAplicadosAtIndex(int index, Function(String) updateFn) =>
      rebanhoIAplicados[index] = updateFn(rebanhoIAplicados[index]);

  int limit = 5;

  int offset = 0;

  int pageNum = 1;

  int mostrarAdicionados = 5;

  List<String> idAnimais = [];
  void addToIdAnimais(String item) => idAnimais.add(item);
  void removeFromIdAnimais(String item) => idAnimais.remove(item);
  void removeAtIndexFromIdAnimais(int index) => idAnimais.removeAt(index);
  void insertAtIndexInIdAnimais(int index, String item) =>
      idAnimais.insert(index, item);
  void updateIdAnimaisAtIndex(int index, Function(String) updateFn) =>
      idAnimais[index] = updateFn(idAnimais[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Nomelote widget.
  FocusNode? nomeloteFocusNode;
  TextEditingController? nomeloteTextController;
  String? Function(BuildContext, String?)? nomeloteTextControllerValidator;
  // State field(s) for Anotacoes widget.
  FocusNode? anotacoesFocusNode;
  TextEditingController? anotacoesTextController;
  String? Function(BuildContext, String?)? anotacoesTextControllerValidator;
  // State field(s) for Ativo_inativo widget.
  bool? ativoInativoValue;
  // State field(s) for DropDownMotivo widget.
  String? dropDownMotivoValue;
  FormFieldController<String>? dropDownMotivoValueController;
  DateTime? datePicked;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  Map<BuscaRebanhoPaginadaPesquisaRow, bool> checkboxValueMap2 = {};
  List<BuscaRebanhoPaginadaPesquisaRow> get checkboxCheckedItems2 =>
      checkboxValueMap2.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue3;
  // State field(s) for Checkbox widget.
  Map<BuscaRebanhoPaginadaPesquisaRow, bool> checkboxValueMap4 = {};
  List<BuscaRebanhoPaginadaPesquisaRow> get checkboxCheckedItems4 =>
      checkboxValueMap4.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Button widget.
  List<BuscarRebanhoRow>? rebanhoIndex2;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? loteAnimalExiste;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    nomeloteFocusNode?.dispose();
    nomeloteTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController3?.dispose();

    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();
  }
}
