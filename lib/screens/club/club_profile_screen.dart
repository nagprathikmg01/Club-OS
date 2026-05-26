import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../widgets/neon_card.dart';
import 'member_detail_screen.dart';

class ClubProfileScreen extends StatelessWidget {
  const ClubProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    final activeClub = provider.activeClub;
    final members = provider.clubMembers;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: ClubOsTheme.solarSurfaceLowest,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                activeClub.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 2,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    activeClub.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://images.unsplash.com/photo-1522071823907-f6fcb0606d1c?q=80&w=1000&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, ClubOsTheme.primaryCommand.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(ClubOsTheme.gutterLarge),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'CLUB OVERVIEW',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                _buildBentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activeClub.description, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildStat(context, 'MEMBERS', activeClub.memberCount.toString()),
                          const SizedBox(width: 32),
                          _buildStat(context, 'EVENTS', provider.activeEvents.toString()),
                          const SizedBox(width: 32),
                          _buildStat(context, 'AVAILABILITY', provider.taskCompletionRatePercent),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'ROSTER',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                ...members.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemberDetailScreen(member: m)),
                    ),
                    child: _buildBentoCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: m.role == 'admin' ? ClubOsTheme.primaryCommand : ClubOsTheme.solarSurfaceLow,
                            child: Text(
                              m.name[0].toUpperCase(),
                              style: TextStyle(color: m.role == 'admin' ? Colors.white : ClubOsTheme.onSurfaceMain),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name, style: TextStyle(fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceMain)),
                                Text(m.email.toLowerCase(), style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: m.role == 'admin' ? ClubOsTheme.primaryCommand.withOpacity(0.1) : Colors.transparent,
                              border: Border.all(color: m.role == 'admin' ? ClubOsTheme.primaryCommand.withOpacity(0.2) : ClubOsTheme.outlineVariant.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              m.role.toUpperCase(),
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: m.role == 'admin' ? ClubOsTheme.primaryCommand : ClubOsTheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 32),
                Text(
                  'MANAGED NETWORKS',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                ...provider.clubs.map((club) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildBentoCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            club.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50, height: 50,
                              color: ClubOsTheme.primaryCommand.withOpacity(0.05),
                              child: Icon(Icons.business, color: ClubOsTheme.primaryCommand, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(club.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceMain, fontSize: 13)),
                              Text('SYNC CODE: ${club.joinCode}', style: TextStyle(fontSize: 10, color: ClubOsTheme.tertiaryAnalytical, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ],
                          ),
                        ),
                        if (club.id == provider.activeClubId)
                          Icon(Icons.check_circle, color: ClubOsTheme.primaryCommand, size: 20)
                        else
                          TextButton(
                            onPressed: () => provider.switchClub(club.id),
                            child: Text('SWITCH', style: TextStyle(color: ClubOsTheme.primaryCommand, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => provider.signOut(),
                    icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                    label: const Text('TERMINATE SESSION', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 64),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard({required Widget child, EdgeInsets? padding}) {
    return NeonCard(
      padding: padding ?? const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 9, color: ClubOsTheme.onSurfaceVariant, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }
}
