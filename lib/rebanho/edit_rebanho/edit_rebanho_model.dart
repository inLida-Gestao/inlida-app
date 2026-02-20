import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/saiba_mais_b_t_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/add_pesagem/add_pesagem_widget.dart';
import '/rebanho/popup_rebanhos/popup_rebanhos_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_rebanho_widget.dart' show EditRebanhoWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditRebanhoModel extends FlutterFlowModel<EditRebanhoWidget> {
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

  String? loteAtual;

  int limit = 20;

  int offset = 0;

  ///  State fields for stateful widgets in this component.

  final formKey2 = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
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
  List<BuscarLoteRow>? loteSelecionadoEditExiste;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? loteSelecionadoEdit2;
  // Stores action output result for [Backend Call - SQLite (Buscar Lote)] action in Button widget.
  List<BuscarLoteRow>? loteSelecionadoEdit;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
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

    pesodadesmamaFocusNode?.dispose();
    pesodadesmamaTextController?.dispose();

    pesoAtualFocusNode?.dispose();
    pesoAtualTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();
  }
}
