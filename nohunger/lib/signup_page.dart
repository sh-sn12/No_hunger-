import 'package:flutter/material.dart';
import 'pages/restaurant/basic_info_page.dart';
import 'pages/catering/basic_info_page.dart';
import 'pages/organization/basic_info_page.dart';
import 'pages/others/basic_info_page.dart';
import 'pages/volunteer/signup_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choose Account Type',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C42),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildOptionButton(context, 'Restaurant', Icons.restaurant, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicInfoPage(),
                  ),
                );
              }),
              const SizedBox(height: 16),
              _buildOptionButton(
                context,
                'Catering Services',
                Icons.restaurant_menu,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CateringBasicInfoPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(context, 'Organization', Icons.business, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganizationBasicInfoPage(),
                  ),
                );
              }),
              const SizedBox(height: 16),
              _buildOptionButton(context, 'Others', Icons.people, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OthersBasicInfoPage(),
                  ),
                );
              }),
              const SizedBox(height: 16),
              _buildOptionButton(context, 'Volunteer', Icons.volunteer_activism,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VolunteerSignupPage(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFFF8C42),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFFF8C42)),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
