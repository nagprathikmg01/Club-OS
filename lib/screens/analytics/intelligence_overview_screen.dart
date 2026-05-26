import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../widgets/neon_card.dart';
import 'package:graphview/graphview.dart';

class IntelligenceOverviewScreen extends StatefulWidget {
  const IntelligenceOverviewScreen({super.key});

  @override
  State<IntelligenceOverviewScreen> createState() => _IntelligenceOverviewScreenState();
}

class _IntelligenceOverviewScreenState extends State<IntelligenceOverviewScreen> {
  final Graph graph = Graph()..isTree = false;
  final SugiyamaAlgorithm builder = SugiyamaAlgorithm(SugiyamaConfiguration());

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    _updateGraph(dataProvider);

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Command Module Header
            // Command Module Header (Responsive LayoutBuilder)
            LayoutBuilder(
              builder: (context, headerConstraints) {
                final bool isNarrow = headerConstraints.maxWidth < 600;
                final headerText = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INTELLIGENCE MODULE', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 8),
                    Text('NEURAL RESOURCE\nALLOCATION', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: isNarrow ? 28 : 40, height: 1.1)),
                  ],
                );
                
                final activeBadge = Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ClubOsTheme.solarSurfaceLowest,
                    border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: ClubOsTheme.primaryCommand, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text('LIVE STREAM ACTIVE', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerText,
                      const SizedBox(height: 16),
                      activeBadge,
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      headerText,
                      activeBadge,
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            
            _buildDispatchBanner(),
            const SizedBox(height: 48),

            // Bento Grid Cards (Responsive LayoutBuilder)
            LayoutBuilder(
              builder: (context, bentoConstraints) {
                final bool stackBento = bentoConstraints.maxWidth < 750;
                final card1 = _buildBentoCard(
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
                );

                final card2 = _buildBentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildCardHeader('MEMBER RESOURCE LOAD', Icons.sensors, color: ClubOsTheme.secondaryIntelligence),
                       const SizedBox(height: 32),
                       const Text('WORKLOAD DISTRIBUTION', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                       const SizedBox(height: 24),
                       _buildBarChart(dataProvider.memberResourceAllocation),
                       const SizedBox(height: 24),
                       Row(
                         children: [
                           _buildMiniStat('ACTIVE ROSTER', dataProvider.totalMembers.toString()),
                           _buildMiniStat('TASK DENSITY', dataProvider.pendingTasksCount.toString()),
                         ],
                       ),
                    ],
                  ),
                );

                if (stackBento) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      card1,
                      const SizedBox(height: 24),
                      card2,
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: card1),
                      const SizedBox(width: 24),
                      Expanded(flex: 7, child: card2),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 48),
            
            const Text('CLUB ARCHITECTURE GRAPH', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 16),
            _buildNetworkGraph(dataProvider),
            const SizedBox(height: 48),

            _buildBentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('SYSTEM INTELLIGENCE LOG', style: Theme.of(context).textTheme.labelSmall),
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

  void _updateGraph(DataProvider dataProvider) {
    graph.nodes.clear();
    graph.edges.clear();
    
    final root = Node.Id(dataProvider.activeClub.name);
    for (var member in dataProvider.clubMembers) {
      final mNode = Node.Id(member.name);
      graph.addEdge(root, mNode);
    }
  }

  Widget _buildDispatchBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.primaryCommand.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ClubOsTheme.primaryCommand.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: ClubOsTheme.primaryCommand, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI CLUB DISPATCH', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 12, color: ClubOsTheme.primaryCommand)),
                const SizedBox(height: 4),
                Text(
                  'Operations are at 92% efficiency. Technical Domain leads with 14 tasks resolved this week. Nebula HQ recommends allocating more resources to the PR Domain for the upcoming Gala.',
                  style: TextStyle(fontSize: 13, color: ClubOsTheme.onSurfaceMain.withOpacity(0.7), height: 1.5, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkGraph(DataProvider dataProvider) {
    if (dataProvider.clubMembers.isEmpty) {
      return Container(
        height: 400,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ClubOsTheme.solarSurfaceLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
        ),
        child: Text('NO NODES DETECTED IN LOCAL NETWORK', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1,
        maxScale: 1.0,
        child: GraphView(
          graph: graph,
          algorithm: builder,
          paint: Paint()..color = ClubOsTheme.primaryCommand.withOpacity(0.3)..strokeWidth = 1..style = PaintingStyle.stroke,
          builder: (Node node) {
            var value = node.key!.value as String;
            bool isRoot = value == dataProvider.activeClub.name;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRoot ? ClubOsTheme.primaryCommand : ClubOsTheme.solarSurfaceLowest,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                border: Border.all(color: ClubOsTheme.primaryCommand),
              ),
              child: Text(
                value.substring(0, 1).toUpperCase(),
                style: TextStyle(color: isRoot ? Colors.white : ClubOsTheme.primaryCommand, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBentoCard({required Widget child}) {
    return NeonCard(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildCardHeader(String title, IconData icon, {Color? color}) {
    final resolvedColor = color ?? ClubOsTheme.primaryCommand;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: resolvedColor))),
        Icon(icon, color: resolvedColor.withOpacity(0.5), size: 20),
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
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: ClubOsTheme.onSurfaceVariant)),
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
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<double> data) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((h) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: h,
              decoration: BoxDecoration(
                color: ClubOsTheme.secondaryIntelligence.withOpacity(0.4 + (h / 200).clamp(0.0, 0.5)),
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
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(time, style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(event, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: ClubOsTheme.primaryCommand.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
