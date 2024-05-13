import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/secrets/supabase_secret.dart';
import 'package:neclicensepreperation/core/theme.dart';
import 'package:neclicensepreperation/features/auth/presentation/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  final supabase = Supabase.initialize(
    url: AppSecrets.supabaseAnonKey,
    anonKey: AppSecrets.supabaseUrl,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const SignUpPage(),
    );
  }
}
