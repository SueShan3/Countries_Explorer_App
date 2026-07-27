class FavoriteCountry {
  final String code;
  final String name;
  final String capital;
  final String flagUrl;
  String? note;

  FavoriteCountry({
    required this.code,
    required this.name,
    required this.capital,
    required this.flagUrl,
    this.note,
  });

  factory FavoriteCountry.fromJson(Map<String, dynamic> json) {
    return FavoriteCountry(
      code: json['code'],
      name: json['name'],
      capital: json['capital'],
      flagUrl: json['flagUrl'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'capital': capital,
      'flagUrl': flagUrl,
      'note': note,
    };
  }
}
