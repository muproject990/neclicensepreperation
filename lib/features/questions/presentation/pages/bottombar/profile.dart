import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/auth/presentation/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with real user data from Supabase
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    user!.userMetadata?['avatar_url'] ??
                        'https://via.placeholder.com/150'), // Placeholder image
              ),
            ),
            const SizedBox(height: 16),
            // User Name
            Center(
              child: Text(
                user.userMetadata?['full_name'] ?? 'User Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user.email ?? 'user@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // User Info Section
            Text(
              'User Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${user.email ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text('Phone: ${user.userMetadata?['phone'] ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text(
                        'Location: ${user.userMetadata?['location'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your edit profile functionality here
                  },
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your logout functionality here
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
