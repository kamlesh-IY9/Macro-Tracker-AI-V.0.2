import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final waterServiceProvider = StateNotifierProvider<WaterService, int>((ref) {
  return WaterService();
});

class WaterService extends StateNotifier<int> {
  WaterService() : super(0) {
    _loadWater();
  }

  // Default goal: 2500ml (approx 8 glasses)
  static const int dailyGoal = 2500;
  static const int glassSize = 250;

  String get _key => 'water_${DateFormat('yyyyMMdd').format(DateTime.now())}';

  Future<void> _loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 0;
  }

  Future<void> addWater(int amount) async {
    state += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, state);
  }

  Future<void> removeWater(int amount) async {
    if (state >= amount) {
      state -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, state);
    }
  }
  
  Future<void> reset() async {
    state = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
