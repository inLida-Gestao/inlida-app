import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import 'dart:async';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_lote_widget.dart' show EditLoteWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditLoteModel extends FlutterFlowModel<EditLoteWidget> {
  ///  Local state fields for this component.

  List<RebanhoStruct> rebanhosSelecionados = [];
  void addToRebanhosSelecionados(RebanhoStruct item) =>
      rebanhosSelecionados.add(item);
  void removeFromRebanhosSelecionados(RebanhoStruct item) =>
      rebanhosSelecionados.remove(item);
  void removeAtIndexFromRebanhosSelecionados(int index) =>
      rebanhosSelecionados.removeAt(index);
  void insertAtIndexInRebanhosSelecionados(int index, RebanhoStruct item) =>
      rebanhosSelecionados.insert(index, item);
  void updateRebanhosSelecionadosAtIndex(
          int index, Function(RebanhoStruct) updateFn) =>
      rebanhosSelecionados[index] = updateFn(rebanhosSelecionados[index]);

  List<RebanhoStruct> rebanhosAplicados = [];
  void addToRebanhosAplicados(RebanhoStruct item) =>
      rebanhosAplicados.add(item);
  void removeFromRebanhosAplicados(RebanhoStruct item) =>
      rebanhosAplicados.remove(item);
  void removeAtIndexFromRebanhosAplicados(int index) =>
      rebanhosAplicados.removeAt(index);
  void insertAtIndexInRebanhosAplicados(int index, RebanhoStruct item) =>
      rebanhosAplicados.insert(index, item);
  void updateRebanhosAplicadosAtIndex(
          int index, Function(RebanhoStruct) updateFn) =>
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

  List<String> rebanhoIdAplicados = [];
  void addToRebanhoIdAplicados(String item) => rebanhoIdAplicados.add(item);
  void removeFromRebanhoIdAplicados(String item) =>
      rebanhoIdAplicados.remove(item);
  void removeAtIndexFromRebanhoIdAplicados(int index) =>
      rebanhoIdAplicados.removeAt(index);
  void insertAtIndexInRebanhoIdAplicados(int index, String item) =>
      rebanhoIdAplicados.insert(index, item);
  void updateRebanhoIdAplicadosAtIndex(int index, Function(String) updateFn) =>
      rebanhoIdAplicados[index] = updateFn(rebanhoIdAplicados[index]);

  List<String> idAnimais = [];
  void addToIdAnimais(String item) => idAnimais.add(item);
  void removeFromIdAnimais(String item) => idAnimais.remove(item);
  void removeAtIndexFromIdAnimais(int index) => idAnimais.removeAt(index);
  void insertAtIndexInIdAnimais(int index, String item) =>
      idAnimais.insert(index, item);
  void updateIdAnimaisAtIndex(int index, Function(String) updateFn) =>
      idAnimais[index] = updateFn(idAnimais[index]);

  String? loteAtual;

  int limit = 5;

  int offset = 0;

  int pageNum = 1;

  int mostrarAdicionados = 5;

  List<String> rebanhosIDAux = [];
  void addToRebanhosIDAux(String item) => rebanhosIDAux.add(item);
  void removeFromRebanhosIDAux(String item) => rebanhosIDAux.remove(item);
  void removeAtIndexFromRebanhosIDAux(int index) =>
      rebanhosIDAux.removeAt(index);
  void insertAtIndexInRebanhosIDAux(int index, String item) =>
      rebanhosIDAux.insert(index, item);
  void updateRebanhosIDAuxAtIndex(int index, Function(String) updateFn) =>
      rebanhosIDAux[index] = updateFn(rebanhosIDAux[index]);

  int mostrarFora = 10;

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
  Map<RebanhoStruct, bool> checkboxValueMap3 = {};
  List<RebanhoStruct> get checkboxCheckedItems3 => checkboxValueMap3.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();

  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Button widget.
  List<BuscarRebanhoRow>? rebanhoIndex;
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
