import 'package:flutter/material.dart';

/// Widget that displays Firebase configuration status and instructions
class FirebaseConfigChecker extends StatelessWidget {
  const FirebaseConfigChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Setup Required'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Firebase Not Configured',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your app is using demo Firebase credentials. To enable real authentication:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildStep(
                '1',
                'Create Firebase Project',
                'Go to https://console.firebase.google.com/\nClick "Add project" and follow the wizard',
              ),
              _buildStep(
                '2',
                'Add Android App',
                'Package name: com.fundo.fundo_flutter\nDownload google-services.json\nPlace in: android/app/google-services.json',
              ),
              _buildStep(
                '3',
                'Get SHA-1 Certificate',
                'Run in PowerShell:\n.\get_sha1.ps1\n\nCopy the SHA-1 value shown',
              ),
              _buildStep(
                '4',
                'Add SHA-1 to Firebase',
                'In Firebase Console:\n- Project Settings > Your apps\n- Find Android app\n- Click "Add fingerprint"\n- Paste SHA-1 and save',
              ),
              _buildStep(
                '5',
                'Enable Authentication',
                'In Firebase Console:\n- Authentication > Sign-in method\n- Enable "Email/Password"\n- Enable "Google"\n- Set support email',
              ),
              _buildStep(
                '6',
                'Update Firebase Config',
                'Update lib/firebase_options.dart with:\n- Real API keys from Firebase Console\n- Real project ID\n- Real app IDs',
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                '📱 Your OAuth Client ID:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  '415208406640-iqdsluhi1rq8ghu5ed85f4uehori5nej.apps.googleusercontent.com',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Could open browser to Firebase Console
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Firebase Console'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Login'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
