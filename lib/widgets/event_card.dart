import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../theme.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  event.imageUrl ?? 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    width: double.infinity,
                    color: ClubOsTheme.primaryCommand.withOpacity(0.05),
                    child: const Icon(Icons.image, color: ClubOsTheme.primaryCommand, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(
                    DateFormat('MMM dd').format(event.date).toUpperCase(),
                    style: const TextStyle(
                      color: ClubOsTheme.primaryCommand,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ClubOsTheme.onSurfaceMain,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: const TextStyle(
                    color: ClubOsTheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: ClubOsTheme.primaryCommand),
                    const SizedBox(width: 4),
                    const Text('MAIN CAMPUS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant, letterSpacing: 0.5)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ClubOsTheme.primaryCommand.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios, size: 10, color: ClubOsTheme.primaryCommand),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
