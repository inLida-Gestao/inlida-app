import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/components/navegacao_widget.dart';
import '/components/navegar_bottom_widget.dart';
import '/components/pesquisa_geral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/lotes/add_lote/add_lote_widget.dart';
import '/lotes/page_lotes/page_lotes_widget.dart';
import '/perfil/minha_conta/minha_conta_widget.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/page_propriedades/page_propriedades_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/rebanho/page_rebanho/page_rebanho_widget.dart';
import '/rebanho/sub_menu_rebanho/sub_menu_rebanho_widget.dart';
import '/reproducao/page_reproducoes/page_reproducoes_widget.dart';
import '/reproducao/popup_reproducao/popup_reproducao_widget.dart';
import '/sanidade/page_sanidade/page_sanidade_widget.dart';
import '/sanidade/popup_sanidade/popup_sanidade_widget.dart';
import 'dart:async';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<UsersRow>? userLogadoON;
  InstantTimer? instantTimer;
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
    instantTimer?.cancel();
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
