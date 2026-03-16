import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'edit_sanidade_lote_widget.dart' show EditSanidadeLoteWidget;
import 'package:flutter/material.dart';

class EditSanidadeLoteModel extends FlutterFlowModel<EditSanidadeLoteWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimerrr;
  // State field(s) for TextField-Lote widget.
  FocusNode? textFieldLoteFocusNode;
  TextEditingController? textFieldLoteTextController;
  String? Function(BuildContext, String?)? textFieldLoteTextControllerValidator;
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
  List<String>? dropDownProtocoloValue;
  FormFieldController<List<String>>? dropDownProtocoloValueController;
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
    textFieldLoteFocusNode?.dispose();
    textFieldLoteTextController?.dispose();

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
