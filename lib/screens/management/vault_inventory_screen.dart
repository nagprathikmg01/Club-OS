import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import '../../models/inventory_item.dart';
import '../../models/app_user.dart';
import '../../widgets/neon_card.dart';

class VaultInventoryScreen extends StatelessWidget {
  const VaultInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final items = dataProvider.inventoryItems;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, dataProvider),
            const SizedBox(height: 32),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'NO ASSETS ENROLLED IN THE VAULT',
                        style: TextStyle(
                          color: ClubOsTheme.onSurfaceVariant.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 950 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.5 : 2.0,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildInventoryCard(context, dataProvider, item);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: dataProvider.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddItemDialog(context, dataProvider),
              backgroundColor: ClubOsTheme.primaryCommand,
              label: const Text('ENROLL ASSET', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 12)),
              icon: const Icon(Icons.inventory_outlined),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, DataProvider dataProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE VAULT',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: ClubOsTheme.primaryCommand,
          ),
        ),
        const SizedBox(height: 4),
        Text('CENTRALIZED ASSET REPOSITORY & CHECKOUT LOGS', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildInventoryCard(BuildContext context, DataProvider dataProvider, InventoryItem item) {
    final isAdmin = dataProvider.isAdmin;

    return NeonCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(color: _getStatusColor(item.status), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              if (isAdmin)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
                  color: ClubOsTheme.solarSurfaceLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: ClubOsTheme.outlineVariant),
                  ),
                  onSelected: (action) {
                    if (action == 'issue') {
                      _showIssueDialog(context, dataProvider, item);
                    } else if (action == 'return') {
                      dataProvider.updateInventoryItem(InventoryItem(
                        id: item.id,
                        name: item.name,
                        quantity: item.quantity,
                        status: 'available',
                        assignedTo: null,
                        assignedName: null,
                      ));
                    } else if (action == 'damage') {
                      dataProvider.updateInventoryItem(InventoryItem(
                        id: item.id,
                        name: item.name,
                        quantity: item.quantity,
                        status: 'damaged',
                        assignedTo: item.assignedTo,
                        assignedName: item.assignedName,
                      ));
                    } else if (action == 'repair') {
                      dataProvider.updateInventoryItem(InventoryItem(
                        id: item.id,
                        name: item.name,
                        quantity: item.quantity,
                        status: 'available',
                        assignedTo: item.assignedTo,
                        assignedName: item.assignedName,
                      ));
                    } else if (action == 'delete') {
                      dataProvider.deleteInventoryItem(item.id);
                    }
                  },
                  itemBuilder: (context) => [
                    if (item.status == 'available')
                      const PopupMenuItem(
                        value: 'issue',
                        child: Text('Issue Asset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    if (item.status == 'issued')
                      const PopupMenuItem(
                        value: 'return',
                        child: Text('Return Asset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    if (item.status != 'damaged')
                      const PopupMenuItem(
                        value: 'damage',
                        child: Text('Mark Damaged', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                      ),
                    if (item.status == 'damaged')
                      const PopupMenuItem(
                        value: 'repair',
                        child: Text('Mark Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Asset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                    ),
                  ],
                )
              else
                const Icon(Icons.inventory_outlined, size: 16, color: Colors.grey),
            ],
          ),
          const Spacer(),
          Text(
            item.name.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 0.5,
              color: ClubOsTheme.onSurfaceMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'QUANTITY: ${item.quantity}',
            style: TextStyle(
              fontSize: 11,
              color: ClubOsTheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (item.assignedTo != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 12, color: ClubOsTheme.primaryCommand),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.assignedName ?? 'Unknown',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available': return Colors.greenAccent[700]!;
      case 'issued': return Colors.blueAccent;
      case 'damaged': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  void _showIssueDialog(BuildContext context, DataProvider dataProvider, InventoryItem item) {
    final members = dataProvider.clubMembers;
    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NO MEMBERS REGISTERED IN THIS CLUB'), backgroundColor: ClubOsTheme.errorRed),
      );
      return;
    }

    AppUser? selectedMember = members.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: ClubOsTheme.solarSurfaceLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('ISSUE ${item.name.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select member to assign this asset to:', style: TextStyle(fontSize: 13, color: ClubOsTheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ClubOsTheme.solarSurfaceLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AppUser>(
                    value: selectedMember,
                    isExpanded: true,
                    dropdownColor: ClubOsTheme.solarSurfaceLowest,
                    items: members.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.name, style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain)),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedMember = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                if (selectedMember != null) {
                  dataProvider.updateInventoryItem(InventoryItem(
                    id: item.id,
                    name: item.name,
                    quantity: item.quantity,
                    status: 'issued',
                    assignedTo: selectedMember!.uid,
                    assignedName: selectedMember!.name,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('ISSUE'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, DataProvider dataProvider) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ClubOsTheme.solarSurfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ENROLL NEW ASSET', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'ASSET NAME')),
            TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'QUANTITY'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && qtyController.text.isNotEmpty) {
                dataProvider.addInventoryItem(InventoryItem(
                  id: '',
                  name: nameController.text,
                  quantity: int.tryParse(qtyController.text) ?? 1,
                  status: 'available',
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('ENROLL'),
          ),
        ],
      ),
    );
  }
}
