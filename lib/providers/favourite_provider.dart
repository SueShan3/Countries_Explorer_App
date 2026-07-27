import '../constants/favorite_error_type.dart';
import '../models/country.dart';
import '../models/favorite_country.dart';
import '../services/storage_service.dart';
import './base_provider.dart';

class FavouriteProvider extends BaseProvider {
  final StorageService _storageService = StorageService();

  List<FavoriteCountry> _favoriteCountries = [];

  List<FavoriteCountry> get favoriteCountries => [..._favoriteCountries];

  Future<void> loadFavorites() async {
    clearError();

    try {
      _favoriteCountries = await _storageService.loadFavorites();

      notifyListeners();
    } catch (_) {
      setError(FavoriteErrorType.load.errorMessage);
    }
  }

  Future<bool> _saveFavorites({required FavoriteErrorType errorType}) async {
    clearError();

    try {
      await _storageService.saveFavorites(_favoriteCountries);
      return true;
    } catch (_) {
      setError(errorType.errorMessage);
      return false;
    }
  }

  FavoriteCountry? getFavoriteCountry(String code) {
    for (final country in _favoriteCountries) {
      if (country.code == code) return country;
    }
    return null;
  }

  bool isFavorite(String code) {
    return _favoriteCountries.any((country) => country.code == code);
  }

  Future<void> toggleFavorite(Country country) async {
    final previous = [..._favoriteCountries];
    final exists = _favoriteCountries.any((item) => item.code == country.code);

    if (exists) {
      _favoriteCountries.removeWhere((item) => item.code == country.code);
    } else {
      _favoriteCountries.add(
        FavoriteCountry(
          code: country.code,
          name: country.name,
          capital: country.capital,
          flagUrl: country.flagUrl,
        ),
      );
    }

    if (await _saveFavorites(
      errorType: exists ? FavoriteErrorType.remove : FavoriteErrorType.add,
    )) {
      notifyListeners();
    } else {
      _favoriteCountries = previous;
    }
  }

  Future<bool> removeFavorite(String code) async {
    final previous = [..._favoriteCountries];

    _favoriteCountries.removeWhere((item) => item.code == code);

    if (await _saveFavorites(errorType: FavoriteErrorType.remove)) {
      notifyListeners();
      return true;
    } else {
      _favoriteCountries = previous;
      return false;
    }
  }

  Future<bool> updateNote(String code, String? note) async {
    final index = _favoriteCountries.indexWhere(
      (country) => country.code == code,
    );

    if (index == -1) return false;

    final previous = [..._favoriteCountries];
    final old = _favoriteCountries[index];

    _favoriteCountries[index] = FavoriteCountry(
      code: old.code,
      name: old.name,
      capital: old.capital,
      flagUrl: old.flagUrl,
      note: note,
    );

    if (await _saveFavorites(errorType: FavoriteErrorType.note)) {
      notifyListeners();
      return true;
    } else {
      _favoriteCountries = previous;
      return false;
    }
  }
}
