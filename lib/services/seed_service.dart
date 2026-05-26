import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeedService {
  static Future<void> seedData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('NOT LOGGED IN');

    // STEP 1: Always create/overwrite the current user doc FIRST
    // Using set with merge so it works for both new and existing users
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': user.displayName ?? 'Admin',
      'email': user.email ?? '',
      'currentClubId': 'nmit_robotics',
      'status': 'active',
      'role': 'leader',
      'xp': 1200,
      'level': 2,
    }, SetOptions(merge: true));

    final clubs = [
      {'id': 'nmit_robotics', 'name': 'NMIT Robotics Club', 'desc': 'Nitte Meenakshi Institute of Technology official robotics wing.', 'code': 'NMTRB'},
      {'id': 'nmit_coding', 'name': 'NMIT Coding Club', 'desc': 'Empowering students with competitive coding at NMIT.', 'code': 'NMTCC'},
      {'id': 'nmit_ecell', 'name': 'NMIT E-Cell', 'desc': 'Startup incubation and entrepreneurial wing of NMIT.', 'code': 'NMTEC'},
      {'id': 'nmit_ieee', 'name': 'NMIT IEEE SB', 'desc': 'International standard technical community at NMIT Bangalore.', 'code': 'NMTIE'},
    ];

    final indianNames = [
      'Arjun Sharma', 'Priya Patel', 'Rahul Iyer', 'Ananya Das', 'Vikram Singh',
      'Siddharth Nair', 'Ishita Gupta', 'Karan Verma', 'Meera Reddy', 'Aditya Joshi',
      'Sanjay Rao', 'Divya K.', 'Sneha Hegde', 'Varun Kumar', 'Rohan Bhat'
    ];

    for (var clubData in clubs) {
      final clubId = clubData['id'] as String;

      // STEP 2: Create each club (set, not update)
      await firestore.collection('clubs').doc(clubId).set({
        'name': clubData['name'],
        'description': clubData['desc'],
        'memberCount': 15,
        'imageUrl': 'https://images.unsplash.com/photo-1562774053-701939374585?w=800',
        'joinCode': clubData['code'],
        'ownerUid': user.uid,
        'budget': 0.0,
        'inventoryCount': 0,
      });

      // STEP 3: Create 8 mock members per club
      List<String> clubMemberIds = [];
      for (int i = 0; i < 8; i++) {
        final nameIndex = (clubId.length + i) % indianNames.length;
        final mockUid = 'mock_${clubId}_$i';
        clubMemberIds.add(mockUid);
        await firestore.collection('users').doc(mockUid).set({
          'uid': mockUid,
          'name': indianNames[nameIndex],
          'email': '${indianNames[nameIndex].toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@nmit.edu.in',
          'currentClubId': clubId,
          'status': 'active',
          'role': i == 0 ? 'leader' : 'member',
          'xp': (i * 250) + 100,
          'level': ((i * 250 + 100) ~/ 1000) + 1,
        });
      }

      // STEP 4: Create event (using set with known ID)
      final eventId = 'event_${clubId}_01';
      await firestore.collection('clubs').doc(clubId).collection('events').doc(eventId).set({
        'title': clubId == 'nmit_coding' ? 'NMIT Hack-A-Thon 2024' : 'Anaadyanta 2024',
        'description': 'The flagship techno-cultural fest of NMIT Bangalore.',
        'date': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        'imageUrl': 'https://images.unsplash.com/photo-1540575861501-7ad058c67a04?w=800',
        'clubId': clubId,
      });

      // STEP 5: Add 5 tasks assigned to different members
      final taskData = [
        {'title': 'Sponsorship Pitch', 'desc': 'Contact Titan, Infosys and Tata Steel.', 'status': 'done'},
        {'title': 'Social Media Campaign', 'desc': 'Instagram reels and posters for Anaadyanta.', 'status': 'inprogress'},
        {'title': 'Venue Logistics', 'desc': 'Book main auditorium and seminar hall.', 'status': 'todo'},
        {'title': 'Speaker Outreach', 'desc': 'Invite industry experts from Bangalore.', 'status': 'inprogress'},
        {'title': 'Security Protocol', 'desc': 'Coordinate with NMIT campus security.', 'status': 'todo'},
      ];

      for (int i = 0; i < taskData.length; i++) {
        final assigneeIdx = i % clubMemberIds.length;
        final nameIndex = (clubId.length + assigneeIdx) % indianNames.length;
        await firestore.collection('clubs').doc(clubId).collection('tasks').add({
          'title': taskData[i]['title'],
          'description': taskData[i]['desc'],
          'assigneeId': clubMemberIds[assigneeIdx],
          'assigneeName': indianNames[nameIndex],
          'status': taskData[i]['status'],
          'dueDate': DateTime.now().add(Duration(days: i + 2)).toIso8601String(),
          'clubId': clubId,
          'eventId': eventId,
          'xpReward': 300 + (i * 50),
        });
      }

      // STEP 6: Budget entries
      await firestore.collection('clubs').doc(clubId).collection('budget').add({
        'title': 'NMIT Cultural Grant',
        'amount': 50000.0,
        'type': 'income',
        'date': DateTime.now().toIso8601String(),
        'category': 'Admin',
      });

      await firestore.collection('clubs').doc(clubId).collection('budget').add({
        'title': 'Audio & PA System Rental',
        'amount': 15000.0,
        'type': 'expense',
        'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'category': 'Logistics',
      });

      await firestore.collection('clubs').doc(clubId).collection('budget').add({
        'title': 'Refreshments - Workshop Day',
        'amount': 8000.0,
        'type': 'expense',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'category': 'Food',
      });

      // STEP 7: Inventory items
      await firestore.collection('clubs').doc(clubId).collection('inventory').add({
        'name': 'Epson Projector',
        'quantity': 2,
        'status': 'available',
      });
      await firestore.collection('clubs').doc(clubId).collection('inventory').add({
        'name': 'Wireless Mic Set',
        'quantity': 4,
        'status': 'available',
      });
    }
  }
}
