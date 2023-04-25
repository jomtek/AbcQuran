import 'package:flutter/material.dart';

class HomeState {
  final bool isFrameShown;
  final Widget frame;

  HomeState({required this.isFrameShown, required this.frame});

  factory HomeState.initial() {
    return HomeState(isFrameShown: false, frame: Container());
  }

  HomeState copyWith({bool? isFrameShown, Widget? frame}) {
    return HomeState(
        isFrameShown: isFrameShown ?? this.isFrameShown,
        frame: frame ?? this.frame);
  }
}
