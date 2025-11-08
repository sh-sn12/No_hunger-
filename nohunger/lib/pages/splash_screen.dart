import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nohunger/firebase_options.dart';
import 'package:nohunger/pages/admin/admin_dashboard.dart';
import 'package:nohunger/pages/service_provider/dashboard.dart';
import 'package:nohunger/pages/volunteer/dashboard.dart';
import 'package:nohunger/pages/organization/organization_dashboard.dart';
import 'package:nohunger/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeFirebase();
    }
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _checkUserState();
  }

  Future<void> _checkUserState() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // User is logged in, check their role and navigate accordingly
    try {
      final userRole = await AuthService.getUserRole(user.uid);

      if (!mounted) return;

      if (userRole == null) {
        // User document not found, navigate to login
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      switch (userRole.role.toLowerCase()) {
        case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
          break;
        case 'restaurant':
        case 'catering':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceProviderDashboard(
                username: user.displayName ?? "",
                userType: userRole.role,
              ),
            ),
          );
          break;
        case 'volunteer':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VolunteerDashboard(
                username: user.displayName ?? "",
                userType: 'volunteer',
              ),
            ),
          );
          break;
        case 'organization':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OrganizationDashboard(),
            ),
          );
          break;
        default:
          // Unknown role, navigate to login
          Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // Error occurred, navigate to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
