class Country {
  final String code; // alpha2Code
  final String name;
  final String capital;
  final String region;
  final String flagUrl;

  final int population;
  final double area;

  final List<Currencies> currencies;
  final List<String> languages;
  final List<String> borders;

  Country({
    required this.code,
    required this.name,
    required this.capital,
    required this.region,
    required this.flagUrl,
    required this.population,
    required this.area,
    required this.currencies,
    required this.languages,
    required this.borders,
  });
}

class Currencies {
  final String code;
  final String name;
  final String symbol;

  Currencies({required this.code, required this.name, required this.symbol});
}
