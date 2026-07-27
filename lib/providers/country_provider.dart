import '../models/country.dart';
import '../services/api_service.dart';
import './base_provider.dart';

class CountryProvider extends BaseProvider {
  final ApiService _apiService = ApiService();

  List<Country> _allCountries = [];
  List<Country> _countries = [];

  List<String> _regions = ['All Regions'];

  String _selectedRegion = 'All Regions';
  String _searchQuery = '';

  List<Country> get countries => [..._countries];

  List<String> get regions => [..._regions];

  String get selectedRegion => _selectedRegion;

  String get searchQuery => _searchQuery;

  void setSelectedRegion(String region) {
    _selectedRegion = region;
    _applyFilters();
  }

  void searchCountries(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  Country? getCountryByCode(String code) {
    try {
      return _allCountries.firstWhere((country) => country.code == code);
    } catch (_) {
      return null;
    }
  }

  List<Country> getBordersCountries(Country country) {
    return country.borders
        .map((code) => getCountryByCode(code))
        .whereType<Country>()
        .toList();
  }

  void _applyFilters({bool notify = true}) {
    _countries = _allCountries.where((country) {
      final matchesRegion =
          _selectedRegion == 'All Regions' || country.region == _selectedRegion;

      final matchesSearch =
          _searchQuery.isEmpty ||
          country.name.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesRegion && matchesSearch;
    }).toList();

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> loadCountries() async {
    setLoading(true);
    clearError();

    try {
      _allCountries = await _apiService.fetchCountries();
      _applyFilters(notify: false);
    } catch (error) {
      setError(handleError(error));
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadRegions() async {
    clearError();

    try {
      final regions = await _apiService.fetchRegions();

      _regions = ['All Regions', ...regions];
    } catch (error) {
      setError(handleError(error));
    }

    notifyListeners();
  }

  void resetFilters() {
    _selectedRegion = 'All Regions';
    _searchQuery = '';

    _applyFilters();
  }
}
