import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl1_kasir/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fuyrgioxaitonwsnuywl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1eXJnaW94YWl0b253c251eXdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTMyMjIsImV4cCI6MjA0NzEyOTIyMn0.ftcAkCZsrDh1ZxofgE5q2JOU-ICccTOakRFfhtG6isc');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWelcomeScreen(),
    );
  }
}