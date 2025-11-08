import 'package:flutter/material.dart';
import 'account_settings.dart';
import 'notification_settings.dart';
import 'privacy_settings.dart';
import 'help_support.dart';
import 'app_feedback.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            context,
            'Account Settings',
            Icons.person_outline,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage()),
            ),
          ),
          _buildSettingItem(
            context,
            'Notification Settings',
            Icons.notifications_none,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage()),
            ),
          ),
          _buildSettingItem(
            context,
            'Privacy & Data Settings',
            Icons.lock_outline,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PrivacySettingsPage()),
            ),
          ),
          _buildSettingItem(
            context,
            'Help and Support',
            Icons.help_outline,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportPage()),
            ),
          ),
          _buildSettingItem(
            context,
            'App Feedback',
            Icons.feedback_outlined,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppFeedbackPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}
