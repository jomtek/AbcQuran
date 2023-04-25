import 'revelation_type.dart';

class SuraModel {
  final int id;
  final int length;
  final String phoneticName;
  final String translatedName;
  final RevelationType revelationType;

  SuraModel(this.id, this.length, this.phoneticName, this.translatedName,
      this.revelationType);

  factory SuraModel.initial() {
    return SuraModel(0, 0, "", "", RevelationType.mh);
  }

  bool hasBasmala() {
    return ![0, 1, 9].contains(id);
  }

  static fromJson(Map<String, dynamic> json) => SuraModel(
      json["id"] as int,
      json["length"] as int,
      json["phoneticName"] as String,
      json["translatedName"] as String,
      RevelationType.values[json["revelationType"] as int]);

  @override
  String toString() {
    return "$id. $phoneticName ($translatedName)";
  }

  @override
  bool operator ==(Object other) {
    return id == (other as SuraModel).id;
  }

  @override
  int get hashCode {
    return id;
  }
}
