import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/event.dart';
import '../../providers/data_provider.dart';
import '../../widgets/event_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/neon_bottom_sheet.dart';
import '../../widgets/detail_sheet.dart';
import '../../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final events = dataProvider.events;
    final isAdmin = dataProvider.isAdmin;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: ClubOsTheme.solarBase,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'LATEST UPDATES',
                style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 2,
                  fontSize: 10,
                ),
              ),
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge),
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Text(
                    'The Feed',
                    style: ClubOsTheme.lightTheme.textTheme.displayLarge?.copyWith(fontSize: 48),
                  ),
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: ClubOsTheme.gutterLarge, bottom: 20),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(ClubOsTheme.gutterLarge, 0, ClubOsTheme.gutterLarge, 32),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => dataProvider.updateSearchQuery(value),
                style: const TextStyle(color: ClubOsTheme.onSurfaceMain, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'SEARCH DISPATCHES...',
                  hintStyle: const TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 10, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.search, color: ClubOsTheme.onSurfaceVariant, size: 18),
                  filled: true,
                  fillColor: ClubOsTheme.solarSurfaceLow.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge),
            sliver: events.isEmpty 
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: NeonEmptyState(
                    title: 'NO DISPATCHES FOUND',
                    message: 'Your search criteria returned an empty void.',
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _showDetail(context, event),
                          child: EventCard(event: event),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddEventBottomSheet(context),
              backgroundColor: ClubOsTheme.primaryCommand,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('NEW DISPATCH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            )
          : null,
    );
  }

  void _showDetail(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailSheet(item: event),
    );
  }

  void _showAddEventBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    NeonBottomSheet.show(
      context: context,
      title: 'Post Dispatch',
      content: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'TITLE',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'DESCRIPTION',
                ),
              ),
              const SizedBox(height: 24),
              Text('EVENT DATE', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setModalState(() => selectedDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ClubOsTheme.solarSurfaceLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: ClubOsTheme.onSurfaceMain),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('DISCARD', style: TextStyle(color: ClubOsTheme.onSurfaceVariant)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final newEvent = Event(
                id: const Uuid().v4(),
                title: titleController.text,
                description: descController.text,
                date: selectedDate,
                imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
                clubId: context.read<DataProvider>().activeClubId,
              );
              context.read<DataProvider>().addEvent(newEvent);
              Navigator.pop(context);
            }
          },
          child: const Text('PUBLISH'),
        ),
      ],
    );
  }
}
