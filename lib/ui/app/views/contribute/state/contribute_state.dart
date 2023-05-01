class ContributeState {
  final bool isContributing;
  final int currentTime;
  final int currentVerse;

  final List<int> newTimecodes;

  final bool isSending;
  final int contributionsSent;

  ContributeState(
      {required this.isContributing,
      required this.currentTime,
      required this.currentVerse,
      required this.newTimecodes,
      required this.isSending,
      required this.contributionsSent});

  factory ContributeState.initial() {
    return ContributeState(
        isContributing: false,
        currentTime: 0,
        currentVerse: 0,
        newTimecodes: [],
        isSending: false,
        contributionsSent: 0);
  }

  ContributeState copyWith(
      {bool? isContributing,
      int? currentTime,
      int? currentVerse,
      List<int>? newTimecodes,
      bool? isSending,
      int? contributionsSent}) {
    return ContributeState(
        isContributing: isContributing ?? this.isContributing,
        currentTime: currentTime ?? this.currentTime,
        currentVerse: currentVerse ?? this.currentVerse,
        newTimecodes: newTimecodes ?? this.newTimecodes,
        isSending: isSending ?? this.isSending,
        contributionsSent: contributionsSent ?? this.contributionsSent);
  }
}
