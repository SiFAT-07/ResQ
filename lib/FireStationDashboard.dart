import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'Landing_Page.dart';

class FireStationDashboard extends StatefulWidget {
  const FireStationDashboard({super.key});

  @override
  State<FireStationDashboard> createState() => _FireStationDashboardState();
}

class _FireStationDashboardState extends State<FireStationDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _emergencies = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Get dashboard data from API
      final dashboardData = await authProvider.getDashboardData();

      if (dashboardData != null) {
        setState(() {
          _dashboardData = dashboardData;

          // Extract emergencies from dashboard data
          if (dashboardData.containsKey('pending_emergencies')) {
            _emergencies = dashboardData['pending_emergencies'];
          }
        });
      }
    } catch (e) {
      // Handle error
      print('Error loading dashboard data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final stationName = user?.fullName ?? "Fire Station";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ResQ Fire',
              style: TextStyle(
                color: Colors.red[500],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.red[700], size: 16),
                const SizedBox(width: 4),
                Text(
                  'Dhaka, BD',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.red.shade100,
            radius: 16,
            child: Icon(
              Icons.local_fire_department,
              color: Colors.red[700],
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(stationName),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildFireStatus(),
                  _buildActiveEmergencies(),
                  Expanded(
                    child:
                        _emergencies.isEmpty
                            ? _buildEmptyEmergencyList()
                            : _buildEmergencyList(),
                  ),
                ],
              ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showActionOptions();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(String stationName) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 32,
                  child: Icon(
                    Icons.local_fire_department,
                    size: 36,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  stationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fire Station',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.red),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.emergency),
            title: const Text('Fire Emergencies'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Fire Team'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () {
                _handleLogout();
              },
              icon: Icon(Icons.exit_to_app, color: Colors.red[700]),
              label: Text('Sign Out', style: TextStyle(color: Colors.red[700])),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red[700]!),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFireStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusCard('Active Fires', '5', Colors.red),
          _buildStatusCard('Teams Deployed', '3', Colors.orange),
          _buildStatusCard('On Standby', '2', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActiveEmergencies() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Fire Emergencies',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                const SizedBox(width: 8),
                const Text(
                  'Emergency alert: High risk fire in Industrial Zone',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _emergencies.length,
      itemBuilder: (context, index) {
        final emergency = _emergencies[index];
        return _buildEmergencyCard(emergency);
      },
    );
  }

  Widget _buildEmptyEmergencyList() {
    return Center(
      child: Text(
        'No active emergencies',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> emergency) {
    Color statusColor;
    IconData priorityIcon;

    switch (emergency['priority']) {
      case 'CRITICAL':
        statusColor = Colors.red;
        priorityIcon = Icons.warning;
        break;
      case 'HIGH':
        statusColor = Colors.deepOrange;
        priorityIcon = Icons.priority_high;
        break;
      case 'MODERATE':
        statusColor = Colors.orange;
        priorityIcon = Icons.report_problem;
        break;
      default:
        statusColor = Colors.blue;
        priorityIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(priorityIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emergency['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        emergency['location'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    emergency['priority'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '"${emergency['message']}"',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  emergency['timeAgo'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Spacer(),
                if (emergency['isResponding'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Responding',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // Show details
                  },
                  child: const Text('Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Toggle response status
                    setState(() {
                      emergency['isResponding'] = !emergency['isResponding'];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        emergency['isResponding'] ? Colors.grey : Colors.red,
                  ),
                  child: Text(emergency['isResponding'] ? 'Cancel' : 'Respond'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: 'Emergencies',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  void _showActionOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add_alert, color: Colors.red),
                ),
                title: const Text('Create Fire Alert'),
                subtitle: const Text('Alert citizens about fire hazards'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle create alert
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fire_truck, color: Colors.blue),
                ),
                title: const Text('Dispatch Fire Truck'),
                subtitle: const Text('Send response team to location'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle dispatch
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.people, color: Colors.green),
                ),
                title: const Text('Coordinate Team'),
                subtitle: const Text('Manage firefighter teams'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle team coordination
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Handle logout
  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    // Navigate back to landing page
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }
}
