import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'tdee_calculator.dart';
import 'auth_service.dart';

final userServiceProvider = StateNotifierProvider<UserService, UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return UserService(authState.value);
});

class UserService extends StateNotifier<UserModel?> {
  final User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserService(this._currentUser) : super(null) {
    debugPrint('UserService initialized. Current User: ${_currentUser?.uid}');
    if (_currentUser != null) {
      _subscribeToUser();
    }
  }

  void _subscribeToUser() {
    debugPrint('Subscribing to user document: ${_currentUser!.uid}');
    _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      debugPrint('User snapshot received. Exists: ${snapshot.exists}');
      if (snapshot.exists && snapshot.data() != null) {
        debugPrint('User data found: ${snapshot.data()}');
        state = UserModel.fromJson(snapshot.data()!);
      } else {
        debugPrint('User data is null or does not exist');
        state = null;
      }
    }, onError: (e) {
      debugPrint('Error listening to user stream: $e');
    });
  }

  Future<void> saveUser(UserModel user) async {
    if (_currentUser == null) return;
    
    // Ensure ID matches Auth UID
    final userWithId = user.copyWith(id: _currentUser!.uid, email: _currentUser!.email ?? '');
    
    await _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .set(userWithId.toJson());
  }

  Future<void> updateUserStats({
    required int age,
    required String gender,
    required double weight,
    required double height,
    required String activityLevel,
    required String goal,
  }) async {
    if (_currentUser == null) return;

    // Calculate new TDEE and Macros
    final bmr = TdeeCalculator.calculateBMR(weight: weight, height: height, age: age, gender: gender);
    final tdee = TdeeCalculator.calculateTDEE(bmr, activityLevel);
    final targetCalories = TdeeCalculator.calculateTargetCalories(tdee, goal);
    final macros = TdeeCalculator.calculateMacros(targetCalories, weight);

    final updatedUser = state?.copyWith(
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      activityLevel: activityLevel,
      goal: goal,
      tdee: targetCalories,
      proteinTarget: macros['protein']!,
      carbTarget: macros['carbs']!,
      fatTarget: macros['fat']!,
    ) ?? UserModel(
      id: _currentUser!.uid,
      email: _currentUser!.email ?? '',
      name: _currentUser!.displayName ?? 'User',
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      activityLevel: activityLevel,
      goal: goal,
      tdee: targetCalories,
      proteinTarget: macros['protein']!,
      carbTarget: macros['carbs']!,
      fatTarget: macros['fat']!,
    );

    await saveUser(updatedUser);
  }
  
  Future<void> clearUser() async {
    // No-op for Firestore (handled by auth state change)
    state = null;
  }
}
