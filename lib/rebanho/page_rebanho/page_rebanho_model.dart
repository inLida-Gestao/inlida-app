import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'page_rebanho_widget.dart' show PageRebanhoWidget;
import 'package:flutter/material.dart';

class PageRebanhoModel extends FlutterFlowModel<PageRebanhoWidget> {
  ///  Local state fields for this component.

  int indexCrias = 0;

  int indexPesagens = 0;

  int index = 0;

  int? limit = 20;

  int? offset = 0;

  int? pageNum = 1;

  ///  State fields for stateful widgets in this component.

  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea2;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho2;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens2;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes2;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea3;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho3;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens3;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes3;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea4;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho4;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens4;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes4;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea5;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho5;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens5;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes5;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea6;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho6;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens6;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes6;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemea7;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMacho7;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagens7;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotes7;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Matriz)] action in Row widget.
  List<BuscarCriasRebanhoMatrizRow>? criasFemeaPesq;
  // Stores action output result for [Backend Call - SQLite (Buscar Crias Rebanho Reprodutor)] action in Row widget.
  List<BuscarCriasRebanhoReprodutorRow>? criasMachoPesq;
  // Stores action output result for [Backend Call - SQLite (Busca Hist Pesagens)] action in Row widget.
  List<BuscaHistPesagensRow>? histPesagensPesq;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotesPesq;

  @override
  void initState(BuildContext context) {
    selecionarPropriedadeModel =
        createModel(context, () => SelecionarPropriedadeModel());
  }

  @override
  void dispose() {
    selecionarPropriedadeModel.dispose();
    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();
  }
}
