import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildOverviewTab()
          : _selectedIndex == 1
              ? _buildDonationsTab()
              : _buildUsersTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Donations',
                  Icons.food_bank,
                  Colors.blue,
                  _buildDonationCountStream(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Volunteers',
                  Icons.people,
                  Colors.green,
                  _buildVolunteerCountStream(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Service Providers',
                  Icons.business,
                  Colors.orange,
                  _buildServiceProviderCountStream(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Organizations',
                  Icons.apartment,
                  Colors.purple,
                  _buildOrganizationCountStream(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Donation Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: _buildDonationChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    IconData icon,
    Color color,
    Stream<int> stream,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<int>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> _buildDonationCountStream() {
    return _firestore.collection('donations').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> _buildVolunteerCountStream() {
    return _firestore.collection('volunteers').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> _buildServiceProviderCountStream() {
    return _firestore
        .collection('service_providers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> _buildOrganizationCountStream() {
    return _firestore.collection('organizations').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Widget _buildDonationChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('donations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final donations = snapshot.data!.docs;
        final statusCounts = {
          'pending': 0,
          'accepted': 0,
          'declined': 0,
          'completed': 0,
        };

        for (var doc in donations) {
          final status = doc['status'] as String? ?? 'pending';
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }

        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: (statusCounts['pending'] ?? 0).toDouble(),
                  color: Colors.orange,
                  title: 'Pending',
                  radius: 100,
                ),
                PieChartSectionData(
                  value: (statusCounts['accepted'] ?? 0).toDouble(),
                  color: Colors.green,
                  title: 'Accepted',
                  radius: 100,
                ),
                PieChartSectionData(
                  value: (statusCounts['declined'] ?? 0).toDouble(),
                  color: Colors.red,
                  title: 'Declined',
                  radius: 100,
                ),
                PieChartSectionData(
                  value: (statusCounts['completed'] ?? 0).toDouble(),
                  color: Colors.blue,
                  title: 'Completed',
                  radius: 100,
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('donations')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final donations = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: donations.length,
          itemBuilder: (context, index) {
            final donation = donations[index].data() as Map<String, dynamic>;
            final donationId = donations[index].id;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(donation['foodType'] ?? 'Food Donation'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${donation['status']}'),
                    Text('Quantity: ${donation['quantity']} servings'),
                    Text('Donor: ${donation['donorName'] ?? 'Anonymous'}'),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    await _firestore
                        .collection('donations')
                        .doc(donationId)
                        .update({'status': value});
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pending',
                      child: Text('Mark as Pending'),
                    ),
                    const PopupMenuItem(
                      value: 'accepted',
                      child: Text('Mark as Accepted'),
                    ),
                    const PopupMenuItem(
                      value: 'declined',
                      child: Text('Mark as Declined'),
                    ),
                    const PopupMenuItem(
                      value: 'completed',
                      child: Text('Mark as Completed'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsersTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Volunteers'),
              Tab(text: 'Service Providers'),
              Tab(text: 'Organizations'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildUserList('volunteers'),
                _buildUserList('service_providers'),
                _buildUserList('organizations'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(user['name'] ?? 'Unnamed User'),
                subtitle: Text(user['email'] ?? 'No email'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await _firestore
                          .collection(collection)
                          .doc(userId)
                          .delete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete User'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
