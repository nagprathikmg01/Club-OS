import 'dart:ui';
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
import '../management/fiscal_observatory_screen.dart';
import '../management/vault_inventory_screen.dart';
import '../profile/elite_id_screen.dart';
import '../../services/seed_service.dart';
import '../../widgets/animated_page_wrapper.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _sidebarCtrl;
  late Animation<double> _sidebarFade;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _sidebarCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _sidebarFade = CurvedAnimation(parent: _sidebarCtrl, curve: Curves.easeOut);
    _sidebarCtrl.forward();
  }

  @override
  void dispose() {
    _sidebarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final currentUser = dataProvider.currentUser;
    final isAdmin = dataProvider.isAdmin;
    final bool isDesktop = MediaQuery.of(context).size.width > 1000;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: ClubOsTheme.solarBase,
        body: Center(
            child: CircularProgressIndicator(
                color: ClubOsTheme.primaryCommand, strokeWidth: 2)),
      );
    }

    if (currentUser.currentClubId == null ||
        currentUser.currentClubId!.isEmpty ||
        currentUser.status == 'pending') {
      return const JoinClubScreen();
    }

    if (!isAdmin && _selectedIndex == 6) _selectedIndex = 0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ClubOsTheme.solarBase,
      drawer: !isDesktop
          ? Drawer(
              child: Container(
                color: ClubOsTheme.solarSurfaceLowest,
                child: Column(
                  children: [
                    // Logo / Brand
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ClubOsTheme.primaryCommand,
                                    ClubOsTheme.secondaryIntelligence
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.hub_rounded,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'ClubOS',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19,
                                color: ClubOsTheme.onSurfaceMain,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: ClubOsTheme.dividerColor),
                    const SizedBox(height: 8),
                    // Navigation items
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _navSection('MAIN'),
                          _drawerNavItem(0, Icons.feed_rounded, 'Feed'),
                          _drawerNavItem(1, Icons.task_alt_rounded, 'Tasks'),
                          _drawerNavItem(2, Icons.chat_bubble_outline_rounded, 'Chat'),
                          const SizedBox(height: 8),
                          _navSection('INTELLIGENCE'),
                          _drawerNavItem(3, Icons.psychology_rounded, 'Intelligence'),
                          _drawerNavItem(4, Icons.inventory_2_rounded, 'Archives'),
                          const SizedBox(height: 8),
                          _navSection('PROFILE'),
                          _drawerNavItem(5, Icons.groups_rounded, 'Club Profile'),
                          _drawerNavItem(9, Icons.badge_rounded, 'Elite ID'),
                          const SizedBox(height: 8),
                          _navSection('MANAGEMENT'),
                          _drawerNavItem(7, Icons.account_balance_rounded, 'Fiscal Observatory'),
                          _drawerNavItem(8, Icons.warehouse_rounded, 'The Vault'),
                          if (isAdmin)
                            _drawerNavItem(6, Icons.leaderboard_rounded, 'Leaders'),
                        ],
                      ),
                    ),
                    _buildSidebarFooter(dataProvider, currentUser),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────────────────
          if (isDesktop)
            FadeTransition(
              opacity: _sidebarFade,
              child: Container(
                width: 260,
                decoration: BoxDecoration(
                  color: ClubOsTheme.solarSurfaceLowest,
                  border: Border(
                    right: BorderSide(color: ClubOsTheme.outlineVariant),
                  ),
                ),
                child: Column(
                  children: [
                    // ── Logo / Brand ───────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ClubOsTheme.primaryCommand,
                                  ClubOsTheme.secondaryIntelligence
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.hub_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ClubOS',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              color: ClubOsTheme.onSurfaceMain,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: ClubOsTheme.successGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'LIVE',
                              style: TextStyle(
                                color: ClubOsTheme.successGreen,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Club Switcher ──────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: PopupMenuButton<String>(
                        offset: const Offset(0, 50),
                        color: ClubOsTheme.solarSurfaceLowest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                              color: ClubOsTheme.outlineVariant),
                        ),
                        onSelected: (clubId) {
                          if (clubId == 'CREATE_NEW') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CreateClubScreen()));
                          } else {
                            dataProvider.switchClub(clubId);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: ClubOsTheme.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: ClubOsTheme.primaryCommand,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.corporate_fare_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  dataProvider.activeClub.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: ClubOsTheme.primaryCommand,
                                    letterSpacing: -0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.unfold_more_rounded,
                                  color: ClubOsTheme.primaryCommand, size: 16),
                            ],
                          ),
                        ),
                        itemBuilder: (_) => [
                          ...dataProvider.clubs.map((club) =>
                              PopupMenuItem<String>(
                                value: club.id,
                                child: Row(
                                  children: [
                                    Icon(
                                      club.id == dataProvider.activeClubId
                                          ? Icons.radio_button_checked_rounded
                                          : Icons.radio_button_off_rounded,
                                      color: ClubOsTheme.primaryCommand,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(club.name,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'CREATE_NEW',
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline_rounded,
                                    color: ClubOsTheme.tertiaryAnalytical,
                                    size: 16),
                                SizedBox(width: 10),
                                Text('Create New Club',
                                    style: TextStyle(
                                        color: ClubOsTheme.tertiaryAnalytical,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(color: ClubOsTheme.dividerColor),
                    ),
                    const SizedBox(height: 8),

                    // ── Navigation Items ───────────────────────
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _navSection('MAIN'),
                          _navItem(0, Icons.feed_rounded, 'Feed'),
                          _navItem(1, Icons.task_alt_rounded, 'Tasks'),
                          _navItem(2, Icons.chat_bubble_outline_rounded, 'Chat'),
                          const SizedBox(height: 8),
                          _navSection('INTELLIGENCE'),
                          _navItem(3, Icons.psychology_rounded, 'Intelligence'),
                          _navItem(4, Icons.inventory_2_rounded, 'Archives'),
                          const SizedBox(height: 8),
                          _navSection('PROFILE'),
                          _navItem(5, Icons.groups_rounded, 'Club Profile'),
                          _navItem(9, Icons.badge_rounded, 'Elite ID'),
                          const SizedBox(height: 8),
                          _navSection('MANAGEMENT'),
                          _navItem(7, Icons.account_balance_rounded,
                              'Fiscal Observatory'),
                          _navItem(8, Icons.warehouse_rounded, 'The Vault'),
                          if (isAdmin)
                            _navItem(6, Icons.leaderboard_rounded, 'Leaders'),
                        ],
                      ),
                    ),

                    // ── Footer ─────────────────────────────────
                    _buildSidebarFooter(dataProvider, currentUser),
                  ],
                ),
              ),
            ),

          // ── Main Content ─────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Trendy Glassmorphic Floating Top Header Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: ClubOsTheme.solarSurfaceLowest.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: ClubOsTheme.outlineVariant.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: ClubOsTheme.subtleShadow,
                        ),
                        child: Row(
                          children: [
                            if (!isDesktop) ...[
                              IconButton(
                                icon: Icon(Icons.menu_rounded, color: ClubOsTheme.onSurfaceMain),
                                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ClubOsTheme.primaryCommand.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ClubOS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: ClubOsTheme.primaryCommand,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Icon(Icons.widgets_outlined, size: 16, color: ClubOsTheme.onSurfaceVariant),
                              const SizedBox(width: 8),
                              Text(
                                'ClubOS',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: ClubOsTheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.chevron_right_rounded, size: 14, color: ClubOsTheme.onSurfaceVariant.withOpacity(0.5)),
                              const SizedBox(width: 6),
                              Text(
                                _getBreadcrumbName(_selectedIndex).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: ClubOsTheme.primaryCommand,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ClubOsTheme.successGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _BlinkingDot(),
                                    const SizedBox(width: 6),
                                    Text(
                                      dataProvider.activeClub.name.toUpperCase(),
                                      style: TextStyle(
                                        color: ClubOsTheme.successGreen,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            // Theme Toggle Button
                            IconButton(
                              onPressed: dataProvider.toggleTheme,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, anim) {
                                  return RotationTransition(
                                    turns: anim,
                                    child: FadeTransition(opacity: anim, child: child),
                                  );
                                },
                                child: Icon(
                                  dataProvider.isDarkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  key: ValueKey<bool>(dataProvider.isDarkMode),
                                  color: ClubOsTheme.primaryCommand,
                                  size: 20,
                                ),
                              ),
                            ),
                            // Notification center
                            Stack(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.notifications_none_rounded, color: ClubOsTheme.onSurfaceMain, size: 20),
                                  onPressed: () {},
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: ClubOsTheme.errorRed,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            // User Dropdown Action
                            PopupMenuButton<String>(
                              offset: const Offset(0, 42),
                              color: ClubOsTheme.solarSurfaceLowest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: ClubOsTheme.outlineVariant),
                              ),
                              onSelected: (val) {
                                if (val == 'logout') {
                                  dataProvider.signOut();
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [ClubOsTheme.primaryCommand, ClubOsTheme.secondaryIntelligence],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    (currentUser.name?.isNotEmpty == true)
                                        ? currentUser.name![0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              itemBuilder: (_) => [
                                PopupMenuItem<String>(
                                  value: 'profile',
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_outline_rounded, size: 16, color: ClubOsTheme.onSurfaceMain),
                                      const SizedBox(width: 8),
                                      Text('My Profile', style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceMain)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout_rounded, size: 16, color: ClubOsTheme.errorRed),
                                      const SizedBox(width: 8),
                                      Text('Sign Out', style: TextStyle(fontSize: 12, color: ClubOsTheme.errorRed)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.02, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedPageWrapper(
                      key: ValueKey<int>(_selectedIndex),
                      child: _getScreen(_selectedIndex),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : _buildBottomNav(isAdmin),
    );
  }

  Widget _navSection(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: ClubOsTheme.onSurfaceVariant,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ClubOsTheme.radiusSm),
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(ClubOsTheme.radiusSm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? ClubOsTheme.primaryCommand.withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(ClubOsTheme.radiusSm),
              border: isSelected
                  ? Border.all(
                      color: ClubOsTheme.primaryCommand.withOpacity(0.15))
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ClubOsTheme.primaryCommand
                        : ClubOsTheme.solarSurfaceLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : ClubOsTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? ClubOsTheme.primaryCommand
                        : ClubOsTheme.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ClubOsTheme.primaryCommand,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter(DataProvider dp, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ClubOsTheme.dividerColor)),
      ),
      child: Column(
        children: [
          // User info row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ClubOsTheme.primaryCommand, ClubOsTheme.secondaryIntelligence],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    (user.name?.isNotEmpty == true)
                        ? user.name![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'User',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ClubOsTheme.onSurfaceMain,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.role.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: ClubOsTheme.primaryCommand,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: dp.signOut,
                icon: Icon(Icons.logout_rounded,
                    color: ClubOsTheme.onSurfaceVariant, size: 18),
                tooltip: 'Sign Out',
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Seed button
          Material(
            color: ClubOsTheme.tertiaryAnalytical.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                try {
                  await SeedService.seedData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('NMIT data initialized!'),
                        backgroundColor: ClubOsTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: ClubOsTheme.errorRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        size: 14,
                        color: ClubOsTheme.tertiaryAnalytical),
                    const SizedBox(width: 8),
                    Text(
                      'Seed Demo Data',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ClubOsTheme.tertiaryAnalytical,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? ClubOsTheme.primaryCommand : ClubOsTheme.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? ClubOsTheme.primaryCommand : ClubOsTheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        selectedTileColor: ClubOsTheme.primaryCommand.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ClubOsTheme.radiusSm)),
        onTap: () {
          Navigator.pop(context); // Close drawer
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  int _getBottomNavIndex() {
    switch (_selectedIndex) {
      case 0: return 0;
      case 1: return 1;
      case 3: return 2;
      case 8: return 3;
      case 9: return 4;
      default: return 0;
    }
  }

  void _onBottomNavTapped(int index) {
    int targetIndex = 0;
    switch (index) {
      case 0: targetIndex = 0; break;
      case 1: targetIndex = 1; break;
      case 2: targetIndex = 3; break;
      case 3: targetIndex = 8; break;
      case 4: targetIndex = 9; break;
    }
    setState(() => _selectedIndex = targetIndex);
  }

  Widget _buildBottomNav(bool isAdmin) {
    return BottomNavigationBar(
      currentIndex: _getBottomNavIndex(),
      onTap: _onBottomNavTapped,
      backgroundColor: ClubOsTheme.solarSurfaceLowest,
      selectedItemColor: ClubOsTheme.primaryCommand,
      unselectedItemColor: ClubOsTheme.onSurfaceVariant,
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.feed_rounded), label: 'Feed'),
        BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Intel'),
        BottomNavigationBarItem(icon: Icon(Icons.warehouse_rounded), label: 'Vault'),
        BottomNavigationBarItem(icon: Icon(Icons.badge_rounded), label: 'ID'),
      ],
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0: return const HomeScreen();
      case 1: return const TaskBoardScreen();
      case 2: return const ChatScreen();
      case 3: return const IntelligenceOverviewScreen();
      case 4: return const ArchivesScreen();
      case 5: return const ClubProfileScreen();
      case 6: return const LeaderDashboardScreen();
      case 7: return const FiscalObservatoryScreen();
      case 8: return const VaultInventoryScreen();
      case 9: return const EliteIdScreen();
      default: return const HomeScreen();
    }
  }

  String _getBreadcrumbName(int index) {
    switch (index) {
      case 0: return 'Feed';
      case 1: return 'Tasks';
      case 2: return 'Chat';
      case 3: return 'Intelligence';
      case 4: return 'Archives';
      case 5: return 'Profile';
      case 6: return 'Leaders';
      case 7: return 'Fiscal';
      case 8: return 'Vault';
      case 9: return 'Elite ID';
      default: return 'Home';
    }
  }
}

class _BlinkingDot extends StatefulWidget {
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: ClubOsTheme.successGreen,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
