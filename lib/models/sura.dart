import 'revelation_type.dart';

class Sura {
  final int id;
  final int length;
  final String phoneticName;
  final String translatedName;
  final RevelationType revelationType;

  Sura(this.id, this.length, this.phoneticName, this.translatedName,
      this.revelationType);

  static fromJson(Map<String, dynamic> json) => Sura(
      json["id"] as int,
      json["length"] as int,
      json["phoneticName"] as String,
      json["translatedName"] as String,
      RevelationType.values[json["revelationType"] as int]);
}
