import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'firebase_options.dart'; // Generate this with FlutterFire CLI

import 'screens/home_screen.dart';
import 'screens/speech_practice_screen.dart';
import 'screens/mirror_screen.dart';
import 'screens/stories_screen.dart';
import 'screens/caregiver_studio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/practice', builder: (context, state) => SpeechPracticeScreen()),
      GoRoute(path: '/mirror', builder: (context, state) => MirrorScreen()),
      GoRoute(path: '/stories', builder: (context, state) => StoriesScreen()),
      GoRoute(path: '/caregiver', builder: (context, state) => CaregiverStudioScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Autism Support App',
      theme: ThemeData(useMaterial3: true),
      routerConfig: _router,
    );
  }
}