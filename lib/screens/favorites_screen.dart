import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favourite_provider.dart';
import '../widgets/country_card.dart';
import './favorites_note_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      context.read<FavouriteProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavouriteProvider>();
    final favorites = favoriteProvider.favoriteCountries;

    if (favoriteProvider.errorMessage != null && favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            favoriteProvider.errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No favourite countries yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add countries to your favourites to see them here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: favorites.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1),
      itemBuilder: (ctx, i) {
        final country = favorites[i];

        return Dismissible(
          key: ValueKey(country.code),

          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Remove favourite?'),
                content: Text(
                  'Are you sure you want to remove ${country.name} from your favourites?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );

            if (confirmed != true) return false;
            if (!context.mounted) return false;

            final provider = context.read<FavouriteProvider>();
            final success = await provider.removeFavorite(country.code);

            if (!success && context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
              provider.clearError();
            }

            return success;
          },
          onDismissed: (_) {},
          child: CountryCard(
            name: country.name,
            capital: country.capital,
            flagUrl: country.flagUrl,
            note: country.note?.isNotEmpty == true
                ? country.note
                : 'No notes added yet',
            onTap: () async {
              final result = await Navigator.of(context).pushNamed(
                FavoritesNoteScreen.routeName,
                arguments: country.code,
              );

              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note saved successfully')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
