import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/sanidade/legenda_sanidade/legenda_sanidade_widget.dart';
import '/sanidade/selecionar_sanidade/selecionar_sanidade_widget.dart';
import 'dart:async';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_sanidade_animal_widget.dart' show EditSanidadeAnimalWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditSanidadeAnimalModel
    extends FlutterFlowModel<EditSanidadeAnimalWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimerrr;
  DateTime? datePicked;
  // State field(s) for DropDown-vacina widget.
  List<String>? dropDownVacinaValue;
  FormFieldController<List<String>>? dropDownVacinaValueController;
  // State field(s) for DropDown-vacinaNull widget.
  List<String>? dropDownVacinaNullValue;
  FormFieldController<List<String>>? dropDownVacinaNullValueController;
  // State field(s) for TextField-vacina-outros widget.
  FocusNode? textFieldVacinaOutrosFocusNode;
  TextEditingController? textFieldVacinaOutrosTextController;
  String? Function(BuildContext, String?)?
      textFieldVacinaOutrosTextControllerValidator;
  // State field(s) for TextField-vacina-observacao widget.
  FocusNode? textFieldVacinaObservacaoFocusNode;
  TextEditingController? textFieldVacinaObservacaoTextController;
  String? Function(BuildContext, String?)?
      textFieldVacinaObservacaoTextControllerValidator;
  // State field(s) for DropDown-antiparasitario widget.
  List<String>? dropDownAntiparasitarioValue;
  FormFieldController<List<String>>? dropDownAntiparasitarioValueController;
  // State field(s) for DropDown-antiparasitarioNull widget.
  List<String>? dropDownAntiparasitarioNullValue;
  FormFieldController<List<String>>? dropDownAntiparasitarioNullValueController;
  // State field(s) for TextField-antiparasitario-outros widget.
  FocusNode? textFieldAntiparasitarioOutrosFocusNode;
  TextEditingController? textFieldAntiparasitarioOutrosTextController;
  String? Function(BuildContext, String?)?
      textFieldAntiparasitarioOutrosTextControllerValidator;
  // State field(s) for TextField-antiparasitario-observacao widget.
  FocusNode? textFieldAntiparasitarioObservacaoFocusNode;
  TextEditingController? textFieldAntiparasitarioObservacaoTextController;
  String? Function(BuildContext, String?)?
      textFieldAntiparasitarioObservacaoTextControllerValidator;
  // State field(s) for DropDown-tratamento widget.
  List<String>? dropDownTratamentoValue;
  FormFieldController<List<String>>? dropDownTratamentoValueController;
  // State field(s) for DropDown-tratamentoNull widget.
  List<String>? dropDownTratamentoNullValue;
  FormFieldController<List<String>>? dropDownTratamentoNullValueController;
  // State field(s) for TextField-tratamento-outros widget.
  FocusNode? textFieldTratamentoOutrosFocusNode;
  TextEditingController? textFieldTratamentoOutrosTextController;
  String? Function(BuildContext, String?)?
      textFieldTratamentoOutrosTextControllerValidator;
  // State field(s) for TextField-tratamento-Observacao widget.
  FocusNode? textFieldTratamentoObservacaoFocusNode;
  TextEditingController? textFieldTratamentoObservacaoTextController;
  String? Function(BuildContext, String?)?
      textFieldTratamentoObservacaoTextControllerValidator;
  // State field(s) for DropDown-Protocolo widget.
  String? dropDownProtocoloValue;
  FormFieldController<String>? dropDownProtocoloValueController;
  // State field(s) for DropDown-D0 widget.
  String? dropDownD0Value;
  FormFieldController<String>? dropDownD0ValueController;
  // State field(s) for DropDown-Retirada widget.
  String? dropDownRetiradaValue;
  FormFieldController<String>? dropDownRetiradaValueController;
  // State field(s) for DropDown-IATF widget.
  String? dropDownIATFValue;
  FormFieldController<String>? dropDownIATFValueController;
  // State field(s) for TextField-Protocolo-Outros widget.
  FocusNode? textFieldProtocoloOutrosFocusNode;
  TextEditingController? textFieldProtocoloOutrosTextController;
  String? Function(BuildContext, String?)?
      textFieldProtocoloOutrosTextControllerValidator;
  // State field(s) for TextField-Protocolo-Observacao widget.
  FocusNode? textFieldProtocoloObservacaoFocusNode;
  TextEditingController? textFieldProtocoloObservacaoTextController;
  String? Function(BuildContext, String?)?
      textFieldProtocoloObservacaoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimerrr?.cancel();
    textFieldVacinaOutrosFocusNode?.dispose();
    textFieldVacinaOutrosTextController?.dispose();

    textFieldVacinaObservacaoFocusNode?.dispose();
    textFieldVacinaObservacaoTextController?.dispose();

    textFieldAntiparasitarioOutrosFocusNode?.dispose();
    textFieldAntiparasitarioOutrosTextController?.dispose();

    textFieldAntiparasitarioObservacaoFocusNode?.dispose();
    textFieldAntiparasitarioObservacaoTextController?.dispose();

    textFieldTratamentoOutrosFocusNode?.dispose();
    textFieldTratamentoOutrosTextController?.dispose();

    textFieldTratamentoObservacaoFocusNode?.dispose();
    textFieldTratamentoObservacaoTextController?.dispose();

    textFieldProtocoloOutrosFocusNode?.dispose();
    textFieldProtocoloOutrosTextController?.dispose();

    textFieldProtocoloObservacaoFocusNode?.dispose();
    textFieldProtocoloObservacaoTextController?.dispose();
  }
}
