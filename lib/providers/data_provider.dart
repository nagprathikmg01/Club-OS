import 'dart:async';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/task.dart';
import '../models/app_user.dart';
import '../models/club.dart';
import '../models/message.dart';
import '../models/membership_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DataProvider with ChangeNotifier {
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  bool _isAdmin = false; 
  String _activeClubId = '';
  
  List<Club> _clubs = []; 
  List<Event> _events = [];
  List<Task> _tasks = [];
  List<ChatMessage> _messages = [];
  String _searchQuery = '';

  // Stream Subscriptions
  StreamSubscription? _userSub;
  StreamSubscription? _clubsSub;
  StreamSubscription? _eventsSub;
  StreamSubscription? _tasksSub;
  StreamSubscription? _membersSub;
  StreamSubscription? _requestsSub;
  
  DataProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _cancelAllSubs();
      if (user != null) {
        _userSub = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((doc) {
          if (doc.exists) {
            _currentUser = AppUser.fromMap(doc.data()!);
            
            // Master Admin override check
            if (_currentUser!.email == 'prathik32p@gmail.com') {
              _isAdmin = true;
            } else {
              _isAdmin = false; // Will be refined by club ownership
            }

            if (_activeClubId.isEmpty && _currentUser!.currentClubId != null) {
              _activeClubId = _currentUser!.currentClubId!;
            }
            
            _initStreams();
            notifyListeners();
          }
        });

        _clubsSub = FirebaseFirestore.instance
            .collection('clubs')
            .where('ownerUid', isEqualTo: user.uid)
            .snapshots()
            .listen((snapshot) {
          _clubs = snapshot.docs.map((doc) => Club.fromMap(doc.data(), doc.id)).toList();
          
          // Master Admin fallback
          if (_currentUser?.email == 'prathik32p@gmail.com' && _clubs.isEmpty) {
            _clubs = [Club(id: 'c1', name: 'NEBULA HQ', description: 'Master Network', memberCount: 0, imageUrl: '', joinCode: 'NEBULAXT', ownerUid: user.uid)];
          }

          if (_activeClubId.isEmpty && _clubs.isNotEmpty) {
            _activeClubId = _clubs.first.id;
            _initStreams();
          }
          
          notifyListeners();
        });
      } else {
        _currentUser = null;
        _activeClubId = '';
        _clubs = [];
        notifyListeners();
      }
    });
  }

  void _cancelAllSubs() {
    _userSub?.cancel();
    _clubsSub?.cancel();
    _eventsSub?.cancel();
    _tasksSub?.cancel();
    _membersSub?.cancel();
    _requestsSub?.cancel();
  }

  void _initStreams() {
    if (_activeClubId.isEmpty) return;

    _eventsSub?.cancel();
    _eventsSub = FirebaseFirestore.instance
        .collection('clubs')
        .doc(_activeClubId)
        .collection('events')
        .snapshots()
        .listen((snapshot) {
      _events = snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    });

    _tasksSub?.cancel();
    _tasksSub = FirebaseFirestore.instance
        .collection('clubs')
        .doc(_activeClubId)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    });

    _membersSub?.cancel();
    _membersSub = FirebaseFirestore.instance
        .collection('users')
        .where('currentClubId', isEqualTo: _activeClubId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .listen((snapshot) {
      _clubMembers = snapshot.docs.map((doc) => AppUser.fromMap(doc.data())).toList();
      notifyListeners();
    });

    _requestsSub?.cancel();
    if (isAdmin) {
      _requestsSub = FirebaseFirestore.instance
          .collection('clubs')
          .doc(_activeClubId)
          .collection('requests')
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        _pendingRequests = snapshot.docs.map((doc) => MembershipRequest.fromMap(doc.data(), doc.id)).toList();
        notifyListeners();
      });
    } else {
      _pendingRequests = [];
      notifyListeners();
    }
  }

  bool get isAdmin {
    if (_currentUser?.email == 'prathik32p@gmail.com') return true;
    if (_activeClubId.isNotEmpty) {
      final club = activeClub;
      return club.ownerUid == _currentUser?.uid;
    }
    return _isAdmin;
  }
  String get searchQuery => _searchQuery;

  List<Club> get clubs => _clubs;
  String get activeClubId => _activeClubId;
  
  Club get activeClub {
    if (_clubs.isEmpty) {
       return Club(id: 'none', name: 'NO CLUB', description: '', memberCount: 0, imageUrl: '', joinCode: '', ownerUid: '');
    }
    return _clubs.firstWhere(
      (c) => c.id == _activeClubId, 
      orElse: () => _clubs.first
    );
  }


  // Switching clubs
  void switchClub(String id) {
    _activeClubId = id;
    _initStreams(); // Connect to new club's live data
    notifyListeners();
  }

  // Smart Sorting & Filtering by active club
  List<Event> get events {
    final activeEvents = _events.where((e) => e.clubId == _activeClubId).toList();
    final filtered = _searchQuery.isEmpty 
        ? activeEvents 
        : activeEvents.where((e) =>
            e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    // Nearest events first
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  List<Task> get tasks {
    final activeTasks = _tasks.where((t) => t.clubId == _activeClubId).toList();
    final filtered = _searchQuery.isEmpty 
        ? activeTasks 
        : activeTasks.where((t) =>
            t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
            
    // Due date order
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return filtered;
  }

  // Chat
  List<ChatMessage> get chatMessages {
    final msgs = _messages.where((m) => m.clubId == _activeClubId).toList();
    msgs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return msgs;
  }

  void sendMessage(ChatMessage msg) {
    _messages.add(msg);
    notifyListeners();
  }

  // Elite Member Roster
  List<AppUser> _clubMembers = [];
  List<AppUser> get clubMembers => _clubMembers;

  List<MembershipRequest> _pendingRequests = [];
  List<MembershipRequest> get pendingRequests => _pendingRequests;

  // App Stats for active club
  int get totalMembers => activeClub.memberCount;
  int get activeEvents => _events.where((e) => e.clubId == _activeClubId).length;
  List<Event> get activeEventsList => _events.where((e) => e.clubId == _activeClubId).toList();
  double get taskCompletionRate {
    final activeTasks = _tasks.where((t) => t.clubId == _activeClubId).toList();
    if (activeTasks.isEmpty) return 0;
    final doneTasks = activeTasks.where((t) => t.status == 'done').length;
    return doneTasks / activeTasks.length;
  }

  String get taskCompletionRatePercent => '${(taskCompletionRate * 100).toInt()}%';
  
  int get pendingTasksCount => _tasks.where((t) => t.clubId == _activeClubId && t.status != 'done').length;


  // Event progress
  List<Task> getTasksForEvent(String eventId) {
    return _tasks.where((t) => t.eventId == eventId).toList();
  }

  double getEventCompletionRate(String eventId) {
    final eventTasks = getTasksForEvent(eventId);
    if (eventTasks.isEmpty) return 0;
    final doneTasks = eventTasks.where((t) => t.status == 'done').length;
    return doneTasks / eventTasks.length;
  }

  // --- Member Analytics ---
  Map<String, dynamic> getMemberTaskStats(String userId) {
    final userTasks = _tasks.where((t) => t.assigneeId == userId && t.clubId == _activeClubId).toList();
    final total = userTasks.length;
    final completed = userTasks.where((t) => t.status == 'done').length;
    final pending = userTasks.where((t) => t.status != 'done').length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'efficiency': total == 0 ? 0.0 : (completed / total),
    };
  }

  // Search & RBAC
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  // RBAC Join & Create Flow
  Future<void> createClub({required String name, required String description, required String imageUrl}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final joinCode = _generateJoinCode();
    
    final docRef = FirebaseFirestore.instance.collection('clubs').doc();
    final newClub = Club(
      id: docRef.id,
      name: name,
      description: description,
      memberCount: 1, // The owner is the first member
      imageUrl: imageUrl.isEmpty ? 'https://images.unsplash.com/photo-1522071823907-f6fcb0606d1c?q=80&w=1000&auto=format&fit=crop' : imageUrl,
      joinCode: joinCode,
      ownerUid: user.uid,
    );
    
    await docRef.set(newClub.toMap());
    
    // Update user to be active in this new club as Leader
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'currentClubId': docRef.id,
      'status': 'active',
      'role': 'leader'
    });
  }

  String _generateJoinCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Avoid ambiguous chars
    final rnd = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(rnd + i) % chars.length];
    }
    return code;
  }

  Future<void> joinClub(String code) async {
    final snapshot = await FirebaseFirestore.instance.collection('clubs').where('joinCode', isEqualTo: code).get();
    if (snapshot.docs.isNotEmpty) {
       final clubId = snapshot.docs.first.id;
       final ownerUid = snapshot.docs.first.data()['ownerUid'];
       final user = FirebaseAuth.instance.currentUser!;
       
       final request = MembershipRequest(
         id: user.uid,
         userId: user.uid,
         userName: _currentUser?.name ?? 'Anonymous',
         userEmail: _currentUser?.email ?? 'Unknown',
         clubId: clubId,
         status: 'pending',
         requestedAt: DateTime.now(),
       );

       await FirebaseFirestore.instance.collection('clubs').doc(clubId).collection('requests').doc(user.uid).set(request.toMap());
       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'currentClubId': clubId, 'status': 'pending'});
       
       // Trigger Admin Notification (Simulated Email Flow)
       if (ownerUid != null) {
         await FirebaseFirestore.instance.collection('users').doc(ownerUid).collection('notifications').add({
           'title': 'NEBULA JOIN REQUEST',
           'body': '${request.userName} (${request.userEmail}) is requesting system access.',
           'type': 'join_request',
           'timestamp': FieldValue.serverTimestamp(),
         });
       }
    } else {
       throw Exception('Invalid Access Code');
    }
  }

  Future<void> approveRequest(String userId, String role) async {
    await FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('requests').doc(userId).update({'status': 'approved'});
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'status': 'active', 
      'role': role.toLowerCase(),
    });
  }

  // --- Elite CRUD: Events ---
  void addEvent(Event event) {
    // Generate an ID if needed or push directly
    final docRef = FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('events').doc();
    final newEvent = Event(
      id: event.id.isEmpty || event.id.startsWith('MOCK') ? docRef.id : event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      imageUrl: event.imageUrl,
      clubId: event.clubId,
    );
    docRef.set(newEvent.toMap());
  }
  void deleteEvent(String id) {
    FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('events').doc(id).delete();
  }
  void updateEvent(Event updatedEvent) {
    FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('events').doc(updatedEvent.id).update(updatedEvent.toMap());
  }

  // --- Elite CRUD: Tasks ---
  void addTask(Task task) {
    final docRef = FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('tasks').doc();
    final newTask = Task(
      id: task.id.isEmpty || task.id.startsWith('MOCK') ? docRef.id : task.id,
      title: task.title,
      description: task.description,
      assigneeId: task.assigneeId,
      assigneeName: task.assigneeName,
      status: task.status,
      dueDate: task.dueDate,
      clubId: task.clubId,
      eventId: task.eventId,
    );
    docRef.set(newTask.toMap());
  }
  void deleteTask(String id) {
    FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('tasks').doc(id).delete();
  }
  void updateTask(Task updatedTask) {
    FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('tasks').doc(updatedTask.id).update(updatedTask.toMap());
  }
  
  void updateTaskStatus(String taskId, String newStatus) {
    FirebaseFirestore.instance.collection('clubs').doc(_activeClubId).collection('tasks').doc(taskId).update({'status': newStatus});
  }

  // --- Auth Elite: Google Logic ---
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    notifyListeners();
  }

  // --- Dynamic Analytics: Resource Allocation ---
  List<double> get memberResourceAllocation {
    if (_clubMembers.isEmpty) return List.generate(12, (index) => 20.0); // Baseline
    
    // Map members to their task load in the active club
    final Map<String, int> counts = {};
    for (var m in _clubMembers) {
      counts[m.uid] = _tasks.where((t) => t.assigneeId == m.uid && t.clubId == _activeClubId).length;
    }
    
    final values = counts.values.toList();
    if (values.isEmpty) return List.generate(12, (index) => 15.0);
    
    final maxVal = values.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxVal == 0) return values.map((e) => 10.0).toList();
    
    // Scale for chart height (0 to 100)
    return values.map((v) => (v / maxVal) * 90 + 10).toList();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Initialize first-time elite user
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? 'Nebula Recruit',
            'email': user.email ?? '',
            'currentClubId': null,
            'status': 'join_pending',
            'role': 'member',
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}

