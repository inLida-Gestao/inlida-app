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
import '/flutter_flow/random_data_util.dart' as random_data;
import 'add_sanidade_lote_widget.dart' show AddSanidadeLoteWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddSanidadeLoteModel extends FlutterFlowModel<AddSanidadeLoteWidget> {
  ///  Local state fields for this component.

  int index = 0;

  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimerrr;
  // State field(s) for DropDown-Lote widget.
  String? dropDownLoteValue;
  FormFieldController<String>? dropDownLoteValueController;
  // State field(s) for TextField-Porcentagem-lote widget.
  FocusNode? textFieldPorcentagemLoteFocusNode;
  TextEditingController? textFieldPorcentagemLoteTextController;
  String? Function(BuildContext, String?)?
      textFieldPorcentagemLoteTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for DropDown-vacina widget.
  List<String>? dropDownVacinaValue;
  FormFieldController<List<String>>? dropDownVacinaValueController;
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
  // Stores action output result for [Backend Call - SQLite (Buscar Animais do Lote)] action in Button widget.
  List<BuscarAnimaisDoLoteRow>? loteSelecionado;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimerrr?.cancel();
    textFieldPorcentagemLoteFocusNode?.dispose();
    textFieldPorcentagemLoteTextController?.dispose();

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
