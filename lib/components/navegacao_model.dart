import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'navegacao_widget.dart' show NavegacaoWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NavegacaoModel extends FlutterFlowModel<NavegacaoWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in navegacao widget.
  bool? temNet;
  // Stores action output result for [Custom Action - checkInternetConnection] action in IconButton widget.
  bool? temInternet;
  // Stores action output result for [Backend Call - Query Rows] action in IconButton widget.
  List<UsersRow>? userLogado;
  // Stores action output result for [Custom Action - checkInternetConnection] action in sincronizacao widget.
  bool? temInternet2;
  // Stores action output result for [Backend Call - Query Rows] action in sincronizacao widget.
  List<UsersRow>? userLogado2;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
