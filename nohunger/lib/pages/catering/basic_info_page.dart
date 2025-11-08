import 'package:flutter/material.dart';
import 'location_page.dart';

class CateringBasicInfoPage extends StatefulWidget {
  const CateringBasicInfoPage({super.key});

  @override
  State<CateringBasicInfoPage> createState() => _CateringBasicInfoPageState();
}

class _CateringBasicInfoPageState extends State<CateringBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _organizationNameController = TextEditingController();
  final _fssaiLicenseController = TextEditingController();
  final _gstinController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _tradeLicenseController = TextEditingController();

  @override
  void dispose() {
    _organizationNameController.dispose();
    _fssaiLicenseController.dispose();
    _gstinController.dispose();
    _ownerNameController.dispose();
    _tradeLicenseController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final cateringInfo = {
        'organizationName': _organizationNameController.text.trim(),
        'fssaiLicense': _fssaiLicenseController.text.trim(),
        'gstin': _gstinController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'tradeLicense': _tradeLicenseController.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CateringLocationPage(cateringInfo: cateringInfo),
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
                '1. Basic Catering\nServices Information',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                'Name of Organisation',
                _organizationNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Organization name is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'FSSAI License Number',
                _fssaiLicenseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'FSSAI License number is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'GSTIN',
                _gstinController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'GSTIN is required';
                  }
                  if (!RegExp(
                          r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid GSTIN';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Owner\'s Name',
                _ownerNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Owner\'s name is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Trade License',
                _tradeLicenseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Trade license is required';
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
