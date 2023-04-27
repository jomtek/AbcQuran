import 'package:abc_quran/models/sura.dart';

class ReciterModel {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String? photoUrl;
  final String? audioSource;

  ReciterModel(this.id, this.firstName, this.lastName, this.displayName,
      this.photoUrl, this.audioSource);

  factory ReciterModel.initial() {
    return ReciterModel("", "", "", "", null, "");
  }

  static fromJson(Map<String, dynamic> json) => ReciterModel(
      json["id"] as String,
      json["first_name"] as String,
      json["last_name"] as String,
      json["display_name"] as String,
      json["photo"] as String,
      json["audio_source"] as String);

  String buildSourceFor(SuraModel sura) {
    return "$audioSource/${sura.getPaddedId()}.mp3";
  }
}
