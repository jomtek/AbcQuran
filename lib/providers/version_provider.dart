import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionProvider =
    StateNotifierProvider<VersionNotifier, String>((ref) {
  return VersionNotifier(ref);
});

class VersionNotifier extends StateNotifier<String> {
    final StateNotifierProviderRef<VersionNotifier, String> _ref;

  VersionNotifier(this._ref) : super("BETA");
}