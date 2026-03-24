import '/backend/supabase/supabase.dart';
import '/components/navegacao_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/lotes/page_lotes/page_lotes_widget.dart';
import '/perfil/minha_conta/minha_conta_widget.dart';
import '/propriedade/page_propriedades/page_propriedades_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/rebanho/page_rebanho/page_rebanho_widget.dart';
import '/reproducao/page_reproducoes/page_reproducoes_widget.dart';
import '/sanidade/page_sanidade/page_sanidade_widget.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<UsersRow>? userLogadoON;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  // Stores action output result for [Custom Action - checkInternetConnection] action in HomePage widget.
  bool? temNet;
  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<UsersRow>? userLogado;
  // Model for pagePropriedades component.
  late PagePropriedadesModel pagePropriedadesModel;
  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for pageRebanho component.
  late PageRebanhoModel pageRebanhoModel;
  // Model for pageLotes component.
  late PageLotesModel pageLotesModel;
  // Model for pageReproducoes component.
  late PageReproducoesModel pageReproducoesModel;
  // Model for pageSanidade component.
  late PageSanidadeModel pageSanidadeModel;
  // Model for minhaConta component.
  late MinhaContaModel minhaContaModel;
  // Model for navegacao component.
  late NavegacaoModel navegacaoModel;

  @override
  void initState(BuildContext context) {
    pagePropriedadesModel = createModel(context, () => PagePropriedadesModel());
    selecionarPropriedadeModel =
        createModel(context, () => SelecionarPropriedadeModel());
    pageRebanhoModel = createModel(context, () => PageRebanhoModel());
    pageLotesModel = createModel(context, () => PageLotesModel());
    pageReproducoesModel = createModel(context, () => PageReproducoesModel());
    pageSanidadeModel = createModel(context, () => PageSanidadeModel());
    minhaContaModel = createModel(context, () => MinhaContaModel());
    navegacaoModel = createModel(context, () => NavegacaoModel());
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    pagePropriedadesModel.dispose();
    selecionarPropriedadeModel.dispose();
    pageRebanhoModel.dispose();
    pageLotesModel.dispose();
    pageReproducoesModel.dispose();
    pageSanidadeModel.dispose();
    minhaContaModel.dispose();
    navegacaoModel.dispose();
  }
}
