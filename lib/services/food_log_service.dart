import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/food_log_model.dart';
import 'auth_service.dart';

final foodLogServiceProvider = StateNotifierProvider<FoodLogService, List<FoodLog>>((ref) {
  final authState = ref.watch(authStateProvider);
  return FoodLogService(authState.value);
});

class FoodLogService extends StateNotifier<List<FoodLog>> {
  final User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FoodLogService(this._currentUser) : super([]) {
    if (_currentUser != null) {
      _subscribeToLogs();
    }
  }

  void _subscribeToLogs() {
    debugPrint('📊 Subscribing to food logs for user: ${_currentUser!.uid}');
    _firestore
        .collection('food_logs')
        .where('userId', isEqualTo: _currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      debugPrint('📊 Received ${snapshot.docs.length} food logs from Firestore');
      final logs = snapshot.docs.map((doc) {
        final data = doc.data();
        // Handle Timestamp conversion
        if (data['timestamp'] is Timestamp) {
          data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
        }
        return FoodLog.fromJson(data);
      }).toList();
      
      // Sort by timestamp descending (newest first)
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      debugPrint('📊 Updated food logs state with ${logs.length} items');
      state = logs;
    }, onError: (e) {
      debugPrint('❌ Error loading food logs: $e');
    });
  }

  Future<void> addLog(FoodLog log) async {
    if (_currentUser == null) return;
    
    // Ensure correct userId
    final logWithUser = log.copyWith(userId: _currentUser!.uid);
    final json = logWithUser.toJson();
    
    // Convert DateTime to Timestamp for Firestore
    json['timestamp'] = Timestamp.fromDate(log.timestamp);
    
    await _firestore.collection('food_logs').doc(log.id).set(json);
  }

  Future<void> deleteLog(String id) async {
    if (_currentUser == null) return;
    await _firestore.collection('food_logs').doc(id).delete();
  }

  Future<void> updateLog(FoodLog updatedLog) async {
    if (_currentUser == null) return;
    
    final json = updatedLog.toJson();
    json['timestamp'] = Timestamp.fromDate(updatedLog.timestamp);
    
    await _firestore.collection('food_logs').doc(updatedLog.id).update(json);
  }

  List<FoodLog> getLogsForDate(DateTime date) {
    return state.where((log) {
      return log.timestamp.year == date.year &&
             log.timestamp.month == date.month &&
             log.timestamp.day == date.day;
    }).toList();
  }

  Map<String, double> getDailyTotals(DateTime date) {
    final logs = getLogsForDate(date);
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (var log in logs) {
      calories += log.calories;
      protein += log.protein;
      carbs += log.carbs;
      fat += log.fat;
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  Map<String, double> getWeeklyTotals(DateTime weekStart) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    int daysWithLogs = 0;

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dayTotals = getDailyTotals(date);
      
      if (dayTotals['calories']! > 0) {
        daysWithLogs++;
        totalCalories += dayTotals['calories']!;
        totalProtein += dayTotals['protein']!;
        totalCarbs += dayTotals['carbs']!;
        totalFat += dayTotals['fat']!;
      }
    }

    return {
      'calories': daysWithLogs > 0 ? totalCalories / daysWithLogs : 0,
      'protein': daysWithLogs > 0 ? totalProtein / daysWithLogs : 0,
      'carbs': daysWithLogs > 0 ? totalCarbs / daysWithLogs : 0,
      'fat': daysWithLogs > 0 ? totalFat / daysWithLogs : 0,
      'daysLogged': daysWithLogs.toDouble(),
    };
  }

  List<FoodLog> getRecentFoods({int limit = 10}) {
    final uniqueFoods = <String, FoodLog>{};
    
    for (final log in state) { // Already sorted newest first
      if (!uniqueFoods.containsKey(log.name)) {
        uniqueFoods[log.name] = log;
        if (uniqueFoods.length >= limit) break;
      }
    }
    
    return uniqueFoods.values.toList();
  }

  List<FoodLog> getLogsForMeal(DateTime date, String mealType) {
    return getLogsForDate(date).where((log) => log.mealType == mealType).toList();
  }

  int getCurrentStreak() {
    if (state.isEmpty) return 0;
    
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    // Use a set of date strings for efficient lookup
    final loggedDates = state.map((log) {
      return '${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day}';
    }).toSet();
    
    while (true) {
      final dateStr = '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      
      if (loggedDates.contains(dateStr)) {
        streak++;
      } else if (streak > 0) {
        // Break if we miss a day (unless it's today and we haven't logged yet, 
        // but usually streak counts backwards from yesterday if today is empty? 
        // For simplicity, we count contiguous days including today)
        break; 
      }
      
      currentDate = currentDate.subtract(const Duration(days: 1));
      if (streak > 365) break;
    }
    
    return streak;
  }
}
