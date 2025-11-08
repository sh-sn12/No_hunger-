import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'signup_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/service_provider/dashboard.dart';
import 'pages/volunteer/dashboard.dart';
import 'pages/organization/organization_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _handleAdminLogin() {
    if (_emailController.text.trim() == 'admin@gmail.com' &&
        _passwordController.text == 'adminpass') {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid admin credentials')),
      );
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Check for admin login first
      if (_emailController.text.trim() == 'admin@gmail.com' &&
          _passwordController.text.trim() == 'adminpass') {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
        //return;
      }

      try {
        print('Attempting Firebase login');
        // Regular Firebase login
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        print('Firebase login successful, getting user role');
        if (mounted) {
          // Get user role from Firestore
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (!userDoc.exists) {
            print('User document not found in Firestore');
            throw Exception('User data not found');
          }

          final userType = userDoc.data()!['role'] as String;
          final username = userDoc.data()!['name'] as String? ?? 'User';

          print('User role found: $userType');
          setState(() => _isLoading = false);

          // Navigate based on user role
          switch (userType) {
            case 'admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDashboard(),
                ),
              );
              break;
            case 'restaurant':
            case 'catering':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceProviderDashboard(
                    username: _emailController.text.trim(),
                    userType: userType,
                  ),
                ),
              );
              break;
            case 'organization':
              // Check if organization exists in Firestore
              final orgDoc = await FirebaseFirestore.instance
                  .collection('organizations')
                  .where('authUid', isEqualTo: userCredential.user!.uid)
                  .get();

              if (orgDoc.docs.isEmpty) {
                setState(() {
                  _isLoading = false;
                  _errorMessage =
                      'Organization not found. Please contact support.';
                });
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrganizationDashboard(),
                ),
              );
              break;
            case 'volunteer':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VolunteerDashboard(
                    username: _emailController.text.trim(),
                    userType: 'volunteer',
                  ),
                ),
              );
              break;
            case 'other':
              // Navigate to other user dashboard
              break;
          }
        }
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found with this email';
            break;
          case 'wrong-password':
            message = 'Wrong password provided';
            break;
          case 'invalid-email':
            message = 'Invalid email address';
            break;
          default:
            message = 'An error occurred. Please try again';
        }
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        print('General Error: $e');
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Image.asset(
                  'assets/logo1.jpg',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  'NO HUNGER',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF8C42),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
