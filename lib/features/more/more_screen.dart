import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../recipes/recipes_list_screen.dart';
import '../settings/settings_screen.dart';
import '../settings/edit_profile_screen.dart';
import '../auth/login_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            Icons.person,
            'Profile',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          _buildMenuItem(
            context,
            Icons.flag,
            'Goals & Targets',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          _buildMenuItem(
            context,
            Icons.restaurant,
            'Recipes',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecipesListScreen()),
              );
            },
          ),
          _buildMenuItem(context, Icons.add_circle, 'Custom Foods', () {}),
          _buildMenuItem(
            context,
            Icons.settings,
            'Settings',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          _buildMenuItem(
            context,
            Icons.help,
            'Help & Support',
            () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Help & Support'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MacroMate AI',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Version: 1.0.0'),
                      SizedBox(height: 16),
                      Text('Need help?'),
                      SizedBox(height: 8),
                      Text(
                          '• Email: support@macromate.com\n• Check our FAQ in Settings\n• All features work offline'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(color: Color(0xFF334155)),
          _buildMenuItem(
            context,
            Icons.logout,
            'Logout',
            () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true && context.mounted) {
                await ref.read(authServiceProvider).signOut();
                // Navigate to login screen and clear navigation stack
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false, // Remove all previous routes
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF14B8A6)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
      onTap: onTap,
    );
  }
}
