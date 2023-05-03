class TranslationModel {
  final String id;
  final String language;
  final String name;

  TranslationModel(this.id, this.language, this.name);

  factory TranslationModel.initial() {
    return TranslationModel("", "", "");
  }

  static fromJson(Map<String, dynamic> json) => TranslationModel(
      json["id"] as String, json["language"] as String, json["name"] as String);

  String getFlagId() {
    return id.split(".")[0];
  }
}
