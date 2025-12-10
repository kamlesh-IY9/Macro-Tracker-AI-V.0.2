import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
    
    // Enable Firestore offline persistence
    // This allows the app to work offline and sync when back online
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint('✅ Firestore offline persistence enabled');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
    debugPrint('ℹ️ Please update lib/firebase_options.dart with your API keys');
  }

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'MacroMate AI',
  );

  runApp(
    const ProviderScope(
      child: MacroTrackerApp(),
    ),
  );
}

class MacroTrackerApp extends ConsumerWidget {
  const MacroTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'MacroMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: authState.when(
        data: (user) => user == null ? const SplashScreen() : const SplashScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SplashScreen(),
      ),
    );
  }
}
