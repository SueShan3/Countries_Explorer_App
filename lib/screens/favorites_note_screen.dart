import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorite_country.dart';
import '../providers/favourite_provider.dart';

class FavoritesNoteScreen extends StatefulWidget {
  static const routeName = '/favorite-note';

  const FavoritesNoteScreen({super.key});

  @override
  State<FavoritesNoteScreen> createState() => _FavoritesNoteScreenState();
}

class _FavoritesNoteScreenState extends State<FavoritesNoteScreen> {
  FavoriteCountry? _favoriteInfo;
  final _noteController = TextEditingController();
  static const maxLength = 200;
  bool _isInit = true;

  bool get _hasChanges {
    final current = _noteController.text.trim();
    final original = _favoriteInfo?.note?.trim() ?? '';

    return current != original;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final code = ModalRoute.of(context)!.settings.arguments as String;
      _favoriteInfo = context.read<FavouriteProvider>().getFavoriteCountry(
        code,
      );

      _noteController.text = _favoriteInfo?.note ?? '';

      _noteController.addListener(_onNoteChanged);

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged() {
    setState(() {});
  }

  Future<void> _saveNote() async {
    if (_favoriteInfo == null) return;

    final provider = context.read<FavouriteProvider>();

    final note = _noteController.text.trim();

    final success = await provider.updateNote(
      _favoriteInfo!.code,
      note.isEmpty ? null : note,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
      provider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _favoriteInfo!.flagUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.flag, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _favoriteInfo!.name,
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      Text(
                        _favoriteInfo!.capital,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text(
              'My Note',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 6,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: 'Write something about this country...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hasChanges ? _saveNote : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(
                  'SAVE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
