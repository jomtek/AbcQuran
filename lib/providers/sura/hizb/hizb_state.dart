import 'package:abc_quran/models/hizb.dart';

class HizbState {
  final List<HizbModel> locations;
  final List<double> heights;

  HizbState({required this.locations, required this.heights});

  factory HizbState.initial() {
    return HizbState(locations: [], heights: []);
  }

  HizbState copyWith({List<HizbModel>? locations, List<double>? heights}) {
    return HizbState(
        locations: locations ?? this.locations,
        heights: heights ?? this.heights);
  }
}
