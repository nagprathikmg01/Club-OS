class Club {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final String imageUrl;

  final String joinCode;
  final String ownerUid;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required String imageUrl,
    required this.joinCode,
    required this.ownerUid,
  }) : imageUrl = imageUrl.isEmpty 
          ? 'https://images.unsplash.com/photo-1522071823907-f6fcb0606d1c?q=80&w=1000&auto=format&fit=crop' 
          : imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'imageUrl': imageUrl,
      'joinCode': joinCode,
      'ownerUid': ownerUid,
    };
  }

  factory Club.fromMap(Map<String, dynamic> map, String id) {
    return Club(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      memberCount: map['memberCount'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      joinCode: map['joinCode'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
    );
  }
}
