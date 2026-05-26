import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/data_provider.dart';
import 'theme.dart';
import 'screens/shell/app_shell.dart';
import 'screens/auth/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: const ClubOsApp(),
    ),
  );
}

class ClubOsApp extends StatelessWidget {
  const ClubOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    return MaterialApp(
      title: 'ClubOS by Nag Prathik',
      debugShowCheckedModeBanner: false,
      theme: ClubOsTheme.lightTheme,
      darkTheme: ClubOsTheme.darkTheme,
      themeMode: dataProvider.themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const AppShell();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const AppShell(),
      },
    );
  }
}
