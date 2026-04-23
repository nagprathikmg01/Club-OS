class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl;
  final String clubId;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    String? imageUrl,
    required this.clubId,
  }) : imageUrl = imageUrl ?? 'https://images.unsplash.com/photo-1540575861501-7ce058a877c3?q=80&w=1000&auto=format&fit=crop';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'clubId': clubId,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      imageUrl: map['imageUrl'],
      clubId: map['clubId'] ?? '',
    );
  }

  static List<Event> mockEvents() => [
    Event(
      id: '1',
      title: 'Season Opener Party',
      description: 'Kick off the new season with live DJ and neon vibes.',
      date: DateTime.now().add(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1514525253344-f81bad374433?w=800',
      clubId: 'c1', // Tech Innovators usually do web3 but a party is fine
    ),
    Event(
      id: '2',
      title: 'Tech Meetup: Web3',
      description: 'Exploring the future of the decentralized web.',
      date: DateTime.now().add(const Duration(days: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800',
      clubId: 'c1',
    ),
    Event(
      id: '3',
      title: 'Photo Walk downtown',
      description: 'A great walk to test your new lenses.',
      date: DateTime.now().add(const Duration(days: 10)),
      clubId: 'c2', // Photography
    ),
    Event(
      id: '4',
      title: 'Improv Night',
      description: 'Test your acting skills with some improv.',
      date: DateTime.now().add(const Duration(days: 12)),
      clubId: 'c3', // Drama
    ),
  ];
}
