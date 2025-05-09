import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResQ - Police Station Dashboard',
      theme: ThemeData(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.red.shade700,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      home: const PoliceDashboard(),
    );
  }
}

// Priority enum for emergency classification
enum Priority { critical, high, moderate, low }

// Emergency class to hold data
class Emergency {
  final String id;
  final Priority priority;
  final String name;
  final int age;
  final String message;
  final String timeAgo;
  final double latitude;
  final double longitude;
  bool isResponding;
  final String incidentType;

  Emergency({
    required this.id,
    required this.priority,
    required this.name,
    required this.age,
    required this.message,
    required this.timeAgo,
    required this.latitude,
    required this.longitude,
    required this.isResponding,
    required this.incidentType,
  });
}

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard>
    with SingleTickerProviderStateMixin {
  String selectedFilter = 'All';
  bool showAssignedOnly = false;
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample data for emergency reports
  final List<Emergency> emergencies = [
    Emergency(
      id: '1',
      priority: Priority.critical,
      name: 'Nabiul Alom',
      age: 36,
      message: "There's a fire in my house, 3rd floor",
      timeAgo: '3 mins ago',
      latitude: 23.810331,
      longitude: 90.412521, // Dhaka coordinates
      isResponding: false,
      incidentType: 'Fire',
    ),
    Emergency(
      id: '2',
      priority: Priority.high,
      name: 'Khurshed Ahmed',
      age: 42,
      message: "My neighbor is threatening me with a knife",
      timeAgo: '7 mins ago',
      latitude: 23.807331,
      longitude: 90.415521,
      isResponding: false,
      incidentType: 'Assault',
    ),
    Emergency(
      id: '3',
      priority: Priority.moderate,
      name: 'Farida Begum',
      age: 68,
      message: "I've fallen and can't get up, need medical assistance",
      timeAgo: '12 mins ago',
      latitude: 23.809331,
      longitude: 90.411521,
      isResponding: true,
      incidentType: 'Medical',
    ),
    Emergency(
      id: '4',
      priority: Priority.low,
      name: 'Rahima Khatun',
      age: 29,
      message: "My car has been stolen from the parking lot",
      timeAgo: '24 mins ago',
      latitude: 23.812331,
      longitude: 90.410521,
      isResponding: false,
      incidentType: 'Theft',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMapTab(),
                _buildEmergencyListTab(),
                _buildStatsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateEmergencyDialog();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
              Icons.local_police_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ResQ',
            style: TextStyle(
              color: Colors.red[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
          child: Icon(Icons.security, color: Colors.red[700], size: 18),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer() {
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
                  child: Icon(Icons.security, size: 36, color: Colors.red[700]),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dhaka Central',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Police Station',
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
            title: const Text('Emergency Reports'),
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(1);
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
              onPressed: () {},
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.red,
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(icon: Icon(Icons.map), text: 'Map'),
          Tab(icon: Icon(Icons.assignment), text: 'Reports'),
          Tab(icon: Icon(Icons.bar_chart), text: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    return Column(
      children: [
        _buildMap(),
        _buildFilterTabs(),
        Expanded(child: _buildEmergencyList()),
      ],
    );
  }

  Widget _buildEmergencyListTab() {
    return Column(
      children: [
        _buildFilterTabs(),
        Expanded(child: _buildEmergencyList(showAll: true)),
      ],
    );
  }

  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Total Emergencies',
                '24',
                Colors.red,
                Icons.emergency,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Active Responses',
                '8',
                Colors.green,
                Icons.local_police,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Critical Incidents',
                '5',
                Colors.red[900]!,
                Icons.warning,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Resolved Today',
                '12',
                Colors.blue,
                Icons.check_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 200,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Text('Map View Goes Here', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Critical'),
                  _buildFilterChip('Medical'),
                  _buildFilterChip('Theft'),
                  _buildFilterChip('Assault'),
                ],
              ),
            ),
          ),
          Switch(
            value: showAssignedOnly,
            onChanged: (value) {
              setState(() {
                showAssignedOnly = value;
              });
            },
            activeColor: Colors.red,
          ),
          Text(
            'Assigned',
            style: TextStyle(
              fontSize: 14,
              color: showAssignedOnly ? Colors.red : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyList({bool showAll = false}) {
    List<Emergency> filteredEmergencies =
        emergencies.where((emergency) {
          if (showAssignedOnly && !emergency.isResponding) {
            return false;
          }

          if (selectedFilter == 'All') {
            return true;
          } else if (selectedFilter == 'Critical') {
            return emergency.priority == Priority.critical;
          } else if (selectedFilter == 'Medical') {
            return emergency.incidentType == 'Medical';
          } else if (selectedFilter == 'Theft') {
            return emergency.incidentType == 'Theft';
          } else if (selectedFilter == 'Assault') {
            return emergency.incidentType == 'Assault';
          }

          return true;
        }).toList();

    return Container(
      color: Colors.grey[50],
      child:
          filteredEmergencies.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No emergencies match your filters',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredEmergencies.length,
                itemBuilder: (context, index) {
                  final emergency = filteredEmergencies[index];
                  return _buildEmergencyCard(emergency);
                },
              ),
    );
  }

  Widget _buildEmergencyCard(Emergency emergency) {
    Color statusColor;
    IconData priorityIcon;
    String priorityText;

    switch (emergency.priority) {
      case Priority.critical:
        statusColor = Colors.red;
        priorityIcon = Icons.warning;
        priorityText = 'Critical';
        break;
      case Priority.high:
        statusColor = Colors.deepOrange;
        priorityIcon = Icons.priority_high;
        priorityText = 'High';
        break;
      case Priority.moderate:
        statusColor = Colors.orange;
        priorityIcon = Icons.report_problem;
        priorityText = 'Moderate';
        break;
      case Priority.low:
        statusColor = Colors.blue;
        priorityIcon = Icons.info;
        priorityText = 'Low';
        break;
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
                        emergency.incidentType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${emergency.name} • ${emergency.age} yrs',
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
                    priorityText,
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
              '"${emergency.message}"',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  emergency.timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Spacer(),
                if (emergency.isResponding)
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
                    _showEmergencyDetailsDialog(emergency);
                  },
                  child: const Text('Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      emergency.isResponding = !emergency.isResponding;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        emergency.isResponding ? Colors.grey : Colors.red,
                  ),
                  child: Text(emergency.isResponding ? 'Cancel' : 'Respond'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDetailsDialog(Emergency emergency) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  _getPriorityIcon(emergency.priority),
                  color: _getPriorityColor(emergency.priority),
                ),
                const SizedBox(width: 8),
                Text('${emergency.incidentType} Emergency'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(
                  'Reported by',
                  '${emergency.name}, ${emergency.age} yrs',
                ),
                _detailRow('Message', '"${emergency.message}"'),
                _detailRow('Time', emergency.timeAgo),
                _detailRow(
                  'Status',
                  emergency.isResponding ? 'Responding' : 'Not Responding',
                ),
                _detailRow(
                  'Location',
                  'Lat: ${emergency.latitude}, Long: ${emergency.longitude}',
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
                  setState(() {
                    emergency.isResponding = !emergency.isResponding;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      emergency.isResponding ? Colors.grey : Colors.red,
                ),
                child: Text(
                  emergency.isResponding ? 'Cancel Response' : 'Respond',
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

  void _showCreateEmergencyDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Emergency Report'),
            content: const SizedBox(
              height: 200,
              child: Center(
                child: Text('Emergency creation form would go here'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.critical:
        return Colors.red;
      case Priority.high:
        return Colors.deepOrange;
      case Priority.moderate:
        return Colors.orange;
      case Priority.low:
        return Colors.blue;
    }
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.critical:
        return Icons.warning;
      case Priority.high:
        return Icons.priority_high;
      case Priority.moderate:
        return Icons.report_problem;
      case Priority.low:
        return Icons.info;
    }
  }
}
