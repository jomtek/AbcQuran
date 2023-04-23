import 'package:flutter_riverpod/flutter_riverpod.dart';

final ctrlKeyProvider =
    StateNotifierProvider<CtrlKeyNotifier, bool>((ref) {
  return CtrlKeyNotifier();
});

class CtrlKeyNotifier extends StateNotifier<bool> {
  CtrlKeyNotifier() : super(false);

  void setCtrlKey(bool isEnabled) {
    state = isEnabled;
  }
}