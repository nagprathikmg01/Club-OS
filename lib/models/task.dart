class Task {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final String status; // 'todo' | 'inprogress' | 'done'
  final DateTime dueDate;
  final String clubId;
  final String? eventId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assigneeName,
    required this.status,
    required this.dueDate,
    required this.clubId,
    this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assigneeId': assigneeId,
      'assigneeName': assigneeName,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'clubId': clubId,
      'eventId': eventId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assigneeId: map['assigneeId'] ?? '',
      assigneeName: map['assigneeName'] ?? '',
      status: map['status'] ?? 'todo',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : DateTime.now(),
      clubId: map['clubId'] ?? '',
      eventId: map['eventId'],
    );
  }

  static List<Task> mockTasks() => [
    Task(
      id: 't1',
      title: 'Design Marketing Poster',
      description: 'Create a high-fidelity poster for the upcoming tech gala.',
      assigneeId: 'member_456',
      assigneeName: 'Member User',
      status: 'todo',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      clubId: 'c1',
      eventId: '1',
    ),
    Task(
      id: 't2',
      title: 'Coordinate with Venue',
      description: 'Finalize the lighting setup and catering logistics.',
      assigneeId: 'admin_123',
      assigneeName: 'Admin User',
      status: 'inprogress',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      clubId: 'c1',
      eventId: '1',
    ),
    Task(
      id: 't3',
      title: 'Draft Budget Spreadsheet',
      description: 'Review last year expenses and project current costs.',
      assigneeId: 'member_456',
      assigneeName: 'Member User',
      status: 'done',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      clubId: 'c1',
    ),
  ];
}
