import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../theme.dart';

class NebulaRankBoard extends StatefulWidget {
  const NebulaRankBoard({super.key});

  @override
  State<NebulaRankBoard> createState() => _NebulaRankBoardState();
}

class _NebulaRankBoardState extends State<NebulaRankBoard>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<Offset>> _slideAnims;
  late List<Animation<double>> _fadeAnims;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _slideAnims = List.generate(
        3,
        (i) => Tween<Offset>(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _entryCtrl,
              curve: Interval(i * 0.15, 0.6 + i * 0.15,
                  curve: Curves.easeOutCubic),
            )));

    _fadeAnims = List.generate(
        3,
        (i) => Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(i * 0.15, 0.6 + i * 0.15, curve: Curves.easeOut),
        )));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final members = List.from(dataProvider.clubMembers)
      ..sort((a, b) {
        if (b.level != a.level) return b.level.compareTo(a.level);
        return b.xp.compareTo(a.xp);
      });

    final topMembers = members.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(ClubOsTheme.radiusLg),
        border: Border.all(color: ClubOsTheme.outlineVariant),
        boxShadow: ClubOsTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEBULA LEADERBOARD',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        color: ClubOsTheme.primaryCommand.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Top Contributors',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ClubOsTheme.onSurfaceMain,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A56DB), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'LIVE RANKING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── Podium ────────────────────────────────────────────
          if (topMembers.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.people_outline,
                      size: 40,
                      color: ClubOsTheme.onSurfaceVariant.withOpacity(0.4)),
                  const SizedBox(height: 12),
                  Text(
                    'NO MEMBERS YET',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ClubOsTheme.onSurfaceVariant,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(topMembers.length, (i) {
                // Reorder: 2nd, 1st, 3rd visually
                final displayOrder = topMembers.length == 3
                    ? [1, 0, 2]
                    : List.generate(topMembers.length, (j) => j);
                final idx = displayOrder[i];
                final member = topMembers[idx];
                final rank = idx + 1;

                final animIdx = i < _slideAnims.length ? i : 0;

                return FadeTransition(
                  opacity: _fadeAnims[animIdx],
                  child: SlideTransition(
                    position: _slideAnims[animIdx],
                    child: _PodiumTile(
                      member: member,
                      rank: rank,
                      isChampion: rank == 1,
                    ),
                  ),
                );
              }),
            ),

          // ── Progress bar for each ──────────────────────────────
          if (topMembers.isNotEmpty) ...[
            const SizedBox(height: 24),
            Divider(color: ClubOsTheme.dividerColor),
            const SizedBox(height: 16),
            ...topMembers.take(3).toList().asMap().entries.map((e) {
              final m = e.value;
              final pct = ((m.xp % 1000) / 1000).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _XpProgressRow(
                  name: m.name.split(' ').first,
                  xp: m.xp,
                  level: m.level,
                  pct: pct,
                  rank: e.key + 1,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _PodiumTile extends StatelessWidget {
  final dynamic member;
  final int rank;
  final bool isChampion;

  const _PodiumTile({
    required this.member,
    required this.rank,
    required this.isChampion,
  });

  Color get _rankColor {
    switch (rank) {
      case 1: return const Color(0xFFF59E0B);
      case 2: return const Color(0xFF94A3B8);
      default: return const Color(0xFFCD7C3A);
    }
  }

  IconData get _rankIcon {
    switch (rank) {
      case 1: return Icons.emoji_events_rounded;
      case 2: return Icons.military_tech_rounded;
      default: return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isChampion)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Icon(_rankIcon, color: _rankColor, size: 22),
          ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isChampion ? 72 : 58,
              height: isChampion ? 72 : 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _rankColor, width: isChampion ? 3 : 2),
                boxShadow: isChampion
                    ? [BoxShadow(color: _rankColor.withOpacity(0.3), blurRadius: 16)]
                    : null,
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _rankColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          member.name.split(' ').first.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: isChampion ? 12 : 10,
            color: ClubOsTheme.onSurfaceMain,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _rankColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'LVL ${member.level}',
            style: TextStyle(
              color: _rankColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _XpProgressRow extends StatefulWidget {
  final String name;
  final int xp;
  final int level;
  final double pct;
  final int rank;

  const _XpProgressRow({
    required this.name,
    required this.xp,
    required this.level,
    required this.pct,
    required this.rank,
  });

  @override
  State<_XpProgressRow> createState() => _XpProgressRowState();
}

class _XpProgressRowState extends State<_XpProgressRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(Duration(milliseconds: 400 + widget.rank * 100), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            widget.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ClubOsTheme.onSurfaceMain,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _anim.value * widget.pct,
                backgroundColor: ClubOsTheme.solarSurfaceLow,
                valueColor: AlwaysStoppedAnimation(ClubOsTheme.primaryCommand),
                minHeight: 6,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${widget.xp} XP',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: ClubOsTheme.primaryCommand,
          ),
        ),
      ],
    );
  }
}
