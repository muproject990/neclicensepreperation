import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/auth/presentation/signup_page.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/stats.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/profile.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/main_page_mcq.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/AI_Chatbot/AIBOT.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MCQMainPage(), // Assuming HomePage is your existing home page
    const StatisticsChart(data: 'DL'),
    const AIBOT("Hi", "", "", "", ""),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // Index for Logout
      _logout();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // Successfully logged out
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    } catch (error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex], // Display the selected page here
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'AI BOT',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blueAccent, // Color for the selected item
          unselectedItemColor: Colors.white, // Color for unselected items
          backgroundColor: Colors.blueGrey[800], // Background color
          type:
              BottomNavigationBarType.fixed, // Fixed type for a consistent look
          onTap: _onItemTapped,
          elevation: 8, // Shadow effect
          selectedFontSize: 14, // Font size for selected item
          unselectedFontSize: 12, // Font size for unselected items
        ));
  }
}
