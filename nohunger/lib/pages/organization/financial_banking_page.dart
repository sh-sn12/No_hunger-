import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'operational_details_page.dart';

class OrganizationFinancialBankingPage extends StatefulWidget {
  final String organizationId;

  const OrganizationFinancialBankingPage({
    super.key,
    required this.organizationId,
  });

  @override
  State<OrganizationFinancialBankingPage> createState() =>
      _OrganizationFinancialBankingPageState();
}

class _OrganizationFinancialBankingPageState
    extends State<OrganizationFinancialBankingPage> {
  final _formKey = GlobalKey<FormState>();
  final _ifscController = TextEditingController();
  final _accountController = TextEditingController();
  final _upiController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveFinancialInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('organizations')
          .doc(widget.organizationId)
          .update({
        'ifscCode': _ifscController.text.trim(),
        'accountNumber': _accountController.text.trim(),
        'upiId': _upiController.text.trim(),
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationOperationalDetailsPage(
              organizationId: widget.organizationId,
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
    _ifscController.dispose();
    _accountController.dispose();
    _upiController.dispose();
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
                '4. Financial & Banking\nInformation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  if (value.length != 11) {
                    return 'IFSC code must be 11 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _upiController,
                decoration: const InputDecoration(
                  labelText: 'UPI ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter UPI ID';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid UPI ID';
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
                  onPressed: _isLoading ? null : _saveFinancialInfo,
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
