import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Add this import for web

class VolunteerTasksPage extends StatefulWidget {
  const VolunteerTasksPage({super.key});

  @override
  State<VolunteerTasksPage> createState() => _VolunteerTasksPageState();
}

class _VolunteerTasksPageState extends State<VolunteerTasksPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
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

  Future<void> _handleDonationAction(String donationId, String action) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get volunteer's organization ID
      final volunteerDoc =
          await _firestore.collection('volunteers').doc(user.uid).get();

      if (!volunteerDoc.exists) {
        throw Exception('Volunteer data not found');
      }

      final organizationId = volunteerDoc.data()!['organizationId'];

      await _firestore.collection('donations').doc(donationId).update({
        'status': action == 'accept' ? 'accepted' : 'declined',
        'volunteerId': action == 'accept' ? user.uid : null,
        'organizationId': action == 'accept' ? organizationId : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (action == 'accept') {
        // Add to volunteer's accepted donations
        await _firestore.collection('volunteers').doc(user.uid).update({
          'acceptedDonations': FieldValue.arrayUnion([donationId]),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donation ${action}ed successfully!'),
          backgroundColor: action == 'accept' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    try {
      if (Theme.of(context).platform == TargetPlatform.iOS ||
          Theme.of(context).platform == TargetPlatform.android) {
        // For mobile platforms
        final result = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );

        if (!result && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Google Maps')),
          );
        }
      } else {
        // For web platform
        html.window.open(url, '_blank');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening maps: $e')),
        );
      }
    }
  }

  Widget _buildDonationCard(
      Map<String, dynamic> donation, String donationId, bool isAccepted) {
    final location = donation['location'] as Map<String, dynamic>?;
    final lat = location?['latitude'] as double?;
    final lng = location?['longitude'] as double?;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  donation['foodType'] ?? 'Food Donation',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${donation['quantity']} servings',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Pickup Location',
              location?['address'] ?? 'Not specified',
            ),
            if (lat != null && lng != null) ...[
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _openGoogleMaps(lat, lng),
                icon: const Icon(Icons.directions),
                label: const Text('Navigate to Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            const SizedBox(height: 8),
            _buildInfoRow(
              'Pickup Time',
              donation['pickupTime'] ?? 'Not specified',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Donor',
              donation['donorName'] ?? 'Anonymous',
            ),
            if (!isAccepted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _handleDonationAction(donationId, 'accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _handleDonationAction(donationId, 'decline'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Donation Tasks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'New Donations'),
            Tab(text: 'Accepted Tasks'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // New Donations Tab
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('donations')
                          .where('status', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No new donations at the moment'),
                          );
                        }

                        // Sort the documents in memory
                        final sortedDocs = snapshot.data!.docs.toList()
                          ..sort((a, b) {
                            final aTime =
                                (a.data() as Map<String, dynamic>)['createdAt']
                                    as Timestamp?;
                            final bTime =
                                (b.data() as Map<String, dynamic>)['createdAt']
                                    as Timestamp?;
                            if (aTime == null || bTime == null) return 0;
                            return bTime.compareTo(aTime);
                          });

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedDocs.length,
                          itemBuilder: (context, index) {
                            final donation = sortedDocs[index].data()
                                as Map<String, dynamic>;
                            final donationId = sortedDocs[index].id;
                            return _buildDonationCard(
                                donation, donationId, false);
                          },
                        );
                      },
                    ),
                    // Accepted Tasks Tab
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('donations')
                          .where('status', isEqualTo: 'accepted')
                          .where('volunteerId',
                              isEqualTo: _auth.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No accepted tasks at the moment'),
                          );
                        }

                        // Sort the documents in memory
                        final sortedDocs = snapshot.data!.docs.toList()
                          ..sort((a, b) {
                            final aTime =
                                (a.data() as Map<String, dynamic>)['createdAt']
                                    as Timestamp?;
                            final bTime =
                                (b.data() as Map<String, dynamic>)['createdAt']
                                    as Timestamp?;
                            if (aTime == null || bTime == null) return 0;
                            return bTime.compareTo(aTime);
                          });

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedDocs.length,
                          itemBuilder: (context, index) {
                            final donation = sortedDocs[index].data()
                                as Map<String, dynamic>;
                            final donationId = sortedDocs[index].id;
                            return _buildDonationCard(
                                donation, donationId, true);
                          },
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
