import 'package:flutter/material.dart';
import 'additional_features_page.dart';

class LocationPage extends StatefulWidget {
  final Map<String, String> restaurantInfo;

  const LocationPage({
    super.key,
    required this.restaurantInfo,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _mapsLocationController = TextEditingController();
  String? _selectedState;

  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _pincodeController.dispose();
    _mapsLocationController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() && _selectedState != null) {
      final locationInfo = {
        ...widget.restaurantInfo,
        'state': _selectedState!,
        'address': _addressController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'mapsLocation': _mapsLocationController.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AdditionalFeaturesPage(restaurantInfo: locationInfo),
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
                '3. Location',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              _buildDropdownField('State'),
              _buildTextField(
                'Full Address (Street, City)',
                _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'PIN Code',
                _pincodeController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PIN code is required';
                  }
                  if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
                    return 'Please enter a valid 6-digit PIN code';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Google Maps Location',
                _mapsLocationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Google Maps location is required';
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
                value: _selectedState,
                items: _states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(state),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                },
              ),
            ),
          ),
          if (_selectedState == null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Please select a state',
                style: TextStyle(color: Colors.red[400], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
