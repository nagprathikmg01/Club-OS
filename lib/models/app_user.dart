class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'owner' | 'leader' | 'domain_head' | 'member'
  final String? currentClubId;
  final String? domain;
  final String status; // 'pending' | 'active'
  final int xp;
  final int level;
  final List<String> badges;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.currentClubId,
    this.domain,
    required this.status,
    this.xp = 0,
    this.level = 1,
    this.badges = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'currentClubId': currentClubId,
      'domain': domain,
      'status': status,
      'xp': xp,
      'level': level,
      'badges': badges,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'member',
      currentClubId: map['currentClubId'],
      domain: map['domain'],
      status: map['status'] ?? 'pending',
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      badges: List<String>.from(map['badges'] ?? []),
    );
  }
}
