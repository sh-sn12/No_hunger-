import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerSettingsPage extends StatefulWidget {
  const VolunteerSettingsPage({super.key});

  @override
  State<VolunteerSettingsPage> createState() => _VolunteerSettingsPageState();
}

class _VolunteerSettingsPageState extends State<VolunteerSettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _locationServices = true;
  ThemeMode _themeMode = ThemeMode.system;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showThemePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setState(() => _themeMode = value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setState(() => _themeMode = value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setState(() => _themeMode = value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive email updates'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() => _emailNotifications = value);
            },
          ),
          _buildSectionHeader('Privacy'),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Allow access to your location'),
            value: _locationServices,
            onChanged: (bool value) {
              setState(() => _locationServices = value);
            },
          ),
          _buildSectionHeader('Appearance'),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeMode.name.capitalize()),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemePicker,
          ),
          _buildSectionHeader('Account'),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await _auth.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
