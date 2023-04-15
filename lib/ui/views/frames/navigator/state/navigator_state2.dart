import 'package:flutter/material.dart';

class NavigatorState2 {
  // Keep the scroll state
  final ScrollController scrollController;

  NavigatorState2({required this.scrollController});

  factory NavigatorState2.initial() {
    return NavigatorState2(scrollController: ScrollController());
  }

  NavigatorState2 copyWith({ScrollController? scrollController}) {
    return NavigatorState2(
        scrollController: this.scrollController);
  }
}
