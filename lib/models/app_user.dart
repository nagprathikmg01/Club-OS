class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'owner' | 'leader' | 'domain_head' | 'member'
  final String? currentClubId;
  final String? domain;
  final String status; // 'pending' | 'active'

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.currentClubId,
    this.domain,
    required this.status,
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
    );
  }
}
