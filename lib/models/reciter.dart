import 'package:abc_quran/models/sura.dart';

class ReciterModel {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String? photoUrl;
  final String? audioSource;

  // An array containing the ids of each sura where the basmala audio is missing
  final List<int> missingBasmala;

  // An array containing the ids of each sura where the basmala audio is unwanted
  final List<int> unwantedBasmala;

  ReciterModel(
      this.id,
      this.firstName,
      this.lastName,
      this.displayName,
      this.photoUrl,
      this.audioSource,
      this.missingBasmala,
      this.unwantedBasmala);

  factory ReciterModel.initial() {
    return ReciterModel("", "", "", "", null, "", [], []);
  }

  static fromJson(Map<String, dynamic> json) => ReciterModel(
      json["id"] as String,
      json["first_name"] as String,
      json["last_name"] as String,
      json["display_name"] as String,
      json["photo"] as String,
      json["audio_source"] as String,
      json["missing_basmala"].cast<int>(),
      json["unwanted_basmala"].cast<int>());

  String buildSourceFor(SuraModel sura) {
    return "$audioSource/${sura.getPaddedId()}.mp3";
  }
}
