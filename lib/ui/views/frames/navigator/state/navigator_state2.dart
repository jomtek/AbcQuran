import 'package:abc_quran/models/sura.dart';
import 'package:flutter/material.dart';

class NavigatorState2 {
  final List<SuraModel> allElements;
  final List<SuraModel> relevantElements;

  // Keep the scroll state
  final ScrollController scrollController;

  NavigatorState2(
      {required this.allElements,
      required this.relevantElements,
      required this.scrollController});

  factory NavigatorState2.initial() {
    return NavigatorState2(
        allElements: [],
        relevantElements: [],
        scrollController: ScrollController());
  }

  NavigatorState2 copyWith(
      {List<SuraModel>? allElements,
      List<SuraModel>? relevantElements,
      ScrollController? scrollController}) {
    return NavigatorState2(
        allElements: allElements ?? this.allElements,
        relevantElements: relevantElements ?? this.relevantElements,
        scrollController: this.scrollController);
  }
}
