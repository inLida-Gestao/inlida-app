import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'add_rebanho_widget.dart' show AddRebanhoWidget;
import 'package:flutter/material.dart';

class PesagemPendente {
  PesagemPendente({required this.data, required this.peso});

  final DateTime data;
  final double peso;
}

class AddRebanhoModel extends FlutterFlowModel<AddRebanhoWidget> {
  ///  Local state fields for this component.

  String? idRebanho;

  List<String> animaisLote = [];
  void addToAnimaisLote(String item) => animaisLote.add(item);
  void removeFromAnimaisLote(String item) => animaisLote.remove(item);
  void removeAtIndexFromAnimaisLote(int index) => animaisLote.removeAt(index);
  void insertAtIndexInAnimaisLote(int index, String item) =>
      animaisLote.insert(index, item);
  void updateAnimaisLoteAtIndex(int index, Function(String) updateFn) =>
      animaisLote[index] = updateFn(animaisLote[index]);

  String? teste;

  bool ver = false;

  List<PesagemPendente> pesagensPendentes = [];

  ///  State fields for stateful widgets in this component.

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
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
  // State field(s) for DP-Categoria-Femea widget.
  String? dPCategoriaFemeaValue;
  FormFieldController<String>? dPCategoriaFemeaValueController;
  // State field(s) for DP-Categoria-Macho widget.
  String? dPCategoriaMachoValue;
  FormFieldController<String>? dPCategoriaMachoValueController;
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
  DateTime? datePicked3;
  // State field(s) for Pesodadesmama widget.
  FocusNode? pesodadesmamaFocusNode;
  TextEditingController? pesodadesmamaTextController;
  String? Function(BuildContext, String?)? pesodadesmamaTextControllerValidator;
  DateTime? datePicked4;
  // State field(s) for PesoAtual widget.
  FocusNode? pesoAtualFocusNode;
  TextEditingController? pesoAtualTextController;
  String? Function(BuildContext, String?)? pesoAtualTextControllerValidator;
  // State field(s) for DP-Status widget.
  String? dPStatusValue;
  FormFieldController<String>? dPStatusValueController;
  // State field(s) for DP-Origem widget.
  String? dPOrigemValue;
  FormFieldController<String>? dPOrigemValueController;
  DateTime? datePicked5;
  DateTime? datePicked6;
  DateTime? datePicked7;
  DateTime? datePicked8;
  DateTime? datePicked9;
  // State field(s) for DP-Motivo-Morte widget.
  String? dPMotivoMorteValue;
  FormFieldController<String>? dPMotivoMorteValueController;
  // State field(s) for Anotacoes widget.
  FocusNode? anotacoesFocusNode;
  TextEditingController? anotacoesTextController;
  String? Function(BuildContext, String?)? anotacoesTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? loteSelecionado;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    tabBarController?.dispose();
    pesagensPendentes.clear();
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

    pesodadesmamaFocusNode?.dispose();
    pesodadesmamaTextController?.dispose();

    pesoAtualFocusNode?.dispose();
    pesoAtualTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();
  }
}
