import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../widgets/neon_card.dart';

class IntelligenceOverviewScreen extends StatelessWidget {
  const IntelligenceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Command Module Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INTELLIGENCE MODULE', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
                    const SizedBox(height: 8),
                    Text('NEURAL RESOURCE\nALLOCATION', style: ClubOsTheme.lightTheme.textTheme.displayLarge?.copyWith(fontSize: 40, height: 1.1)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ClubOsTheme.solarSurfaceLowest,
                    border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: ClubOsTheme.primaryCommand, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text('LIVE STREAM ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Bento Grid
            GridView.count(
              crossAxisCount: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1, // Will adjust child spans
              children: [
                // KPI 1: Threat Analysis (Span 5)
                // Note: GridView.count doesn't support colSpan easily, we'll use a Row/Column layout for true Bento
              ],
            ),

            // Layout as per Stitch Bento Design
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Threat Analysis Score
                Expanded(
                  flex: 5,
                  child: _buildBentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader('THREAT ANALYSIS SCORE', Icons.security),
                        const SizedBox(height: 32),
                        Center(child: _buildGauge('82', 'INTEGRITY')),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            _buildMiniStat('INTERNAL', '14%'),
                            _buildMiniStat('EXTERNAL', '68%'),
                            _buildMiniStat('DELTA', '+2.4%', color: ClubOsTheme.primaryCommand),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Resource Utilization Trends
                Expanded(
                  flex: 7,
                  child: _buildBentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildCardHeader('MEMBER RESOURCE LOAD', Icons.sensors, color: ClubOsTheme.secondaryIntelligence),
                         const SizedBox(height: 32),
                         const Text('WORKLOAD DISTRIBUTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                         const SizedBox(height: 24),
                         _buildBarChart(context.watch<DataProvider>().memberResourceAllocation),
                         const SizedBox(height: 24),
                         Row(
                           children: [
                             _buildMiniStat('ACTIVE ROSTER', context.watch<DataProvider>().totalMembers.toString()),
                             _buildMiniStat('TASK DENSITY', context.watch<DataProvider>().pendingTasksCount.toString()),
                           ],
                         ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Intelligence Log
            _buildBentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('SYSTEM INTELLIGENCE LOG', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
                   const SizedBox(height: 16),
                   _buildLogTable(),
                ],
              ),
            ),
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
        boxShadow: [
          BoxShadow(color: ClubOsTheme.primaryCommand.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(String title, IconData icon, {Color color = ClubOsTheme.primaryCommand}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(color: color))),
        Icon(icon, color: color.withOpacity(0.5), size: 20),
      ],
    );
  }

  Widget _buildGauge(String value, String label) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: 0.82,
            strokeWidth: 12,
            backgroundColor: ClubOsTheme.solarSurfaceLow,
            color: ClubOsTheme.primaryCommand,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -2)),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: ClubOsTheme.onSurfaceVariant)),
          ],
        )
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<double> data) {
    return Container(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((h) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: h,
              decoration: BoxDecoration(
                color: ClubOsTheme.secondaryIntelligence.withOpacity(0.4 + (h / 200)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogTable() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(120),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(100),
      },
      children: [
        _buildLogRow('08:42:12', 'Neural Buffer Handshake', 'SUCCESS'),
        _buildLogRow('08:42:11', 'Anomaly Flag Cleared', 'RESOLVED'),
        _buildLogRow('08:42:10', 'Data Stream Ingestion', 'ACTIVE'),
      ],
    );
  }

  TableRow _buildLogRow(String time, String event, String status) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(time, style: const TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(event, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: ClubOsTheme.primaryCommand.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
