import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../models/budget_entry.dart';
import '../../widgets/neon_card.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class FiscalObservatoryScreen extends StatelessWidget {
  const FiscalObservatoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final entries = dataProvider.budgetEntries;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;
          
          final header = _buildHeader(context, dataProvider, isMobile: isMobile);
          final transactionList = _buildTransactionList(entries, isMobile: isMobile);
          final analyticsPanel = _buildAnalyticsPanel(context, dataProvider);
          
          if (isMobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  const SizedBox(height: 24),
                  analyticsPanel,
                  const SizedBox(height: 32),
                  transactionList,
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  const SizedBox(height: 32),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: transactionList),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: analyticsPanel),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context, dataProvider),
        backgroundColor: ClubOsTheme.primaryCommand,
        label: const Text('LOG TRANSACTION', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 12)),
        icon: const Icon(Icons.add_chart_outlined),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DataProvider dataProvider, {bool isMobile = false}) {
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FISCAL OBSERVATORY',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: ClubOsTheme.primaryCommand,
          ),
        ),
        const SizedBox(height: 4),
        Text('REAL-TIME SYSTEM LIQUIDITY & EXPENDITURE', style: Theme.of(context).textTheme.labelSmall),
      ],
    );

    final liquidityBox = NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text('TOTAL LIQUIDITY', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            '₹${dataProvider.totalBalance.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ClubOsTheme.primaryCommand),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleColumn,
          const SizedBox(height: 16),
          liquidityBox,
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleColumn,
          liquidityBox,
        ],
      );
    }
  }

  Widget _buildTransactionList(List<BudgetEntry> entries, {bool isMobile = false}) {
    return ListView.builder(
      shrinkWrap: isMobile,
      physics: isMobile ? const NeverScrollableScrollPhysics() : null,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isExpense = entry.type == 'expense';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NeonCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isExpense ? Colors.redAccent : Colors.greenAccent).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpense ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded,
                    color: isExpense ? Colors.redAccent : Colors.greenAccent[700],
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClubOsTheme.onSurfaceMain),
                      ),
                      Text(
                        entry.category,
                        style: TextStyle(fontSize: 11, color: ClubOsTheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? "-" : "+"} ₹${entry.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isExpense ? Colors.redAccent : Colors.greenAccent[700],
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(entry.date),
                      style: TextStyle(fontSize: 10, color: ClubOsTheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsPanel(BuildContext context, DataProvider dataProvider) {
    final entries = dataProvider.budgetEntries;
    final Map<String, double> categorySums = {};
    double totalExpense = 0.0;

    for (var entry in entries) {
      if (entry.type == 'expense') {
        categorySums[entry.category] = (categorySums[entry.category] ?? 0.0) + entry.amount;
        totalExpense += entry.amount;
      }
    }

    final colors = [
      ClubOsTheme.primaryCommand,
      ClubOsTheme.secondaryIntelligence,
      ClubOsTheme.tertiaryAnalytical,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
    ];

    List<PieChartSectionData> sections = [];
    if (totalExpense == 0.0) {
      sections = [
        PieChartSectionData(
          color: ClubOsTheme.solarSurfaceLow,
          value: 100,
          title: 'NO EXPENSES',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ];
    } else {
      int index = 0;
      categorySums.forEach((category, sum) {
        final percentage = (sum / totalExpense) * 100;
        sections.add(
          PieChartSectionData(
            color: colors[index % colors.length],
            value: percentage,
            title: '${category.toUpperCase()}\n${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        );
        index++;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ALLOCATION DENSITY', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 16),
        NeonCard(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddEntryDialog(BuildContext context, DataProvider dataProvider) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = 'expense';
    String selectedCategory = 'Tech';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: ClubOsTheme.solarSurfaceLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('LOG FISCAL ENTRY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'ENTRY TITLE')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'AMOUNT (₹)'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['income', 'expense'].map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => selectedType = v!),
                decoration: const InputDecoration(labelText: 'TYPE'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['Tech', 'Logistics', 'Food', 'PR', 'Admin', 'Marketing', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => selectedCategory = v!),
                decoration: const InputDecoration(labelText: 'CATEGORY'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  dataProvider.addBudgetEntry(BudgetEntry(
                    id: '',
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    type: selectedType,
                    date: DateTime.now(),
                    category: selectedCategory,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }
}
