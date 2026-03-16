import '/flutter_flow/flutter_flow_util.dart';
import 'view_lote_widget.dart' show ViewLoteWidget;
import 'package:flutter/material.dart';

class ViewLoteModel extends FlutterFlowModel<ViewLoteWidget> {
  ///  Local state fields for this component.

  int mostrarAnimais = 5;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for InputLogin widget.
  FocusNode? inputLoginFocusNode1;
  TextEditingController? inputLoginTextController1;
  String? Function(BuildContext, String?)? inputLoginTextController1Validator;
  // State field(s) for InputLogin widget.
  FocusNode? inputLoginFocusNode2;
  TextEditingController? inputLoginTextController2;
  String? Function(BuildContext, String?)? inputLoginTextController2Validator;
  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode1;
  TextEditingController? nAnimalTextController1;
  String? Function(BuildContext, String?)? nAnimalTextController1Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode2;
  TextEditingController? nAnimalTextController2;
  String? Function(BuildContext, String?)? nAnimalTextController2Validator;
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode3;
  TextEditingController? nAnimalTextController3;
  String? Function(BuildContext, String?)? nAnimalTextController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    inputLoginFocusNode1?.dispose();
    inputLoginTextController1?.dispose();

    inputLoginFocusNode2?.dispose();
    inputLoginTextController2?.dispose();

    nAnimalFocusNode1?.dispose();
    nAnimalTextController1?.dispose();

    nAnimalFocusNode2?.dispose();
    nAnimalTextController2?.dispose();

    nAnimalFocusNode3?.dispose();
    nAnimalTextController3?.dispose();

    textFieldFocusNode?.dispose();
    textController6?.dispose();
  }
}
