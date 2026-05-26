class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final String status; // 'available' | 'issued' | 'damaged'
  final String? assignedTo;
  final String? assignedName;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.status,
    this.assignedTo,
    this.assignedName,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'status': status,
      'assignedTo': assignedTo,
      'assignedName': assignedName,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map, String id) {
    return InventoryItem(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      status: map['status'] ?? 'available',
      assignedTo: map['assignedTo'],
      assignedName: map['assignedName'],
    );
  }
}
