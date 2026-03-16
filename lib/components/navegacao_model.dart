import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'navegacao_widget.dart' show NavegacaoWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
