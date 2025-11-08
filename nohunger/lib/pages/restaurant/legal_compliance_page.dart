import 'package:flutter/material.dart';
import 'location_page.dart';

class LegalCompliancePage extends StatefulWidget {
  final Map<String, String> restaurantInfo;

  const LegalCompliancePage({
    super.key,
    required this.restaurantInfo,
  });

  @override
  State<LegalCompliancePage> createState() => _LegalCompliancePageState();
}

class _LegalCompliancePageState extends State<LegalCompliancePage> {
  final _formKey = GlobalKey<FormState>();
  final _fssaiIdController = TextEditingController();
  final _gstinController = TextEditingController();
  final _shopsRegNumberController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _msmeRegController = TextEditingController();

  @override
  void dispose() {
    _fssaiIdController.dispose();
    _gstinController.dispose();
    _shopsRegNumberController.dispose();
    _tradeLicenseController.dispose();
    _msmeRegController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final legalInfo = {
        ...widget.restaurantInfo,
        'fssaiId': _fssaiIdController.text.trim(),
        'gstin': _gstinController.text.trim(),
        'shopsRegNumber': _shopsRegNumberController.text.trim(),
        'tradeLicense': _tradeLicenseController.text.trim(),
        'msmeReg': _msmeRegController.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPage(restaurantInfo: legalInfo),
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
                '2. Legal & Compliance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                'FSSAI Certification ID',
                _fssaiIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'FSSAI Certification ID is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'GSTIN (Goods and Services Tax\nIdentification Number)',
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
                'Shops & Establishments\nRegistration Number',
                _shopsRegNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Registration number is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Trade License Number',
                _tradeLicenseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Trade license number is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'MSME Registration (Udyam\nRegistration)',
                _msmeRegController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'MSME registration number is required';
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
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
