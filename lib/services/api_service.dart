import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

class ApiService {
  static const String _baseUrl = 'https://countries.dev';

  Future<List<Country>> fetchCountries() async {
    final url = '$_baseUrl/countries';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      final List<dynamic> decoded = json.decode(response.body);

      return decoded
          .map(
            (country) => Country(
              code: country['alpha3Code'],
              name: country['name'],
              capital: country['capital'] ?? 'N/A',
              region: country['region'],
              flagUrl: country['flags']?['png'] ?? '',

              population: country['population'],
              area: (country['area'] ?? 0).toDouble(),

              currencies: (country['currencies'] as List<dynamic>? ?? [])
                  .map(
                    (currency) => Currencies(
                      code: currency['code'] ?? '',
                      name: currency['name'] ?? '',
                      symbol: currency['symbol'] ?? '',
                    ),
                  )
                  .toList(),

              languages:
                  (country['languages'] as List<dynamic>?)
                      ?.map((language) => language['name'].toString())
                      .toList() ??
                  [],

              borders: List<String>.from(country['borders'] ?? []),
            ),
          )
          .toList();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<String>> fetchRegions() async {
    final url = '$_baseUrl/regions';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      final List<String> data = List<String>.from(json.decode(response.body));

      return data;
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
