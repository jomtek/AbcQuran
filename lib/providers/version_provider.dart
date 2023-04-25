import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionProvider =
    StateNotifierProvider<VersionNotifier, String>((ref) {
  return VersionNotifier();
});

class VersionNotifier extends StateNotifier<String> {
  VersionNotifier() : super("BETA");
}