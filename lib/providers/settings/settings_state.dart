import 'package:flutter/material.dart';

class SettingsState {
  final bool showMushaf;
  final PageController
      readPageController; // Not to be confused with a mushaf page

  SettingsState({required this.showMushaf, required this.readPageController});

  factory SettingsState.initial() {
    return SettingsState(
        showMushaf: false,
        readPageController:
            PageController(initialPage: 0) // Default is textual version
        );
  }

  SettingsState copyWith(
      {bool? showMushaf, PageController? readPageController}) {
    return SettingsState(
        showMushaf: showMushaf ?? this.showMushaf,
        readPageController: readPageController ?? this.readPageController);
  }
}
