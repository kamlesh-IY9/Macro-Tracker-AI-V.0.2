import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weight_log_model.dart';
import 'auth_service.dart';

final weightServiceProvider = StateNotifierProvider<WeightService, List<WeightLog>>((ref) {
  final authState = ref.watch(authStateProvider);
  return WeightService(authState.value);
});

class WeightService extends StateNotifier<List<WeightLog>> {
  final User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WeightService(this._currentUser) : super([]) {
    if (_currentUser != null) {
      _subscribeToLogs();
    }
  }

  void _subscribeToLogs() {
    _firestore
        .collection('weight_logs')
        .where('userId', isEqualTo: _currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      final logs = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data['timestamp'] is Timestamp) {
          data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
        }
        return WeightLog.fromJson(data);
      }).toList();
      
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
      state = logs;
    });
  }

  Future<void> addLog(WeightLog log) async {
    if (_currentUser == null) return;
    
    // Optimistic update: Update local state immediately
    final previousState = state;
    final newState = [log, ...state];
    newState.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = newState;
    
    try {
      final logWithUser = log.copyWith(userId: _currentUser!.uid);
      final json = logWithUser.toJson();
      json['timestamp'] = Timestamp.fromDate(log.timestamp);
      
      await _firestore.collection('weight_logs').doc(log.id).set(json);
    } catch (e) {
      // Revert state if operation fails
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteLog(String id) async {
    if (_currentUser == null) return;

    // Optimistic update
    final previousState = state;
    state = state.where((log) => log.id != id).toList();

    try {
      await _firestore.collection('weight_logs').doc(id).delete();
    } catch (e) {
      // Revert state if operation fails
      state = previousState;
      rethrow;
    }
  }
  
  // Get latest weight
  double? get currentWeight => state.isNotEmpty ? state.first.weight : null;
}
