import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/user_service.dart';
import '../../services/food_log_service.dart';
import '../logging/quick_add_macros_screen.dart';
import '../logging/logging_screen.dart';
import '../food_search/food_search_screen.dart';

import '../../services/auth_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fabController;
  DateTime _currentDate = DateTime.now();
  final int _initialPage = 500;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    final daysDiff = page - _initialPage;
    setState(() {
      _currentDate = DateTime.now().add(Duration(days: daysDiff));
    });
  }

  Future<void> _refreshData() async {
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);
    
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF14B8A6)),
              const SizedBox(height: 16),
              const Text(
                'Loading your profile...',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                },
                child: const Text(
                  'Stuck? Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final streak = ref.read(foodLogServiceProvider.notifier).getCurrentStreak();
    final isToday = _currentDate.day == DateTime.now().day &&
        _currentDate.month == DateTime.now().month &&
        _currentDate.year == DateTime.now().year;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: _buildAppBar(streak),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF14B8A6),
        backgroundColor: const Color(0xFF1E293B),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final daysDiff = index - _initialPage;
            final date = DateTime.now().add(Duration(days: daysDiff));
            return _buildDayView(date, user);
          },
        ),
      ),
      floatingActionButton: isToday ? _buildFloatingActionButton() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(int streak) {
    final isToday = _currentDate.day == DateTime.now().day &&
        _currentDate.month == DateTime.now().month &&
        _currentDate.year == DateTime.now().year;

    return AppBar(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      centerTitle: true,
      title: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _currentDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF14B8A6),
                    surface: Color(0xFF1E293B),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            final daysDiff = picked.difference(DateTime.now()).inDays;
            _pageController.jumpToPage(_initialPage + daysDiff);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday ? 'Today' : DateFormat('EEE, MMM d').format(_currentDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
      leading: streak > 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '$streak',
                        style: const TextStyle(
                          color: Color(0xFF14B8A6),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      actions: [
        if (!isToday)
          TextButton(
            onPressed: () => _pageController.jumpToPage(_initialPage),
            child: const Text(
              'Today',
              style: TextStyle(color: Color(0xFF14B8A6)),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoggingScreen(
            mealType: _detectMealType(),
          )),
        );
      },
      backgroundColor: const Color(0xFF14B8A6),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Log Food',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDayView(DateTime date, user) {
    final dailyTotals = ref.read(foodLogServiceProvider.notifier).getDailyTotals(date);
    final caloriesPercent = (dailyTotals['calories']! / user.tdee).clamp(0.0, 1.0);
    final hasData = dailyTotals['calories']! > 0;

    // Get weekly data for summary
    final mondayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final weeklyTotals = ref.read(foodLogServiceProvider.notifier).getWeeklyTotals(mondayOfWeek);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Weekly Summary Card (only show on today)
          if (date.day == DateTime.now().day && 
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year)
            _buildWeeklySummaryCard(weeklyTotals),

          // Daily Summary Card
          _buildDailySummaryCard(user, dailyTotals, caloriesPercent),

          // Recent Foods (quick add)
          if (hasData) _buildRecentFoodsSection(),

          // Meal Sections
          _buildMealSection('Breakfast 🌅', date),
          _buildMealSection('Lunch ☀️', date),
          _buildMealSection('Dinner 🌙', date),
          _buildMealSection('Snacks 🍎', date),

          // Empty State
          if (!hasData) _buildEmptyState(),

          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard(Map<String, double> weeklyTotals) {
    final daysLogged = weeklyTotals['daysLogged']!.toInt();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF14B8A6).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_view_week,
                  color: Color(0xFF14B8A6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            daysLogged > 0 
                ? 'Average Daily Macros • $daysLogged days logged'
                : 'Start logging to see weekly insights',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          if (daysLogged > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeeklyMacro('Calories', weeklyTotals['calories']!.toInt(), 'kcal', const Color(0xFF14B8A6)),
                _buildWeeklyMacro('Protein', weeklyTotals['protein']!.toInt(), 'g', const Color(0xFF8B5CF6)),
                _buildWeeklyMacro('Carbs', weeklyTotals['carbs']!.toInt(), 'g', const Color(0xFF3B82F6)),
                _buildWeeklyMacro('Fat', weeklyTotals['fat']!.toInt(), 'g', const Color(0xFFF59E0B)),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '📊',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMacro(String label, int value, String unit, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentFoodsSection() {
    final recentFoods = ref.read(foodLogServiceProvider.notifier).getRecentFoods(limit: 5);
    
    if (recentFoods.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.history, color: Color(0xFF14B8A6), size: 16),
                SizedBox(width: 8),
                Text(
                  'Recent Foods - Quick Add',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentFoods.length,
              itemBuilder: (context, index) {
                final food = recentFoods[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Quick re-log logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quick add: ${food.name}'),
                            backgroundColor: const Color(0xFF14B8A6),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${food.calories.toInt()} kcal',
                              style: const TextStyle(
                                color: Color(0xFF14B8A6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '🍽️',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'No meals logged today',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start tracking your nutrition journey',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          // Button removed as requested
        ],
      ),
    );
  }

  Widget _buildDailySummaryCard(user, Map<String, double> totals, double caloriesPercent) {
    final remaining = user.tdee - totals['calories']!;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF1E293B).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14B8A6).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Calorie Progress with Animation
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${totals['calories']!.toInt()}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14B8A6),
                          ),
                        ),
                        Text(
                          ' / ${user.tdee.toInt()}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Calories',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                        if (remaining > 0) ...[
                          const Text(' • ', style: TextStyle(color: Color(0xFF94A3B8))),
                          Text(
                            '${remaining.toInt()} remaining',
                            style: const TextStyle(
                              color: Color(0xFF14B8A6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: caloriesPercent),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: const Color(0xFF334155),
                            color: const Color(0xFF14B8A6),
                            minHeight: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Macro Breakdown with Animations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroIndicator(
                'Protein',
                totals['protein']!,
                user.proteinTarget,
                const Color(0xFF8B5CF6),
              ),
              _buildMacroIndicator(
                'Carbs',
                totals['carbs']!,
                user.carbTarget,
                const Color(0xFF3B82F6),
              ),
              _buildMacroIndicator(
                'Fat',
                totals['fat']!,
                user.fatTarget,
                const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroIndicator(String label, double current, double target, Color color) {
    final percent = (current / target).clamp(0.0, 1.0);
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: percent),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      current.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/ ${target.toInt()}g',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealSection(String mealName, DateTime date) {
    final logs = ref.watch(foodLogServiceProvider).where((log) {
      return log.timestamp.year == date.year &&
             log.timestamp.month == date.month &&
             log.timestamp.day == date.day;
    }).toList();
    
    // Use mealType field instead of timestamp!
    final cleanMealName = mealName.split(' ')[0]; // Remove emoji
    final mealLogs = logs.where((log) => log.mealType == cleanMealName).toList();

    final mealTotal = mealLogs.fold<double>(0.0, (sum, log) => sum + log.calories);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: mealLogs.isNotEmpty 
              ? const Color(0xFF14B8A6).withValues(alpha: 0.3)
              : const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              mealName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mealTotal > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${mealTotal.toInt()} kcal',
                      style: const TextStyle(
                        color: Color(0xFF14B8A6),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF14B8A6), size: 28),
                  onPressed: () => _showAddFoodOptions(date, cleanMealName),
                ),
              ],
            ),
          ),

          if (mealLogs.isNotEmpty)
            ...mealLogs.map((log) => Dismissible(
                  key: ValueKey(log.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) {
                    final deletedLog = log; // Store log before deletion
                    ref.read(foodLogServiceProvider.notifier).deleteLog(log.id);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${log.name} deleted',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: const Color(0xFF334155),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'UNDO',
                          textColor: const Color(0xFF14B8A6),
                          onPressed: () {
                            // Check if widget is still mounted before using ref
                            if (context.mounted) {
                              ref.read(foodLogServiceProvider.notifier).addLog(deletedLog);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        log.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'P: ${log.protein.toInt()}g  •  C: ${log.carbs.toInt()}g  •  F: ${log.fat.toInt()}g',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${log.calories.toInt()}',
                          style: const TextStyle(
                            color: Color(0xFF14B8A6),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          if (mealLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'No items logged',
                style: TextStyle(
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.6),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Detects meal type based on current time
  String _detectMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Breakfast';
    if (hour >= 11 && hour < 17) return 'Lunch';
    if (hour >= 17 && hour < 21) return 'Dinner';
    return 'Snacks';
  }

  void _showAddFoodOptions(DateTime date, String? mealName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildQuickActionTile(
                icon: Icons.psychology,
                title: 'AI Food Analysis',
                subtitle: 'Photo or text description',
                color: const Color(0xFF14B8A6),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoggingScreen(
                        mealType: mealName ?? _detectMealType(), // Use meal type or detect from time
                        selectedDate: date,
                      ),
                    ),
                  );
                },
              ),
              _buildQuickActionTile(
                icon: Icons.edit_note,
                title: 'Quick Add Macros',
                subtitle: 'Manual entry',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuickAddMacrosScreen(
                        mealType: mealName ?? _detectMealType(), // Use meal type or detect from time
                        selectedDate: date,
                      ),
                    ),
                  );
                },
              ),
              _buildQuickActionTile(
                icon: Icons.search,
                title: 'Search Database',
                subtitle: 'Find verified foods',
                color: const Color(0xFF3B82F6),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodSearchScreen(
                        mealType: mealName ?? _detectMealType(), // Use meal type or detect from time
                        selectedDate: date,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: color.withValues(alpha: 0.5),
          size: 16,
        ),
      ),
    );
  }
}
