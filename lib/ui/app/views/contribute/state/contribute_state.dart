class ContributeState {
  final bool isContributing;
  final int currentTime;

  final List<int> newTimecodes;

  ContributeState(
      {required this.isContributing,
      required this.currentTime,
      required this.newTimecodes});

  factory ContributeState.initial() {
    return ContributeState(
        isContributing: false, currentTime: 0, newTimecodes: []);
  }

  ContributeState copyWith(
      {bool? isContributing, int? currentTime, List<int>? newTimecodes}) {
    return ContributeState(
        isContributing: isContributing ?? this.isContributing,
        currentTime: currentTime ?? this.currentTime,
        newTimecodes: newTimecodes ?? this.newTimecodes);
  }
}
