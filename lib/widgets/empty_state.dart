import 'package:flutter/material.dart';
import '../theme.dart';
import 'neon_card.dart';

class NeonEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const NeonEmptyState({
    super.key,
    required this.title,
    this.message = 'Try adjusting your search or filters.',
    this.icon = Icons.search_off_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: NeonCard(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ClubOsTheme.primaryCommand.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: ClubOsTheme.primaryCommand,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: ClubOsTheme.onSurfaceMain,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: ClubOsTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
