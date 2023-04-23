class ReciterModel {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String? photoUrl;

  ReciterModel(
      this.id, this.firstName, this.lastName, this.displayName, this.photoUrl);

  factory ReciterModel.initial() {
    return ReciterModel("", "", "", "", null);
  }

  static fromJson(Map<String, dynamic> json) => ReciterModel(
        json["id"] as String,
        json["first_name"] as String,
        json["last_name"] as String,
        json["display_name"] as String,
        json["photo"] as String,
      );
}
