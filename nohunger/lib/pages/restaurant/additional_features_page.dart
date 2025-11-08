import 'package:flutter/material.dart';
import 'create_account_page.dart';

class AdditionalFeaturesPage extends StatefulWidget {
  final Map<String, String> restaurantInfo;

  const AdditionalFeaturesPage({
    super.key,
    required this.restaurantInfo,
  });

  @override
  State<AdditionalFeaturesPage> createState() => _AdditionalFeaturesPageState();
}

class _AdditionalFeaturesPageState extends State<AdditionalFeaturesPage> {
  final _formKey = GlobalKey<FormState>();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _twitterController = TextEditingController();
  final _workingTimeController = TextEditingController();
  String? _selectedRestaurantType;
  bool _acceptedTerms = false;
  bool _acceptedLegalTerms = false;

  final List<String> _restaurantTypes = [
    'Veg',
    'Non-Veg',
    'Veg & Non-Veg',
    'Fast Food',
    'Fine Dining',
    'Cafe',
    'Bakery',
    'Food Truck',
    'Cloud Kitchen',
  ];

  @override
  void dispose() {
    _instagramController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _workingTimeController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() &&
        _selectedRestaurantType != null &&
        _acceptedTerms &&
        _acceptedLegalTerms) {
      final additionalInfo = {
        ...widget.restaurantInfo,
        'instagram': _instagramController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'twitter': _twitterController.text.trim(),
        'restaurantType': _selectedRestaurantType!,
        'workingTime': _workingTimeController.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreateAccountPage(restaurantInfo: additionalInfo),
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
                '4. Additional Features',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Social Media:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Instagram',
                _instagramController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('@')) {
                      return 'Instagram handle should start with @';
                    }
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Facebook',
                _facebookController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('@')) {
                      return 'Facebook handle should start with @';
                    }
                  }
                  return null;
                },
              ),
              _buildTextField(
                'X (Twitter)',
                _twitterController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('@')) {
                      return 'Twitter handle should start with @';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Restaurant Type:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDropdownField('Veg/Non-Veg, Fast Food, Fine Dining'),
              _buildTextField(
                'Working Time',
                _workingTimeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Working time is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildCheckbox(
                'Accepted Terms and Conditions',
                _acceptedTerms,
                (value) => setState(() => _acceptedTerms = value!),
              ),
              _buildCheckbox(
                'I do here by promise that I have read the terms and conditions, and all the details provided are correct under Indian Law',
                _acceptedLegalTerms,
                (value) => setState(() => _acceptedLegalTerms = value!),
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
          labelText: label,
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

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(label, style: TextStyle(color: Colors.grey[400])),
                ),
                value: _selectedRestaurantType,
                items: _restaurantTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(type),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRestaurantType = newValue;
                  });
                },
              ),
            ),
          ),
          if (_selectedRestaurantType == null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Please select a restaurant type',
                style: TextStyle(color: Colors.red[400], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF8C42),
          ),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
