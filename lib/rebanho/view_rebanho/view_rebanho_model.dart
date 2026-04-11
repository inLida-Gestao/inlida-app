import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/rebanho/reproducoes_view_rebanho/reproducoes_view_rebanho_widget.dart';
import '/rebanho/view_rebanho/view_rebanho_widget.dart';
import 'view_rebanho_widget.dart' show ViewRebanhoWidget;
import 'package:flutter/material.dart';

class ViewRebanhoModel extends FlutterFlowModel<ViewRebanhoWidget> {
  ///  Local state fields for this component.

  int indexCrias = 0;

  int indexPesagens = 0;

  int index = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode1;
  TextEditingController? nAnimalTextController1;
  String? Function(BuildContext, String?)? nAnimalTextController1Validator;
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
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode2;
  TextEditingController? nAnimalTextController2;
  String? Function(BuildContext, String?)? nAnimalTextController2Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode3;
  TextEditingController? nAnimalTextController3;
  String? Function(BuildContext, String?)? nAnimalTextController3Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode4;
  TextEditingController? nAnimalTextController4;
  String? Function(BuildContext, String?)? nAnimalTextController4Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode5;
  TextEditingController? nAnimalTextController5;
  String? Function(BuildContext, String?)? nAnimalTextController5Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode6;
  TextEditingController? nAnimalTextController6;
  String? Function(BuildContext, String?)? nAnimalTextController6Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode7;
  TextEditingController? nAnimalTextController7;
  String? Function(BuildContext, String?)? nAnimalTextController7Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode8;
  TextEditingController? nAnimalTextController8;
  String? Function(BuildContext, String?)? nAnimalTextController8Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode9;
  TextEditingController? nAnimalTextController9;
  String? Function(BuildContext, String?)? nAnimalTextController9Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode10;
  TextEditingController? nAnimalTextController10;
  String? Function(BuildContext, String?)? nAnimalTextController10Validator;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Icon widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho Num)] action in Icon widget.
  List<BuscarRebanhoNumRow>? matrizRebanho;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Icon widget.
  List<BuscaHistPesagensRow>? histPesagensMatriz;
  // Stores action output result for [Backend Call - SQLite (listarPropriedades)] action in Icon widget.
  List<ListarPropriedadesRow>? propriedades;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Icon widget.
  List<BuscarLotesRow>? lotes;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode11;
  TextEditingController? nAnimalTextController11;
  String? Function(BuildContext, String?)? nAnimalTextController11Validator;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Icon widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho Num)] action in Icon widget.
  List<BuscarRebanhoNumRow>? reprodutorRebanho;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Icon widget.
  List<BuscaHistPesagensRow>? histPesagensReprodutor;
  // Stores action output result for [Backend Call - SQLite (listarPropriedades)] action in Icon widget.
  List<ListarPropriedadesRow>? propriedades2;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Icon widget.
  List<BuscarLotesRow>? lotes2;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode12;
  TextEditingController? nAnimalTextController12;
  String? Function(BuildContext, String?)? nAnimalTextController12Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode13;
  TextEditingController? nAnimalTextController13;
  String? Function(BuildContext, String?)? nAnimalTextController13Validator;
  // State field(s) for N_animal_oloco widget.
  FocusNode? nAnimalOlocoFocusNode;
  TextEditingController? nAnimalOlocoTextController;
  String? Function(BuildContext, String?)? nAnimalOlocoTextControllerValidator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode14;
  TextEditingController? nAnimalTextController14;
  String? Function(BuildContext, String?)? nAnimalTextController14Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode15;
  TextEditingController? nAnimalTextController15;
  String? Function(BuildContext, String?)? nAnimalTextController15Validator;
  // State field(s) for DataVenda widget.
  FocusNode? dataVendaFocusNode;
  TextEditingController? dataVendaTextController;
  String? Function(BuildContext, String?)? dataVendaTextControllerValidator;
  // State field(s) for ValorVenda widget.
  FocusNode? valorVendaFocusNode;
  TextEditingController? valorVendaTextController;
  String? Function(BuildContext, String?)? valorVendaTextControllerValidator;
  // State field(s) for DataMorte widget.
  FocusNode? dataMorteFocusNode;
  TextEditingController? dataMorteTextController;
  String? Function(BuildContext, String?)? dataMorteTextControllerValidator;
  // State field(s) for MotivoMorte widget.
  FocusNode? motivoMorteFocusNode;
  TextEditingController? motivoMorteTextController;
  String? Function(BuildContext, String?)? motivoMorteTextControllerValidator;
  // State field(s) for Anotacoes widget.
  FocusNode? anotacoesFocusNode;
  TextEditingController? anotacoesTextController;
  String? Function(BuildContext, String?)? anotacoesTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Button widget.
  List<BuscarRebanhoRow>? matrizSelecionada;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Button widget.
  List<BuscarRebanhoRow>? reprodutorSelecionado;
  // Stores action output result for [Backend Call - SQLite (listarPropriedades)] action in Button widget.
  List<ListarPropriedadesRow>? propriedadesView;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Button widget.
  List<BuscarLotesRow>? lotesRebView;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? matriz;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? reprodutorNome;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? crias2Femea;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? crias2Macho;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens2;
  // Model for reproducoesViewRebanho component.
  late ReproducoesViewRebanhoModel reproducoesViewRebanhoModel;

  @override
  void initState(BuildContext context) {
    reproducoesViewRebanhoModel =
        createModel(context, () => ReproducoesViewRebanhoModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    nAnimalFocusNode1?.dispose();
    nAnimalTextController1?.dispose();

    nChipFocusNode?.dispose();
    nChipTextController?.dispose();

    cdigoregistroFocusNode?.dispose();
    cdigoregistroTextController?.dispose();

    nomeAnimalFocusNode?.dispose();
    nomeAnimalTextController?.dispose();

    nAnimalFocusNode2?.dispose();
    nAnimalTextController2?.dispose();

    nAnimalFocusNode3?.dispose();
    nAnimalTextController3?.dispose();

    nAnimalFocusNode4?.dispose();
    nAnimalTextController4?.dispose();

    nAnimalFocusNode5?.dispose();
    nAnimalTextController5?.dispose();

    nAnimalFocusNode6?.dispose();
    nAnimalTextController6?.dispose();

    nAnimalFocusNode7?.dispose();
    nAnimalTextController7?.dispose();

    nAnimalFocusNode8?.dispose();
    nAnimalTextController8?.dispose();

    nAnimalFocusNode9?.dispose();
    nAnimalTextController9?.dispose();

    nAnimalFocusNode10?.dispose();
    nAnimalTextController10?.dispose();

    nAnimalFocusNode11?.dispose();
    nAnimalTextController11?.dispose();

    nAnimalFocusNode12?.dispose();
    nAnimalTextController12?.dispose();

    nAnimalFocusNode13?.dispose();
    nAnimalTextController13?.dispose();

    nAnimalOlocoFocusNode?.dispose();
    nAnimalOlocoTextController?.dispose();

    nAnimalFocusNode14?.dispose();
    nAnimalTextController14?.dispose();

    nAnimalFocusNode15?.dispose();
    nAnimalTextController15?.dispose();

    dataVendaFocusNode?.dispose();
    dataVendaTextController?.dispose();

    valorVendaFocusNode?.dispose();
    valorVendaTextController?.dispose();

    dataMorteFocusNode?.dispose();
    dataMorteTextController?.dispose();

    motivoMorteFocusNode?.dispose();
    motivoMorteTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();

    reproducoesViewRebanhoModel.dispose();
  }
}
