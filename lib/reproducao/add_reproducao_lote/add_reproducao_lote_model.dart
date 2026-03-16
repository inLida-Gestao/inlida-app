import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'add_reproducao_lote_widget.dart' show AddReproducaoLoteWidget;
import 'package:flutter/material.dart';

class AddReproducaoLoteModel extends FlutterFlowModel<AddReproducaoLoteWidget> {
  ///  Local state fields for this component.

  String tipoReproducao = 'Inseminação';

  int score = 1;

  int partidaSemen = 1;

  int index = 0;

  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // State field(s) for DropDown-Lote widget.
  String? dropDownLoteValue;
  FormFieldController<String>? dropDownLoteValueController;
  DateTime? datePicked1;
  // State field(s) for Dropdown-Ressinc widget.
  String? dropdownRessincValue;
  FormFieldController<String>? dropdownRessincValueController;
  // State field(s) for Dropdown-gnrh widget.
  String? dropdownGnrhValue;
  FormFieldController<String>? dropdownGnrhValueController;
  // State field(s) for Dropdown-cio widget.
  String? dropdownCioValue;
  FormFieldController<String>? dropdownCioValueController;
  DateTime? datePicked2;
  DateTime? datePicked3;
  DateTime? datePicked4;
  // State field(s) for TextField-Inseminador widget.
  final textFieldInseminadorKey = GlobalKey();
  FocusNode? textFieldInseminadorFocusNode;
  TextEditingController? textFieldInseminadorTextController;
  String? textFieldInseminadorSelectedOption;
  String? Function(BuildContext, String?)?
      textFieldInseminadorTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // State field(s) for Dropdown-Status widget.
  String? dropdownStatusValue;
  FormFieldController<String>? dropdownStatusValueController;
  DateTime? datePicked5;
  DateTime? datePicked6;
  // State field(s) for CheckboxParida widget.
  bool? checkboxParidaValue;
  DateTime? datePicked7;
  // State field(s) for TextField-Anotacoes widget.
  FocusNode? textFieldAnotacoesFocusNode;
  TextEditingController? textFieldAnotacoesTextController;
  String? Function(BuildContext, String?)?
      textFieldAnotacoesTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? lote;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho Reproducao Lote)] action in Button widget.
  List<BuscarRebanhoReproducaoLoteRow>? animaisLote;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    textFieldInseminadorFocusNode?.dispose();

    textFieldAnotacoesFocusNode?.dispose();
    textFieldAnotacoesTextController?.dispose();
  }
}
