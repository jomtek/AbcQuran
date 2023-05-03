import 'revelation_type.dart';

class SuraModel {
  final int id;
  final int length;
  final String phoneticName;
  final Map<String, dynamic> translatedNames;
  final RevelationType revelationType;

  SuraModel(this.id, this.length, this.phoneticName, this.translatedNames,
      this.revelationType);

  factory SuraModel.initial() {
    return SuraModel(0, 0, "", {}, RevelationType.mh);
  }

  bool hasBasmala() {
    return ![0, 1, 9].contains(id);
  }

  int getFirstVerseId() {
    if (hasBasmala()) {
      return 0;
    } else {
      return 1;
    }
  }

  String getPaddedId() {
    return id.toString().padLeft(3, "0");
  }

  String getName(String languageId) {
    if (translatedNames.isEmpty) {
      return "";
    } else {
      return translatedNames[languageId];
    }
  }

  String pretty(String languageId) {
    return "$id. $phoneticName (${getName(languageId)})";
  }

  static fromJson(Map<String, dynamic> json) => SuraModel(
      json["id"] as int,
      json["length"] as int,
      json["phoneticName"] as String,
      json["translatedName"] as Map<String, dynamic>,
      RevelationType.values[json["revelationType"] as int]);

  @override
  bool operator ==(Object other) {
    return id == (other as SuraModel).id;
  }

  @override
  int get hashCode {
    return id;
  }
}
