import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _globalNotifications = true;
  bool _banners = true;
  bool _badges = true;
  bool _lockScreenDisplay = true;
  bool _popups = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _inAppNotifications = true;
  bool _smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notification Settings',
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
          _buildSection(
            'Global Notifications',
            _globalNotifications,
            (value) => setState(() => _globalNotifications = value),
          ),
          const Divider(),
          _buildHeader('Notification Style'),
          _buildSettingItem(
            'Banners',
            _banners,
            (value) => setState(() => _banners = value),
          ),
          _buildSettingItem(
            'Badges',
            _badges,
            (value) => setState(() => _badges = value),
          ),
          _buildSettingItem(
            'Lock screen display',
            _lockScreenDisplay,
            (value) => setState(() => _lockScreenDisplay = value),
          ),
          _buildSettingItem(
            'Pop-ups',
            _popups,
            (value) => setState(() => _popups = value),
          ),
          const Divider(),
          _buildHeader('Notification Types'),
          _buildSettingItem(
            'Push Notifications',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          _buildSettingItem(
            'Email Notifications',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          _buildSettingItem(
            'In-App Notifications',
            _inAppNotifications,
            (value) => setState(() => _inAppNotifications = value),
          ),
          _buildSettingItem(
            'SMS Notifications',
            _smsNotifications,
            (value) => setState(() => _smsNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSection(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSettingItem(
      String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
