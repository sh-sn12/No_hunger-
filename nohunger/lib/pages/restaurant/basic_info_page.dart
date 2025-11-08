import 'package:flutter/material.dart';
import 'legal_compliance_page.dart';

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({super.key});

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _landlineNumberController = TextEditingController();

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _ownerNameController.dispose();
    _registrationNumberController.dispose();
    _mobileNumberController.dispose();
    _landlineNumberController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final restaurantInfo = {
        'restaurantName': _restaurantNameController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'registrationNumber': _registrationNumberController.text.trim(),
        'mobileNumber': _mobileNumberController.text.trim(),
        'landlineNumber': _landlineNumberController.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LegalCompliancePage(restaurantInfo: restaurantInfo),
        ),
      );
    }
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
                '1. Basic Restaurant\nInformation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                'Restaurant Name',
                _restaurantNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Restaurant name is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Owner/Manager Name',
                _ownerNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Owner/Manager name is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Business Registration Number',
                _registrationNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business registration number is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Contact Number (Mobile)',
                _mobileNumberController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Contact Number (Landline)',
                _landlineNumberController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit landline number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: '$label *',
          labelStyle: const TextStyle(color: Colors.black87),
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFF8C42)),
          ),
        ),
      ),
    );
  }
}
