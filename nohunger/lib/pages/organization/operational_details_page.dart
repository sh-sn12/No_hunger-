import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'unique_code_page.dart';

class OrganizationOperationalDetailsPage extends StatefulWidget {
  final String organizationId;

  const OrganizationOperationalDetailsPage({
    super.key,
    required this.organizationId,
  });

  @override
  State<OrganizationOperationalDetailsPage> createState() =>
      _OrganizationOperationalDetailsPageState();
}

class _OrganizationOperationalDetailsPageState
    extends State<OrganizationOperationalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _missionController = TextEditingController();
  final _visionController = TextEditingController();
  final _activitiesController = TextEditingController();
  final _impactController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveOperationalDetails() async {
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
        'mission': _missionController.text.trim(),
        'vision': _visionController.text.trim(),
        'activities': _activitiesController.text.trim(),
        'impact': _impactController.text.trim(),
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationUniqueCodePage(
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
    _missionController.dispose();
    _visionController.dispose();
    _activitiesController.dispose();
    _impactController.dispose();
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
                '5. Operational Details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _missionController,
                decoration: const InputDecoration(
                  labelText: 'Mission Statement',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mission statement';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visionController,
                decoration: const InputDecoration(
                  labelText: 'Vision Statement',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vision statement';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _activitiesController,
                decoration: const InputDecoration(
                  labelText: 'Key Activities',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter key activities';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _impactController,
                decoration: const InputDecoration(
                  labelText: 'Impact Created',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter impact created';
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
                  onPressed: _isLoading ? null : _saveOperationalDetails,
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
