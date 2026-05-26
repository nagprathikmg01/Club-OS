import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/event.dart';
import '../../providers/data_provider.dart';
import '../../widgets/event_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/neon_bottom_sheet.dart';
import '../../widgets/detail_sheet.dart';
import '../../widgets/nebula_rank_board.dart';
import '../../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
            begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final events = dataProvider.events;
    final isAdmin = dataProvider.isAdmin;
    final club = dataProvider.activeClub;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ClubOsTheme.primaryLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: ClubOsTheme.successGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  club.name.toUpperCase(),
                                  style: TextStyle(
                                    color: ClubOsTheme.primaryCommand,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Activity\nFeed',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: ClubOsTheme.onSurfaceMain,
                          letterSpacing: -2,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Latest dispatches & upcoming events',
                        style: TextStyle(
                          fontSize: 14,
                          color: ClubOsTheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats row
                      _buildStatsRow(dataProvider),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Search Bar ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => dataProvider.updateSearchQuery(v),
                style: TextStyle(
                    color: ClubOsTheme.onSurfaceMain, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search events & dispatches...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: ClubOsTheme.onSurfaceVariant, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: ClubOsTheme.onSurfaceVariant, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            dataProvider.updateSearchQuery('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: ClubOsTheme.solarSurfaceLowest,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: ClubOsTheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: ClubOsTheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: ClubOsTheme.primaryCommand, width: 2),
                  ),
                ),
              ),
            ),
          ),

          // ── Rank Board ─────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: NebulaRankBoard(),
            ),
          ),

          // ── Section Label ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
              child: Row(
                children: [
                  Text(
                    'UPCOMING EVENTS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: ClubOsTheme.onSurfaceVariant,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: ClubOsTheme.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${events.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ClubOsTheme.primaryCommand,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Event List ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: events.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: NeonEmptyState(
                      title: 'No Events Yet',
                      message:
                          'Seed the demo data or create your first event.',
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return _AnimatedListItem(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () => _showDetail(context, event),
                              child: EventCard(event: event),
                            ),
                          ),
                        );
                      },
                      childCount: events.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddEventBottomSheet(context),
              backgroundColor: ClubOsTheme.primaryCommand,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'New Event',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildStatsRow(DataProvider dp) {
    final stats = [
      {'label': 'Members', 'value': '${dp.totalMembers}', 'icon': Icons.people_rounded, 'color': ClubOsTheme.primaryCommand},
      {'label': 'Events', 'value': '${dp.activeEvents}', 'icon': Icons.event_rounded, 'color': ClubOsTheme.secondaryIntelligence},
      {'label': 'Tasks Done', 'value': dp.taskCompletionRatePercent, 'icon': Icons.check_circle_rounded, 'color': ClubOsTheme.successGreen},
      {'label': 'Pending', 'value': '${dp.pendingTasksCount}', 'icon': Icons.pending_actions_rounded, 'color': ClubOsTheme.warningAmber},
    ];

    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ClubOsTheme.solarSurfaceLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ClubOsTheme.outlineVariant),
              boxShadow: ClubOsTheme.subtleShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(s['icon'] as IconData, size: 18, color: color),
                const SizedBox(height: 8),
                Text(
                  s['value'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  s['label'] as String,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: ClubOsTheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDetail(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailSheet(item: event),
    );
  }

  void _showAddEventBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    NeonBottomSheet.show(
      context: context,
      title: 'Create New Event',
      content: StatefulBuilder(
        builder: (context, setModal) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setModal(() => selectedDate = date);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: ClubOsTheme.solarSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ClubOsTheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        size: 18,
                        color: ClubOsTheme.primaryCommand),
                    const SizedBox(width: 10),
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: TextStyle(
                          fontSize: 14,
                          color: ClubOsTheme.onSurfaceMain,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      'CHANGE',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: ClubOsTheme.primaryCommand,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: TextStyle(color: ClubOsTheme.onSurfaceVariant)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final newEvent = Event(
                id: const Uuid().v4(),
                title: titleController.text,
                description: descController.text,
                date: selectedDate,
                imageUrl:
                    'https://images.unsplash.com/photo-1540575861501-7ad058c67a04?w=800',
                clubId:
                    context.read<DataProvider>().activeClubId,
              );
              context.read<DataProvider>().addEvent(newEvent);
              Navigator.pop(context);
            }
          },
          child: const Text('Publish Event'),
        ),
      ],
    );
  }
}

/// Staggered fade-in animation for each list item
class _AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _AnimatedListItem({required this.index, required this.child});

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 80),
        () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}
