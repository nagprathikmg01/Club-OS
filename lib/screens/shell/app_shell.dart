import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../home/home_screen.dart';
import '../tasks/task_board_screen.dart';
import '../dashboard/leader_dashboard_screen.dart';
import '../analytics/intelligence_overview_screen.dart';
import '../governance/archives_screen.dart';
import '../join_club_screen.dart';
import '../chat/chat_screen.dart';
import '../club/club_profile_screen.dart';
import '../../theme.dart';
import '../../models/club.dart';
import '../club/create_club_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TaskBoardScreen(),
    const ChatScreen(),
    const IntelligenceOverviewScreen(), // NEW
    const ArchivesScreen(),             // NEW
    const ClubProfileScreen(),
    const LeaderDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final currentUser = dataProvider.currentUser;
    final isAdmin = dataProvider.isAdmin;
    final bool isDesktop = MediaQuery.of(context).size.width > 1000;

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: ClubOsTheme.solarBase,
        body: Center(child: CircularProgressIndicator(color: ClubOsTheme.primaryCommand)),
      );
    }
    
    if (currentUser.currentClubId == null || currentUser.currentClubId!.isEmpty || currentUser.status == 'pending') {
      return const JoinClubScreen();
    }

    // Adjust selected index if admin-only screen is selected by non-admin
    if (!isAdmin && _selectedIndex == 6) {
      _selectedIndex = 0;
    }

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
               // Club Switcher
              PopupMenuButton<String>(
                offset: const Offset(0, 50),
                color: ClubOsTheme.solarSurfaceLowest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.2))),
                onSelected: (String clubId) {
                  if (clubId == 'CREATE_NEW') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateClubScreen()));
                  } else {
                    dataProvider.switchClub(clubId);
                  }
                },
                child: Row(
                  children: [
                    Text(
                      dataProvider.activeClub.name.toUpperCase(),
                      style: ClubOsTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: ClubOsTheme.primaryCommand,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, color: ClubOsTheme.primaryCommand, size: 18),
                  ],
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    ...dataProvider.clubs.map((club) => PopupMenuItem<String>(
                      value: club.id,
                      child: Row(
                        children: [
                           Icon(
                             club.id == dataProvider.activeClubId ? Icons.radio_button_checked : Icons.radio_button_off,
                             color: ClubOsTheme.primaryCommand,
                             size: 16,
                           ),
                           const SizedBox(width: 12),
                           Text(club.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'CREATE_NEW',
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: ClubOsTheme.tertiaryAnalytical, size: 16),
                          SizedBox(width: 12),
                          Text('CREATE NEW CLUB', style: TextStyle(color: ClubOsTheme.tertiaryAnalytical, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              const Spacer(),
              _buildRoleBadge(currentUser.role.toUpperCase()),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => dataProvider.signOut(),
                icon: const Icon(Icons.logout_rounded, color: ClubOsTheme.onSurfaceVariant, size: 20),
                tooltip: 'SIGN OUT',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: ClubOsTheme.solarSurfaceLow,
                border: Border(right: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1))),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSidebarItem(0, Icons.feed_outlined, 'FEED'),
                        _buildSidebarItem(1, Icons.dashboard_customize_outlined, 'TASKS'),
                        _buildSidebarItem(2, Icons.chat_bubble_outline, 'CHAT'),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.black12)),
                        _buildSidebarItem(3, Icons.psychology_outlined, 'INTELLIGENCE'),
                        _buildSidebarItem(4, Icons.inventory_2_outlined, 'ARCHIVES'),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.black12)),
                        _buildSidebarItem(5, Icons.person_outline, 'PROFILE'),
                        if (isAdmin)
                          _buildSidebarItem(6, Icons.analytics_outlined, 'LEADERS'),
                      ],
                    ),
                  ),
                  _buildSidebarFooter(),
                ],
              ),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<int>(_selectedIndex),
                child: _screens[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(isAdmin),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [BoxShadow(color: ClubOsTheme.primaryCommand.withOpacity(0.05), blurRadius: 10)] : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ClubOsTheme.primaryCommand : ClubOsTheme.onSurfaceVariant, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? ClubOsTheme.primaryCommand : ClubOsTheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarFooter() {
    final dataProvider = context.read<DataProvider>();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.primaryCommand.withOpacity(0.02),
        border: const Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, size: 16, color: ClubOsTheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Text('DOCUMENTATION', style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => dataProvider.signOut(),
            child: Row(
              children: [
                const Icon(Icons.logout_rounded, size: 16, color: Colors.redAccent),
                const SizedBox(width: 12),
                const Text('TERMINATE SESSION', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String roleLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ClubOsTheme.primaryCommand.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ClubOsTheme.primaryCommand.withOpacity(0.2)),
      ),
      child: Text(
        roleLabel,
        style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(fontSize: 9),
      ),
    );
  }

  Widget _buildBottomNav(bool isAdmin) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      backgroundColor: ClubOsTheme.solarSurfaceLowest,
      selectedItemColor: ClubOsTheme.primaryCommand,
      unselectedItemColor: ClubOsTheme.onSurfaceVariant,
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.feed_outlined), label: 'FEED'),
        const BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: 'TASKS'),
        const BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'INTEL'),
        const BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'ARCHIVE'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
      ],
    );
  }
}
