import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/auth/presentation/signup_page.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/stats.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/profile.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/main_page_mcq.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _currentIndex = 0;
  String? _selectedData; // Variable to hold the selected data for the chart

  // List of dropdown options for statistics
  final List<String> _dataOptions = [
    'DL',
    'Programming',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
    'Option 7',
    'Option 8',
    'Option 9',
    'Option 10',
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _logout();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  List<Widget> get _pages {
    return [
      const MCQMainPage(), // Home Page
      StatisticsChart(data: _selectedData ?? 'DL'), // Statistics Page
      ProfilePage(), // Profile Page
    ];
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $error'),
        ),
      );
    }
  }

  void _onDataSelected(String? newValue) {
    setState(() {
      _selectedData = newValue; // Update the selected data
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update the StatisticsChart with the selected data
    final statisticsChart = StatisticsChart(data: _selectedData ?? 'DL');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _currentIndex == 1 ? statisticsChart : _pages[_currentIndex],
          ),
          // Dropdown moved to the bottom, just above the BottomNavigationBar
          if (_currentIndex == 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: _selectedData,
                hint: const Text('Select data for statistics'),
                borderRadius: BorderRadius.circular(15),
                items: _dataOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: _onDataSelected,
              ),
            ),
        ],
      ),
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
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blueGrey[800],
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        elevation: 8,
        selectedFontSize: 14,
        unselectedFontSize: 12,
      ),
    );
  }
}
