import 'package:flutter/material.dart';

class SearchBottomSheet extends StatelessWidget {
  const SearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Search')),
          body: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16),
            children: [
              const _FieldTile(
                icon: Icons.place_outlined,
                title: 'Where',
                subtitle: 'Search destinations',
              ),
              const SizedBox(height: 12),
              const _FieldTile(
                icon: Icons.calendar_month_outlined,
                title: 'When',
                subtitle: 'Add dates',
              ),
              const SizedBox(height: 12),
              const _FieldTile(
                icon: Icons.people_outline,
                title: 'Who',
                subtitle: 'Add guests',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Show places'),
              )
            ],
          ),
        );
      },
    );
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FieldTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
