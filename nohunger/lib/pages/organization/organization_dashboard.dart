import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrganizationDashboard extends StatefulWidget {
  const OrganizationDashboard({super.key});

  @override
  State<OrganizationDashboard> createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<OrganizationDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _organizationData;
  List<Map<String, dynamic>> _volunteers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrganizationData();
  }

  Future<void> _loadOrganizationData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final orgDoc = await _firestore
          .collection('organizations')
          .where('authUid', isEqualTo: user.uid)
          .get();

      if (orgDoc.docs.isEmpty) {
        setState(() {
          _errorMessage = 'Organization data not found';
          _isLoading = false;
        });
        return;
      }

      final orgData = orgDoc.docs.first.data();
      setState(() {
        _organizationData = orgData;
      });

      // Load volunteers
      if (orgData['volunteers'] != null && orgData['volunteers'].isNotEmpty) {
        final volunteers = await _firestore
            .collection('volunteers')
            .where(FieldPath.documentId, whereIn: orgData['volunteers'])
            .get();

        setState(() {
          _volunteers = volunteers.docs.map((doc) => doc.data()).toList();
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.jpg',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'NO HUNGER',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        'Organization Details',
                        [
                          _buildInfoRow('Name', _organizationData!['name']),
                          _buildInfoRow('Type', _organizationData!['type']),
                          _buildInfoRow('Registration Number',
                              _organizationData!['registrationNumber']),
                          _buildInfoRow('Organization Code',
                              _organizationData!['orgCode']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        'Contact Information',
                        [
                          _buildInfoRow('Email', _organizationData!['email']),
                          _buildInfoRow(
                              'Phone', _organizationData!['contactNumber']),
                          _buildInfoRow(
                              'Address', _organizationData!['address']),
                          _buildInfoRow('City', _organizationData!['city']),
                          _buildInfoRow('State', _organizationData!['state']),
                          _buildInfoRow(
                              'Pincode', _organizationData!['pincode']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        'Social Media',
                        [
                          _buildInfoRow(
                              'Website', _organizationData!['website']),
                          _buildInfoRow('Instagram',
                              _organizationData!['socialMedia']?['instagram']),
                          _buildInfoRow('Facebook',
                              _organizationData!['socialMedia']?['facebook']),
                          _buildInfoRow('Twitter',
                              _organizationData!['socialMedia']?['twitter']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        'Operational Details',
                        [
                          _buildInfoRow(
                              'Mission', _organizationData!['mission']),
                          _buildInfoRow('Vision', _organizationData!['vision']),
                          _buildInfoRow(
                              'Activities', _organizationData!['activities']),
                          _buildInfoRow('Impact', _organizationData!['impact']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        'Financial Information',
                        [
                          _buildInfoRow(
                              'IFSC Code', _organizationData!['ifscCode']),
                          _buildInfoRow('Account Number',
                              _organizationData!['accountNumber']),
                          _buildInfoRow('UPI ID', _organizationData!['upiId']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildVolunteersCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildVolunteersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Registered Volunteers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF8C42),
                  ),
                ),
                Text(
                  'Total: ${_volunteers.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_volunteers.isEmpty)
              const Center(
                child: Text(
                  'No volunteers have registered yet',
                  style: TextStyle(color: Colors.black54),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _volunteers.length,
                itemBuilder: (context, index) {
                  final volunteer = _volunteers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFF8C42),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        volunteer['name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(volunteer['email'] ?? ''),
                      trailing: Text(
                        volunteer['phone'] ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8C42),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
