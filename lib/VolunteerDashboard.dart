import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'Landing_Page.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _pendingEmergencies = [];
  Map<String, dynamic> _statusCounts = {};
  int _unreadNotifications = 0;

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

          // Extract pending emergencies
          _pendingEmergencies = dashboardData['pending_emergencies'] ?? [];

          // Extract status counts
          _statusCounts = dashboardData['current_status'] ?? {};

          // Extract unread notifications
          _unreadNotifications = dashboardData['unread_notifications'] ?? 0;
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final teamName = user?.fullName ?? "Volunteer Team";

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
                Icons.volunteer_activism,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ResQ Volunteer',
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
              Icons.volunteer_activism,
              color: Colors.red[700],
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(teamName),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildVolunteerStats(),
                  _buildActiveMissions(),
                  Expanded(
                    child:
                        _pendingEmergencies.isEmpty
                            ? _buildEmptyTaskList()
                            : _buildTaskList(),
                  ),
                ],
              ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showVolunteerOptions();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(String teamName) {
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
                    Icons.volunteer_activism,
                    size: 36,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  teamName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Volunteer Head',
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
            leading: const Icon(Icons.people),
            title: const Text('Volunteer Teams'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Resources'),
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

  Widget _buildVolunteerStats() {
    // Use data from the API instead of hardcoded values
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            'Pending',
            _statusCounts['pending']?.toString() ?? '0',
            Colors.orange,
          ),
          _buildStatCard(
            'Responding',
            _statusCounts['responding']?.toString() ?? '0',
            Colors.blue,
          ),
          _buildStatCard(
            'On Scene',
            _statusCounts['on_scene']?.toString() ?? '0',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
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

  Widget _buildActiveMissions() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Volunteer Missions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.campaign, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Urgent need for medical volunteers at Downtown Camp',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTaskList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volunteer_activism, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No active tasks available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'New volunteer tasks will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingEmergencies.length,
      itemBuilder: (context, index) {
        final task = _pendingEmergencies[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> emergency) {
    final String status = emergency['status'] ?? 'UNKNOWN';
    final bool isActive = status == 'PENDING' || status == 'RESPONDING';
    final Color statusColor = _getStatusColor(status);

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
                Icon(_getStatusIcon(status), color: statusColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emergency['id'] ?? 'Emergency ID',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (emergency.containsKey('latitude') &&
                          emergency.containsKey('longitude'))
                        Text(
                          'Location: ${emergency['latitude']}, ${emergency['longitude']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
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
                    status,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emergency['description'] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (emergency.containsKey('timestamp'))
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        emergency['timestamp'] ?? 'Unknown time',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _showEmergencyDetailsDialog(emergency);
                  },
                  child: const Text('Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      isActive
                          ? () {
                            // Update to the next status
                            final nextStatus =
                                status == 'PENDING' ? 'RESPONDING' : 'ON_SCENE';
                            _updateEmergencyStatus(emergency['id'], nextStatus);
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(_getButtonText(status)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get button text based on status
  String _getButtonText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Respond';
      case 'RESPONDING':
        return 'On Scene';
      case 'ON_SCENE':
        return 'Resolve';
      case 'RESOLVED':
        return 'Resolved';
      default:
        return 'Update';
    }
  }

  // Helper method to get icon based on status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.warning_amber;
      case 'RESPONDING':
        return Icons.directions_run;
      case 'ON_SCENE':
        return Icons.location_on;
      case 'RESOLVED':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  // Update emergency status using API
  Future<void> _updateEmergencyStatus(String emergencyId, String status) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating status...'),
          duration: Duration(milliseconds: 500),
        ),
      );

      // Use API to update emergency status
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.updateEmergencyStatus(
        emergencyId,
        status,
      );

      if (response != null) {
        // Refresh dashboard data after updating status
        await _loadDashboardData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Emergency status updated to $status'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error message from the provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update status: ${authProvider.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEmergencyDetailsDialog(Map<String, dynamic> emergency) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: _getStatusColor(emergency['status']),
                ),
                const SizedBox(width: 8),
                Text('Emergency Details'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(
                  'Description',
                  emergency['description'] ?? 'No description',
                ),
                _detailRow('Status', emergency['status'] ?? 'Unknown'),
                if (emergency.containsKey('timestamp'))
                  _detailRow('Time', emergency['timestamp']),
                if (emergency.containsKey('latitude') &&
                    emergency.containsKey('longitude'))
                  _detailRow(
                    'Location',
                    '${emergency['latitude']}, ${emergency['longitude']}',
                  ),
                if (emergency.containsKey('is_emergency'))
                  _detailRow(
                    'Emergency',
                    emergency['is_emergency'] ? 'Yes' : 'No',
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateEmergencyStatus(
                    emergency['id'],
                    emergency['status'] == 'PENDING'
                        ? 'RESPONDING'
                        : 'ON_SCENE',
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  emergency['status'] == 'PENDING' ? 'Respond' : 'On Scene',
                ),
              ),
            ],
          ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'RESPONDING':
        return Colors.blue;
      case 'ON_SCENE':
        return Colors.green;
      case 'RESOLVED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
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
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Teams'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  void _showVolunteerOptions() {
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
                  child: const Icon(Icons.add_task, color: Colors.red),
                ),
                title: const Text('Create New Mission'),
                subtitle: const Text('Organize volunteers for a task'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle create mission
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.people_alt, color: Colors.blue),
                ),
                title: const Text('Recruit Volunteers'),
                subtitle: const Text('Add volunteers to your team'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle volunteer recruitment
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Request Resources'),
                subtitle: const Text('Request medical or food supplies'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle resource request
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
