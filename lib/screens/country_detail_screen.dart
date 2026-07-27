import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/country_info_item.dart';
import '../providers/country_provider.dart';
import '../providers/favourite_provider.dart';
import '../utils/format_utils.dart';
import '../widgets/border_country_tile.dart';
import '../widgets/country_info.dart';

class CountryDetailScreen extends StatelessWidget {
  static const routeName = '/country-detail';

  const CountryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countryCode = ModalRoute.of(context)!.settings.arguments as String;
    final country = context.read<CountryProvider>().getCountryByCode(
      countryCode,
    );

    if (country == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Country not found')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Sorry, we could\'t find details for this country.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final borderCountries = context.read<CountryProvider>().getBordersCountries(
      country,
    );
    final favoriteProvider = context.watch<FavouriteProvider>();
    final isFav = favoriteProvider.isFavorite(countryCode);

    final infos = [
      CountryInfoItem(
        icon: Icons.people_outlined,
        title: 'Population',
        value: FormatUtils.formatNumber(country.population),
      ),
      CountryInfoItem(
        icon: Icons.square_foot_outlined,
        title: 'Area',
        value: FormatUtils.formatArea(country.area),
      ),
      CountryInfoItem(
        icon: Icons.monetization_on_outlined,
        title: 'Currencies',
        value: country.currencies
            .map(
              (currency) =>
                  '${currency.name} (${currency.code} ${currency.symbol})',
            )
            .join(', '),
      ),
      CountryInfoItem(
        icon: Icons.language_outlined,
        title: 'Languages',
        value: country.languages.join(', '),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          IconButton(
            onPressed: () async {
              await favoriteProvider.toggleFavorite(country);

              if (favoriteProvider.errorMessage != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(favoriteProvider.errorMessage!)),
                );
                favoriteProvider.clearError();
              }
            },
            icon: Icon(
              size: 30,
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 230,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    country.flagUrl,
                    width: 230,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.flag, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                country.name,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Capital ~ ${country.capital}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Divider(height: 1),
            ),
            Column(
              children: infos
                  .map(
                    (info) => CountryInfo(
                      icon: info.icon,
                      title: info.title,
                      value: info.value,
                    ),
                  )
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Divider(height: 1),
            ),
            if (borderCountries.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bordering Countries',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: borderCountries.map((borderCountry) {
                      return BorderCountryTile(
                        name: borderCountry.name,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            CountryDetailScreen.routeName,
                            arguments: borderCountry.code,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
