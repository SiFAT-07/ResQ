import 'package:flutter/material.dart';



class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final Color primaryRed = const Color(0xFFE53935);
  final Color secondaryRed = const Color(0xFFFF8A80);
  final Color darkBlue = const Color(0xFF263238);
  final Color lightGrey = const Color(0xFFF5F5F5);

  String? selectedIncidentType;
  String? selectedFloor;
  String? fireAmount;
  String? peopleCount;
  int _currentStep = 0;

  final List<String> incidentTypes = [
    'Fire Incident',
    'Flood Incident',
    'Gas Leak',
    'Building Collapse',
    'Pet Rescue',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero text
                    Text(
                      'Report an Incident',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help is on the way. Provide details so we can assist you better.',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    // Current location card
                    _buildLocationCard(),
                    const SizedBox(height: 24),

                    // Form fields
                    _buildIncidentTypeSelector(),
                    const SizedBox(height: 24),

                    // Dynamic fields based on incident type
                    if (selectedIncidentType == 'Fire Incident')
                      _buildFireIncidentFields(),
                    if (selectedIncidentType == 'Flood Incident')
                      _buildFloodIncidentFields(),
                    if (selectedIncidentType == 'Gas Leak')
                      _buildGasLeakFields(),
                    if (selectedIncidentType == 'Building Collapse')
                      _buildBuildingCollapseFields(),
                    if (selectedIncidentType == 'Pet Rescue')
                      _buildPetRescueFields(),

                    if (selectedIncidentType != null)
                      const SizedBox(height: 24),

                    _buildAttachmentField(),
                    const SizedBox(height: 24),

                    _buildContactField(),
                    const SizedBox(height: 32),

                    _buildSubmitButton(),
                    const SizedBox(height: 32),

                    _buildEmergencyNumbersSection(),
                    const SizedBox(height: 16),

                    _buildCopyright(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: darkBlue),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: darkBlue),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.help_outline, color: darkBlue),
          onPressed: () {},
        ),
      ],
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: primaryRed, size: 28),
          const SizedBox(width: 8),
          Text(
            'ResQ',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepDot(0, 'Type'),
          _buildStepLine(0, 1),
          _buildStepDot(1, 'Details'),
          _buildStepLine(1, 2),
          _buildStepDot(2, 'Submit'),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? primaryRed : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child:
              isActive
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : Center(
                    child: Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? primaryRed : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int fromStep, int toStep) {
    bool isActive = _currentStep >= toStep;
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? primaryRed : Colors.grey[300],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: primaryRed),
              const SizedBox(width: 8),
              Text(
                'Current Location',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Sadiar barir pasher bari',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
                Icon(Icons.my_location, color: primaryRed),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit_location_alt, color: primaryRed, size: 18),
            label: Text(
              'Change Location',
              style: TextStyle(color: primaryRed, fontSize: 14),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What type of incident are you reporting?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
          children:
              incidentTypes
                  .map((type) => _buildIncidentTypeCard(type))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildIncidentTypeCard(String type) {
    final bool isSelected = selectedIncidentType == type;
    IconData icon;

    switch (type) {
      case 'Fire Incident':
        icon = Icons.local_fire_department;
        break;
      case 'Flood Incident':
        icon = Icons.water_damage;
        break;
      case 'Gas Leak':
        icon = Icons.gas_meter;
        break;
      case 'Building Collapse':
        icon = Icons.domain_disabled;
        break;
      case 'Pet Rescue':
        icon = Icons.pets;
        break;
      default:
        icon = Icons.warning_amber;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIncidentType = type;
          _currentStep = 1; // Move to the next step
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryRed.withOpacity(0.1) : lightGrey,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected
                  ? Border.all(color: primaryRed, width: 2)
                  : Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryRed : Colors.grey[700],
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              type,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? primaryRed : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFireIncidentFields() {
    return _buildDetailFields([
      _buildDropdownField(
        'Which floor?',
        ['1-5', '6-10', '>10'],
        selectedFloor,
        (value) {
          setState(() => selectedFloor = value);
        },
        Icons.apartment,
      ),
      _buildDropdownField(
        'How severe is the fire?',
        ['Small/Contained', 'Medium/Spreading', 'Large/Out of Control'],
        fireAmount,
        (value) {
          setState(() => fireAmount = value);
        },
        Icons.local_fire_department,
      ),
      _buildDropdownField(
        'People affected?',
        ['None', '1-3', '4-10', 'More than 10'],
        peopleCount,
        (value) {
          setState(() => peopleCount = value);
          _currentStep = 2; // Move to the next step
        },
        Icons.group,
      ),
    ]);
  }

  Widget _buildFloodIncidentFields() {
    return _buildDetailFields([
      _buildDropdownField(
        'Water Level',
        ['Ankle-deep', 'Knee-deep', 'Waist-deep or higher'],
        fireAmount,
        (value) {
          setState(() => fireAmount = value);
        },
        Icons.water,
      ),
      _buildDropdownField(
        'People stranded?',
        ['None', '1-3', '4-10', 'More than 10'],
        peopleCount,
        (value) {
          setState(() => peopleCount = value);
          _currentStep = 2; // Move to the next step
        },
        Icons.group,
      ),
    ]);
  }

  Widget _buildGasLeakFields() {
    return _buildDetailFields([
      _buildDropdownField(
        'Leak Source',
        ['Kitchen Appliance', 'Pipe Line', 'Cylinder/Tank', 'Unknown'],
        fireAmount,
        (value) {
          setState(() => fireAmount = value);
        },
        Icons.propane_tank,
      ),
      _buildDropdownField(
        'People at risk?',
        ['None', '1-3', '4-10', 'More than 10'],
        peopleCount,
        (value) {
          setState(() => peopleCount = value);
          _currentStep = 2; // Move to the next step
        },
        Icons.group,
      ),
    ]);
  }

  Widget _buildBuildingCollapseFields() {
    return _buildDetailFields([
      _buildDropdownField(
        'Collapse Severity',
        ['Partial (Some structure intact)', 'Complete (Full collapse)'],
        fireAmount,
        (value) {
          setState(() => fireAmount = value);
        },
        Icons.domain_disabled,
      ),
      _buildDropdownField(
        'People trapped?',
        ['None', '1-3', '4-10', 'More than 10', 'Unknown'],
        peopleCount,
        (value) {
          setState(() => peopleCount = value);
          _currentStep = 2; // Move to the next step
        },
        Icons.group,
      ),
    ]);
  }

  Widget _buildPetRescueFields() {
    return _buildDetailFields([
      _buildDropdownField(
        'Animal Type',
        ['Cat', 'Dog', 'Bird', 'Livestock', 'Wildlife', 'Other'],
        fireAmount,
        (value) {
          setState(() => fireAmount = value);
          _currentStep = 2; // Move to the next step
        },
        Icons.pets,
      ),
    ]);
  }

  Widget _buildDetailFields(List<Widget> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 16),
          ...fields
              .expand((field) => [field, const SizedBox(height: 16)])
              .toList()
            ..removeLast(),
          if (fields.isNotEmpty) const SizedBox(height: 8),
          Text(
            'These details help us dispatch the right emergency response team',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? selectedValue,
    ValueChanged<String> onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryRed, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                "Select an option",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              value: selectedValue,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: darkBlue),
              dropdownColor: Colors.white,
              onChanged: (value) => onChanged(value!),
              items:
                  options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attach Photos or Videos',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.file_upload_outlined,
                  color: Colors.grey[600],
                  size: 38,
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap to upload',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Photos help emergency services assess the situation',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone Number (Optional)',
              prefixIcon: Icon(Icons.phone, color: primaryRed),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We may need to call you for additional information',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.all(24),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: primaryRed,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Report Submitted",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your incident report has been successfully submitted. Emergency services have been notified and help is on the way.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.send),
          SizedBox(width: 8),
          Text(
            'SUBMIT REPORT',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumbersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_in_talk, color: primaryRed, size: 20),
              const SizedBox(width: 8),
              Text(
                'Emergency Numbers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEmergencyNumberItem('Fire Department', '911'),
          _buildEmergencyNumberItem('Police', '911'),
          _buildEmergencyNumberItem('Ambulance', '911'),
          _buildEmergencyNumberItem('FireLit ResQ Hotline', '555-123-4567'),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumberItem(String service, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryRed),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryRed,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.call, color: primaryRed, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "© 2025 FireLit ResQ. All rights reserved.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: 1,
      onDestinationSelected: (index) {},
      backgroundColor: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.grey[600]),
          selectedIcon: Icon(Icons.home, color: primaryRed),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.warning_amber_outlined, color: Colors.grey[600]),
          selectedIcon: Icon(Icons.warning_amber, color: primaryRed),
          label: 'Report',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
          selectedIcon: Icon(Icons.chat_bubble, color: primaryRed),
          label: 'Chatbot',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.grey[600]),
          selectedIcon: Icon(Icons.person, color: primaryRed),
          label: 'Profile',
        ),
      ],
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }
}
