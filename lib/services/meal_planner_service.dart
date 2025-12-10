import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_plan_model.dart';
import 'auth_service.dart';

final mealPlannerServiceProvider = StateNotifierProvider<MealPlannerService, List<MealPlan>>((ref) {
  final authState = ref.watch(authStateProvider);
  return MealPlannerService(authState.value);
});

class MealPlannerService extends StateNotifier<List<MealPlan>> {
  final User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MealPlannerService(this._currentUser) : super([]) {
    if (_currentUser != null) {
      _subscribeToPlans();
    }
  }

  void _subscribeToPlans() {
    _firestore
        .collection('meal_plans')
        .where('userId', isEqualTo: _currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      final plans = snapshot.docs.map((doc) {
        return MealPlan.fromJson(doc.data());
      }).toList();
      
      state = plans;
    });
  }

  Future<void> savePlan(MealPlan plan) async {
    if (_currentUser == null) return;
    
    final planWithUser = plan.copyWith(userId: _currentUser!.uid);
    await _firestore.collection('meal_plans').doc(plan.id).set(planWithUser.toJson());
  }

  Future<void> deletePlan(String id) async {
    if (_currentUser == null) return;
    await _firestore.collection('meal_plans').doc(id).delete();
  }
  
  MealPlan? getCurrentPlan() {
    if (state.isEmpty) return null;
    return state.last;
  }
}
