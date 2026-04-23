import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../widgets/stat_tile.dart';
import '../../widgets/neon_card.dart';
import '../../widgets/neon_line_chart.dart';
import '../../models/membership_request.dart';
import '../../theme.dart';

class LeaderDashboardScreen extends StatelessWidget {
  const LeaderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        title: Text(
          'COMMAND CENTER',
          style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ClubOsTheme.gutterLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club Join Code Box
              _buildBentoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NETWORK ACCESS KEY', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          dataProvider.activeClub.joinCode.isEmpty ? 'PENDING...' : dataProvider.activeClub.joinCode.toUpperCase(),
                          style: const TextStyle(color: ClubOsTheme.primaryCommand, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 6),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_all, color: ClubOsTheme.primaryCommand),
                      onPressed: () {
                        final code = dataProvider.activeClub.joinCode;
                        if (code.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('KEY COPIED TO CLIPBOARD'), backgroundColor: ClubOsTheme.primaryCommand),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'COLLECTIVE METRICS',
                style: ClubOsTheme.lightTheme.textTheme.labelSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                   _buildStatTile('MEMBERS', dataProvider.totalMembers.toString(), Icons.people_outline, ClubOsTheme.primaryCommand),
                   _buildStatTile('OPS ACTIVE', dataProvider.pendingTasksCount.toString(), Icons.analytics_outlined, ClubOsTheme.tertiaryAnalytical),
                   _buildStatTile('EVENTS', dataProvider.activeEvents.toString(), Icons.grid_view_outlined, ClubOsTheme.secondaryIntelligence),
                   _buildStatTile('HEALTH', dataProvider.taskCompletionRatePercent, Icons.bolt_outlined, Colors.green.shade600),
                ],
              ),
              const SizedBox(height: 32),
              
              Text(
                'TEMPORAL PERFORMANCE',
                style: ClubOsTheme.lightTheme.textTheme.labelSmall,
              ),
              const SizedBox(height: 16),
              _buildBentoCard(
                child: const Column(
                  children: [
                     NeonLineChart(
                      dataPoints: [20, 35, 28, 45, 60, 55, 75],
                      height: 180,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text('MON', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('TUE', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('WED', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('THU', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('FRI', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('SAT', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                         Text('SUN', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              Text(
                'CLEARANCE REQUESTS',
                style: ClubOsTheme.lightTheme.textTheme.labelSmall,
              ),
              const SizedBox(height: 16),
              
              if (dataProvider.pendingRequests.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Text('NO PENDING CLEARANCES', style: TextStyle(color: ClubOsTheme.onSurfaceVariant.withOpacity(0.5), letterSpacing: 1, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataProvider.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = dataProvider.pendingRequests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBentoCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: ClubOsTheme.solarSurfaceLow,
                              child: Text(request.userName[0].toUpperCase(), style: const TextStyle(color: ClubOsTheme.primaryCommand)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(request.userName, style: const TextStyle(color: ClubOsTheme.onSurfaceMain, fontWeight: FontWeight.bold)),
                                  Text(request.userEmail.toLowerCase(), style: const TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text('REQUESTED: ${request.requestedAt.hour}:${request.requestedAt.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 9, color: ClubOsTheme.tertiaryAnalytical, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showRoleSelectionDialog(context, dataProvider, request.userId, request.userName);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: ClubOsTheme.primaryCommand,
                              ),
                              child: const Text('APPROVE', style: TextStyle(fontSize: 10, letterSpacing: 1)),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context, DataProvider provider, String userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ClubOsTheme.solarSurfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('ASSIGN CLEARANCE ROLE', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assign system role for $userName:', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 24),
            _buildRoleOption(context, provider, userId, 'MEMBER', 'Standard operational access.'),
            _buildRoleOption(context, provider, userId, 'DOMAIN HEAD', 'Strategic oversight of specific sectors.'),
            _buildRoleOption(context, provider, userId, 'CLUB LEADER', 'Full command and administrative authority.'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption(BuildContext context, DataProvider provider, String userId, String role, String description) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      title: Text(role, style: const TextStyle(fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand, fontSize: 13, letterSpacing: 1)),
      subtitle: Text(description, style: const TextStyle(fontSize: 10, color: ClubOsTheme.onSurfaceVariant)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: ClubOsTheme.primaryCommand),
      onTap: () {
        provider.approveRequest(userId, role);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role ACCESS GRANTED'), backgroundColor: ClubOsTheme.primaryCommand),
        );
      },
    );
  }

  Widget _buildBentoCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return _buildBentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(icon, color: color.withOpacity(0.6), size: 20),
           const SizedBox(height: 12),
           Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceMain)),
           const SizedBox(height: 4),
           Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant, letterSpacing: 1)),
        ],
      ),
    );
  }
}
