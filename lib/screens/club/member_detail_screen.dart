import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_user.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../widgets/task_card.dart';

class MemberDetailScreen extends StatelessWidget {
  final AppUser member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    final stats = provider.getMemberTaskStats(member.uid);
    final userTasks = provider.tasks.where((t) => t.assigneeId == member.uid).toList();

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        title: Text(member.name.toUpperCase(), style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bio-Sync Header
            _buildBentoCard(
              child: Row(
                children: [
                   Container(
                     width: 80,
                     height: 80,
                     decoration: BoxDecoration(
                       color: ClubOsTheme.primaryCommand.withOpacity(0.05),
                       shape: BoxShape.circle,
                       border: Border.all(color: ClubOsTheme.primaryCommand.withOpacity(0.2)),
                     ),
                     child: Center(
                       child: Text(
                        member.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32, color: ClubOsTheme.primaryCommand, fontWeight: FontWeight.bold),
                      ),
                     ),
                   ),
                   const SizedBox(width: 24),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(member.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                         Text(member.email.toLowerCase(), style: const TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 13)),
                         const SizedBox(height: 12),
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ClubOsTheme.primaryCommand.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ClubOsTheme.primaryCommand.withOpacity(0.2)),
                          ),
                          child: Text(
                            member.role.toUpperCase(),
                            style: const TextStyle(color: ClubOsTheme.primaryCommand, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                       ],
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Operational Intelligence Section
            Text(
              'OPERATIONAL INTELLIGENCE',
              style: ClubOsTheme.lightTheme.textTheme.labelSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('ASSIGNED', stats['total'].toString(), ClubOsTheme.primaryCommand)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('PENDING', stats['pending'].toString(), ClubOsTheme.tertiaryAnalytical)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('VERIFIED', stats['completed'].toString(), Colors.green.shade600)),
              ],
            ),
            const SizedBox(height: 16),
            _buildBentoCard(
              child: Row(
                children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        const Text('SYNC PERFORMANCE', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(
                          '${(stats['efficiency'] * 100).toInt()}% READY',
                          style: const TextStyle(color: ClubOsTheme.primaryCommand, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                     ],
                   ),
                   const Spacer(),
                   CircularProgressIndicator(
                     value: stats['efficiency'].toDouble(),
                     strokeWidth: 6,
                     backgroundColor: ClubOsTheme.solarSurfaceLow,
                     color: ClubOsTheme.primaryCommand,
                   ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Activity Log
            Text(
              'DEPLOYMENT HISTORY',
              style: ClubOsTheme.lightTheme.textTheme.labelSmall,
            ),
            const SizedBox(height: 16),
            if (userTasks.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Text('NO ACTIVE DEPLOYMENTS FOUND', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ))
            else
              ...userTasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskCard(task: task),
              )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return _buildBentoCard(
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }
}
