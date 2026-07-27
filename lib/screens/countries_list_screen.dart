import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/country_provider.dart';
import '../screens/country_detail_screen.dart';
import '../widgets/country_card.dart';
import '../widgets/country_dropdown.dart';
import '../widgets/country_search_bar.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final provider = context.read<CountryProvider>(); // API call once

      provider.resetFilters();

      await Future.wait([provider.loadRegions(), provider.loadCountries()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final countriesProvider = context.watch<CountryProvider>(); // UI update

    return Column(
      children: [
        const CountrySearchBar(),
        CountryDropdown(
          value: countriesProvider.selectedRegion,
          items: countriesProvider.regions,
          onChanged: (value) {
            if (value != null) {
              countriesProvider.setSelectedRegion(value);
            }
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: (countriesProvider.isLoading)
              ? const Center(child: CircularProgressIndicator())
              : (countriesProvider.errorMessage != null)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      countriesProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : (countriesProvider.countries.isEmpty)
              ? Center(
                  child: Text(
                    countriesProvider.searchQuery.isNotEmpty
                        ? 'No countries match your search'
                        : 'No countries available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: countriesProvider.countries.length,
                  itemBuilder: (ctx, i) {
                    final country = countriesProvider.countries[i];
                    return CountryCard(
                      name: country.name,
                      capital: country.capital,
                      flagUrl: country.flagUrl,
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          CountryDetailScreen.routeName,
                          arguments: country.code,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
