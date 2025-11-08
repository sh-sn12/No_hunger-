import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contact_location_page.dart';

class OrganizationBasicInfoPage extends StatefulWidget {
  const OrganizationBasicInfoPage({super.key});

  @override
  State<OrganizationBasicInfoPage> createState() =>
      _OrganizationBasicInfoPageState();
}

class _OrganizationBasicInfoPageState extends State<OrganizationBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ngoRegController = TextEditingController();
  final _g80Controller = TextEditingController();
  final _msmeController = TextEditingController();
  final _gstController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveBasicInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create a new document in the organizations collection
      final docRef =
          await FirebaseFirestore.instance.collection('organizations').add({
        'name': _nameController.text.trim(),
        'ngoRegistrationNumber': _ngoRegController.text.trim(),
        'g80Certificate': _g80Controller.text.trim(),
        'msmeRegistration': _msmeController.text.trim(),
        'gstRegistrationNumber': _gstController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'volunteers': [], // Initialize empty volunteers array
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationContactLocationPage(
              organizationId: docRef.id,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ngoRegController.dispose();
    _g80Controller.dispose();
    _msmeController.dispose();
    _gstController.dispose();
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
                '1. Basic Organisation\nInformation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name of Organisation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter organization name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ngoRegController,
                decoration: const InputDecoration(
                  labelText: 'NGO Registration Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NGO registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _g80Controller,
                decoration: const InputDecoration(
                  labelText: '80G Certificate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter 80G certificate number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _msmeController,
                decoration: const InputDecoration(
                  labelText: 'MSME Registration',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter MSME registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gstController,
                decoration: const InputDecoration(
                  labelText: 'GST Registration Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter GST registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBasicInfo,
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
                      : const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
