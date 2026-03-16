import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'add_rebanho_nascimento_widget.dart' show AddRebanhoNascimentoWidget;
import 'package:flutter/material.dart';

class AddRebanhoNascimentoModel
    extends FlutterFlowModel<AddRebanhoNascimentoWidget> {
  ///  Local state fields for this component.

  String? idRebanho;

  List<String> idAnimais = [];
  void addToIdAnimais(String item) => idAnimais.add(item);
  void removeFromIdAnimais(String item) => idAnimais.remove(item);
  void removeAtIndexFromIdAnimais(int index) => idAnimais.removeAt(index);
  void insertAtIndexInIdAnimais(int index, String item) =>
      idAnimais.insert(index, item);
  void updateIdAnimaisAtIndex(int index, Function(String) updateFn) =>
      idAnimais[index] = updateFn(idAnimais[index]);

  ///  State fields for stateful widgets in this component.

  final formKey2 = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode;
  TextEditingController? nAnimalTextController;
  String? Function(BuildContext, String?)? nAnimalTextControllerValidator;
  // State field(s) for N_Chip widget.
  FocusNode? nChipFocusNode;
  TextEditingController? nChipTextController;
  String? Function(BuildContext, String?)? nChipTextControllerValidator;
  // State field(s) for Cdigoregistro widget.
  FocusNode? cdigoregistroFocusNode;
  TextEditingController? cdigoregistroTextController;
  String? Function(BuildContext, String?)? cdigoregistroTextControllerValidator;
  // State field(s) for Nome_Animal widget.
  FocusNode? nomeAnimalFocusNode;
  TextEditingController? nomeAnimalTextController;
  String? Function(BuildContext, String?)? nomeAnimalTextControllerValidator;
  // State field(s) for DropDown-Sexo widget.
  String? dropDownSexoValue;
  FormFieldController<String>? dropDownSexoValueController;
  DateTime? datePicked1;
  // State field(s) for Pesonascimento widget.
  FocusNode? pesonascimentoFocusNode;
  TextEditingController? pesonascimentoTextController;
  String? Function(BuildContext, String?)?
      pesonascimentoTextControllerValidator;
  // State field(s) for DP-Porte widget.
  String? dPPorteValue;
  FormFieldController<String>? dPPorteValueController;
  // State field(s) for DP-Raca widget.
  String? dPRacaValue;
  FormFieldController<String>? dPRacaValueController;
  // State field(s) for DP-Lote widget.
  String? dPLoteValue;
  FormFieldController<String>? dPLoteValueController;
  DateTime? datePicked2;
  // State field(s) for DP-Status widget.
  String? dPStatusValue;
  FormFieldController<String>? dPStatusValueController;
  DateTime? datePicked3;
  DateTime? datePicked4;
  // State field(s) for DP-Motivo-Morte widget.
  String? dPMotivoMorteValue;
  FormFieldController<String>? dPMotivoMorteValueController;
  DateTime? datePicked5;
  // State field(s) for Anotacoes widget.
  FocusNode? anotacoesFocusNode;
  TextEditingController? anotacoesTextController;
  String? Function(BuildContext, String?)? anotacoesTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? loteSelecionadoNasc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    tabBarController?.dispose();
    nAnimalFocusNode?.dispose();
    nAnimalTextController?.dispose();

    nChipFocusNode?.dispose();
    nChipTextController?.dispose();

    cdigoregistroFocusNode?.dispose();
    cdigoregistroTextController?.dispose();

    nomeAnimalFocusNode?.dispose();
    nomeAnimalTextController?.dispose();

    pesonascimentoFocusNode?.dispose();
    pesonascimentoTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();
  }
}
