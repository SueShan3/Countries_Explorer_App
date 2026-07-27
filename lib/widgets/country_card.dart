import 'package:flutter/material.dart';

class CountryCard extends StatelessWidget {
  final String name;
  final String capital;
  final String flagUrl;
  final String? note;
  final Widget? trailing;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.name,
    required this.capital,
    required this.flagUrl,
    this.note,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          flagUrl,
          width: 70,
          height: 45,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 70,
              height: 45,
              color: Colors.grey[300],
              child: const Icon(Icons.flag, color: Colors.grey),
            );
          },
        ),
      ),
      title: Text(name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(capital, style: Theme.of(context).textTheme.titleSmall),

          if (note != null && note!.isNotEmpty)
            Text(
              note!,
              style: TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
