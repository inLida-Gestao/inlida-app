import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_reproducao_lote_widget.dart' show EditReproducaoLoteWidget;
import 'package:flutter/material.dart';

class EditReproducaoLoteModel
    extends FlutterFlowModel<EditReproducaoLoteWidget> {
  ///  Local state fields for this component.

  String tipoReproducao = 'Inseminação';

  double score = 0.5;

  int partidaSemen = 1;

  bool ressinc = false;

  bool parida = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - SQLite (Buscar Reproducao)] action in editReproducaoLote widget.
  List<BuscarReproducaoRow>? editReproducao;
  // State field(s) for Checkbox-Parida widget.
  bool? checkboxParidaValue;
  // State field(s) for DatePicked-DataParto widget.
  DateTime? datePicked7;
  // State field(s) for DropDown-Lote widget.
  String? dropDownLoteValue;
  FormFieldController<String>? dropDownLoteValueController;
  // State field(s) for DropDown-Reprodutor widget.
  String? dropDownReprodutorValue;
  FormFieldController<String>? dropDownReprodutorValueController;
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
  DateTime? datePicked5;
  // State field(s) for TextField-Inseminador widget.
  FocusNode? textFieldInseminadorFocusNode;
  TextEditingController? textFieldInseminadorTextController;
  String? Function(BuildContext, String?)?
      textFieldInseminadorTextControllerValidator;
  // State field(s) for Dropdown-Status widget.
  String? dropdownStatusValue;
  FormFieldController<String>? dropdownStatusValueController;
  DateTime? datePicked6;
  // State field(s) for TextField-Anotacoes widget.
  FocusNode? textFieldAnotacoesFocusNode;
  TextEditingController? textFieldAnotacoesTextController;
  String? Function(BuildContext, String?)?
      textFieldAnotacoesTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldInseminadorFocusNode?.dispose();
    textFieldInseminadorTextController?.dispose();

    textFieldAnotacoesFocusNode?.dispose();
    textFieldAnotacoesTextController?.dispose();
  }
}
