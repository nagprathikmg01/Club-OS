import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../theme.dart';

class EventCard extends StatefulWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _shadow;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween(begin: 1.0, end: 1.025).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _shadow = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _ctrl.forward();
  }

  void _onExit() {
    setState(() => _hovered = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final daysUntil = widget.event.date.difference(DateTime.now()).inDays;
    final isUrgent = daysUntil <= 3;

    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: ClubOsTheme.solarSurfaceLowest,
              borderRadius: BorderRadius.circular(ClubOsTheme.radiusLg),
              border: Border.all(
                color: _hovered
                    ? ClubOsTheme.primaryCommand.withOpacity(0.25)
                    : ClubOsTheme.outlineVariant,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: ClubOsTheme.primaryCommand.withOpacity(0.12),
                          blurRadius: 32,
                          offset: const Offset(0, 8)),
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2)),
                    ]
                  : ClubOsTheme.subtleShadow,
            ),
            child: child,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image ──────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ClubOsTheme.radiusLg)),
                  child: Image.network(
                    widget.event.imageUrl ??
                        'https://images.unsplash.com/photo-1540575861501-7ad058c67a04?w=800',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) => progress == null
                        ? child
                        : Container(
                            height: 180,
                            color: ClubOsTheme.solarSurfaceLow,
                            child: Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ClubOsTheme.primaryCommand)),
                          ),
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: ClubOsTheme.primaryLight,
                      child: Icon(Icons.image_outlined,
                          color: ClubOsTheme.primaryCommand, size: 40),
                    ),
                  ),
                ),
                // gradient overlay
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(ClubOsTheme.radiusLg)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Date badge
                Positioned(
                  top: 14,
                  right: 14,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? ClubOsTheme.errorRed
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: ClubOsTheme.subtleShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 11,
                          color: isUrgent
                              ? Colors.white
                              : ClubOsTheme.primaryCommand,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(widget.event.date).toUpperCase(),
                          style: TextStyle(
                            color: isUrgent
                                ? Colors.white
                                : ClubOsTheme.primaryCommand,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Days pill
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      daysUntil <= 0
                          ? 'TODAY'
                          : daysUntil == 1
                              ? 'TOMORROW'
                              : 'IN $daysUntil DAYS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: ClubOsTheme.primaryLight,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      'EVENT',
                      style: TextStyle(
                        color: ClubOsTheme.primaryCommand,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Text(
                    widget.event.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: ClubOsTheme.onSurfaceMain,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: TextStyle(
                      color: ClubOsTheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.55,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: ClubOsTheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'NMIT BANGALORE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: ClubOsTheme.onSurfaceVariant,
                            letterSpacing: 0.5),
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _hovered
                              ? ClubOsTheme.primaryCommand
                              : ClubOsTheme.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'VIEW',
                              style: TextStyle(
                                color: _hovered
                                    ? Colors.white
                                    : ClubOsTheme.primaryCommand,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: _hovered
                                  ? Colors.white
                                  : ClubOsTheme.primaryCommand,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
