import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'create_account_page.dart';

class OrganizationCredentialsPage extends StatefulWidget {
  final String organizationId;

  const OrganizationCredentialsPage({
    super.key,
    required this.organizationId,
  });

  @override
  State<OrganizationCredentialsPage> createState() =>
      _OrganizationCredentialsPageState();
}

class _OrganizationCredentialsPageState
    extends State<OrganizationCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  Future<String> _generateUniqueCode(String orgName) async {
    final orgNamePrefix = orgName.substring(0, 3).toUpperCase();
    final random = Random();
    String code;
    bool isUnique = false;

    while (!isUnique) {
      // Generate 2 random numbers between 2-9
      final num1 = random.nextInt(8) + 2;
      final num2 = random.nextInt(8) + 2;
      code = '$orgNamePrefix$num1$num2';

      // Check if code exists in Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .where('orgCode', isEqualTo: code)
          .get();

      if (snapshot.docs.isEmpty) {
        isUnique = true;
        return code;
      }
    }
    return ''; // This line will never be reached
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Get organization name from previous steps
      final orgDoc = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(widget.organizationId)
          .get();

      if (!orgDoc.exists) throw Exception('Organization details not found');

      final orgName = orgDoc.data()!['name'] as String;
      final orgCode = await _generateUniqueCode(orgName);

      // Update organization document with the code
      await FirebaseFirestore.instance
          .collection('organizations')
          .doc(widget.organizationId)
          .update({
        'orgCode': orgCode,
        'volunteers': [], // Initialize empty volunteers array
      });

      // Navigate to create account page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationCreateAccountPage(
              organizationId: widget.organizationId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '7. Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your organization code has been generated. Now, let\'s create your account to access the dashboard.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Account',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
