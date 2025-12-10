import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../services/user_service.dart';
import '../../services/weight_service.dart';
import '../../services/food_log_service.dart';
import '../weight/weight_screen.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  ConsumerState<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends ConsumerState<TrendsScreen> {
  int _selectedRange = 30; // 7, 30, 90 days

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Trends'),
        actions: [
          PopupMenuButton<int>(
            initialValue: _selectedRange,
            onSelected: (range) => setState(() => _selectedRange = range),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('Last 7 Days')),
              const PopupMenuItem(value: 30, child: Text('Last 30 Days')),
              const PopupMenuItem(value: 90, child: Text('Last 90 Days')),
            ],
          ),
        ],
      ),
      body: _buildBody(user),
    );
  }

  Widget _buildBody(user) {
    // Check if user has any data
    final weightLogs = ref.watch(weightServiceProvider);
    final foodLogs = ref.watch(foodLogServiceProvider);
    final hasData = weightLogs.isNotEmpty || foodLogs.isNotEmpty;

    if (!hasData) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWeightTrendCard(user),
          _buildExpenditureTrendCard(user),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.ssid_chart,
                size: 60,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Trends Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start logging your weight and meals to see your progress over time',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeightScreen()),
                );
              },
              icon: const Icon(Icons.monitor_weight_outlined),
              label: const Text('Log First Weight'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightTrendCard(user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weight Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeightScreen()),
                  );
                },
                child: const Text(
                  'Log Weight',
                  style: TextStyle(color: Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Weight chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF334155),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 7 == 0) {
                          final date = DateTime.now().subtract(Duration(days: _selectedRange - value.toInt()));
                          return Text(
                            DateFormat('M/d').format(date),
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1E293B),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final date = DateTime.now().subtract(Duration(days: _selectedRange - 1 - spot.x.toInt()));
                        return LineTooltipItem(
                          '${DateFormat('MMM d').format(date)}\n',
                          const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          children: [
                            TextSpan(
                              text: '${spot.y.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getWeightSpots(),
                    isCurved: true,
                    color: const Color(0xFF8B5CF6),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withOpacity(0.3),
                          const Color(0xFF8B5CF6).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Current weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Weight',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
              Text(
                '${user.weight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenditureTrendCard(user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expenditure Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Daily Calories vs TDEE',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          
          // TDEE chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF334155),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 7 == 0) {
                          final date = DateTime.now().subtract(Duration(days: _selectedRange - value.toInt()));
                          return Text(
                            DateFormat('M/d').format(date),
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1E293B),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final date = DateTime.now().subtract(Duration(days: _selectedRange - 1 - spot.x.toInt()));
                        return LineTooltipItem(
                          '${DateFormat('MMM d').format(date)}\n',
                          const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          children: [
                            TextSpan(
                              text: '${spot.y.toInt()} kcal',
                              style: const TextStyle(
                                color: Color(0xFF14B8A6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getTDEESpots(user),
                    isCurved: true,
                    color: const Color(0xFF14B8A6),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF14B8A6).withOpacity(0.3),
                          const Color(0xFF14B8A6).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Current TDEE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current TDEE',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
              Text(
                '${user.tdee.toInt()} kcal',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWeightSpots() {
    final weightLogs = ref.watch(weightServiceProvider);
    if (weightLogs.isEmpty) return [];

    final spots = <FlSpot>[];
    final now = DateTime.now();
    
    // Create a map of date to weight for easier lookup
    // We only care about the last _selectedRange days
    final Map<int, double> dayWeights = {};
    
    for (var log in weightLogs) {
      final difference = now.difference(log.timestamp).inDays;
      if (difference < _selectedRange && difference >= 0) {
        // Use the latest weight for that day (since logs are sorted newest first)
        if (!dayWeights.containsKey(difference)) {
          dayWeights[difference] = log.weight;
        }
      }
    }

    // If no logs in range, return empty or just current weight
    if (dayWeights.isEmpty) {
      final user = ref.read(userServiceProvider);
      return [FlSpot(0, user?.weight ?? 70.0)];
    }

    // Generate spots
    for (var i = 0; i < _selectedRange; i++) {
      // x-axis: 0 is today, _selectedRange is oldest
      // We want to plot from oldest (left) to newest (right)
      // So x=0 should be oldest day? No, usually x axis is time.
      // Let's make x=0 be (_selectedRange - 1) days ago, and x=_selectedRange-1 be today.
      
      final daysAgo = (_selectedRange - 1) - i;
      
      // Find weight for this day, or use previous known weight
      double? weight;
      if (dayWeights.containsKey(daysAgo)) {
        weight = dayWeights[daysAgo];
      } else {
        // Look for most recent previous weight
        for (var d = daysAgo + 1; d < 365; d++) {
          if (dayWeights.containsKey(d)) {
            weight = dayWeights[d];
            break;
          }
        }
        // If still null, look forward (future logs? unlikely but possible if sparse)
        if (weight == null) {
           for (var d = daysAgo - 1; d >= 0; d--) {
            if (dayWeights.containsKey(d)) {
              weight = dayWeights[d];
              break;
            }
          }
        }
      }
      
      if (weight != null) {
        spots.add(FlSpot(i.toDouble(), weight));
      }
    }
    
    return spots;
  }

  List<FlSpot> _getTDEESpots(user) {
    // For expenditure, we'll show Daily Calories Consumed vs TDEE
    // This is more useful than just a flat TDEE line
    final spots = <FlSpot>[];
    final now = DateTime.now();
    
    for (var i = 0; i < _selectedRange; i++) {
      final daysAgo = (_selectedRange - 1) - i;
      final date = now.subtract(Duration(days: daysAgo));
      
      final totals = ref.read(foodLogServiceProvider.notifier).getDailyTotals(date);
      final calories = totals['calories'] ?? 0.0;
      
      spots.add(FlSpot(i.toDouble(), calories));
    }
    return spots;
  }
}
