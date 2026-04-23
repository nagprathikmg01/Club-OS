class MembershipRequest {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String clubId;
  final String status; // 'pending' | 'approved' | 'rejected'
  final DateTime requestedAt;

  MembershipRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.clubId,
    required this.status,
    required this.requestedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'clubId': clubId,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  factory MembershipRequest.fromMap(Map<String, dynamic> map, String id) {
    return MembershipRequest(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      clubId: map['clubId'] ?? '',
      status: map['status'] ?? 'pending',
      requestedAt: map['requestedAt'] != null ? DateTime.parse(map['requestedAt']) : DateTime.now(),
    );
  }
}
