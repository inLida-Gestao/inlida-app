import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'add_propriedade_widget.dart' show AddPropriedadeWidget;
import 'package:flutter/material.dart';

class AddPropriedadeModel extends FlutterFlowModel<AddPropriedadeWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in addPropriedade widget.
  bool? temNet;
  // State field(s) for Nome-Propriedade widget.
  FocusNode? nomePropriedadeFocusNode;
  TextEditingController? nomePropriedadeTextController;
  String? Function(BuildContext, String?)?
      nomePropriedadeTextControllerValidator;
  String? _nomePropriedadeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // State field(s) for Dropdown-UF widget.
  String? dropdownUFValue;
  FormFieldController<String>? dropdownUFValueController;
  // State field(s) for benfeitoria widget.
  FocusNode? benfeitoriaFocusNode;
  TextEditingController? benfeitoriaTextController;
  String? Function(BuildContext, String?)? benfeitoriaTextControllerValidator;
  // State field(s) for TFpastagem widget.
  FocusNode? tFpastagemFocusNode;
  TextEditingController? tFpastagemTextController;
  String? Function(BuildContext, String?)? tFpastagemTextControllerValidator;
  // State field(s) for TFreserva widget.
  FocusNode? tFreservaFocusNode;
  TextEditingController? tFreservaTextController;
  String? Function(BuildContext, String?)? tFreservaTextControllerValidator;
  // State field(s) for TFagricultura widget.
  FocusNode? tFagriculturaFocusNode;
  TextEditingController? tFagriculturaTextController;
  String? Function(BuildContext, String?)? tFagriculturaTextControllerValidator;
  // State field(s) for Dropdown_Atividades widget.
  List<String>? dropdownAtividadesValue;
  FormFieldController<List<String>>? dropdownAtividadesValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;

  @override
  void initState(BuildContext context) {
    nomePropriedadeTextControllerValidator =
        _nomePropriedadeTextControllerValidator;
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    nomePropriedadeFocusNode?.dispose();
    nomePropriedadeTextController?.dispose();

    benfeitoriaFocusNode?.dispose();
    benfeitoriaTextController?.dispose();

    tFpastagemFocusNode?.dispose();
    tFpastagemTextController?.dispose();

    tFreservaFocusNode?.dispose();
    tFreservaTextController?.dispose();

    tFagriculturaFocusNode?.dispose();
    tFagriculturaTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController6?.dispose();
  }
}
