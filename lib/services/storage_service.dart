import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_country.dart';

class StorageService {
  static const _favoriteKey = 'favorites';

  Future<void> saveFavorites(List<FavoriteCountry> favorites) async {
    final prefs = await SharedPreferences.getInstance();

    final data = json.encode(favorites.map((item) => item.toJson()).toList());

    await prefs.setString(_favoriteKey, data);
  }

  Future<List<FavoriteCountry>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_favoriteKey);

    if (data == null) {
      return [];
    }

    final List decoded = json.decode(data);

    return decoded.map((item) => FavoriteCountry.fromJson(item)).toList();
  }
}
