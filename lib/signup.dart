import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResQ App',
      theme: ThemeData(
        primaryColor: const Color(0xFFE53935),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          primary: const Color(0xFFE53935),
          secondary: const Color(0xFFFF5252),
          background: Colors.white,
          surface: Colors.white,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const RoleBasedSignUpPage(),
    );
  }
}

class RoleBasedSignUpPage extends StatefulWidget {
  const RoleBasedSignUpPage({super.key});

  @override
  State<RoleBasedSignUpPage> createState() => _RoleBasedSignUpPageState();
}

class _RoleBasedSignUpPageState extends State<RoleBasedSignUpPage>
    with SingleTickerProviderStateMixin {
  String? selectedRole;
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> roles = [
    {'label': 'Civilian', 'icon': Icons.person_outline_rounded},
    {'label': 'Fire Officer', 'icon': Icons.local_fire_department_outlined},
    {'label': 'Police Officer', 'icon': Icons.local_police_outlined},
    {'label': 'Volunteer Head', 'icon': Icons.volunteer_activism_outlined},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showRoleSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Your Role",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF757575)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children:
                      roles
                          .map(
                            (role) => ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  role['icon'],
                                  color: const Color(0xFFE53935),
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                role['label'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedRole = role['label'];
                                  formData.clear();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleSocialSignUp(String provider) {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a role before signing up.'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    print('Signing up with $provider as $selectedRole');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF212121)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed:
              () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
        centerTitle: true,
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Logo with Fire and blinking animation
                Center(child: PulsingLogoWidget()),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'ResQ',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Emergency Response System',
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    '© ResQ Digital 2025',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                buildRolePicker(),
                const SizedBox(height: 24),

                if (selectedRole != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: buildFormFields(selectedRole!),
                    ),
                  ),

                const SizedBox(height: 24),
                buildSubmitButton(),
                const SizedBox(height: 32),

                buildSocialButtons(),
                const SizedBox(height: 24),

                // Sign in link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to login page
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSocialButtons() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "OR SIGN UP WITH",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(
              Icons.g_mobiledata,
              const Color(0xFFDB4437),
              "Google",
            ),
            const SizedBox(width: 24),
            buildSocialIcon(
              Icons.facebook,
              const Color(0xFF4267B2),
              "Facebook",
            ),
            const SizedBox(width: 24),
            buildSocialIcon(Icons.apple, const Color(0xFF333333), "Apple"),
          ],
        ),
      ],
    );
  }

  Widget buildSocialIcon(IconData icon, Color color, String provider) {
    return GestureDetector(
      onTap: () => handleSocialSignUp(provider),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Icon(icon, size: 28, color: color),
      ),
    );
  }

  Widget buildRolePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "I am a",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
              fontSize: 16,
            ),
          ),
        ),
        GestureDetector(
          onTap: showRoleSelector,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    selectedRole != null
                        ? const Color(0xFFE53935)
                        : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        selectedRole != null
                            ? roles.firstWhere(
                              (role) => role['label'] == selectedRole,
                            )['icon']
                            : Icons.person_outline_rounded,
                        color:
                            selectedRole != null
                                ? const Color(0xFFE53935)
                                : const Color(0xFF9E9E9E),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedRole ?? 'Select your role',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            selectedRole != null
                                ? const Color(0xFF212121)
                                : const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color:
                      selectedRole != null
                          ? const Color(0xFFE53935)
                          : const Color(0xFF9E9E9E),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          print(formData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Sign up Successful!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildFormFields(String role) {
    return Form(key: _formKey, child: Column(children: getFieldsForRole(role)));
  }

  List<Widget> getFieldsForRole(String role) {
    switch (role) {
      case 'Civilian':
        return [
          buildTextField('Full Name', Icons.person_outline_rounded),
          buildTextField('Email Address', Icons.email_outlined),
          buildTextField('Phone Number', Icons.phone_outlined),
          buildTextField('National ID', Icons.badge_outlined),
          buildPasswordField('Password'),
          buildPasswordField('Confirm Password'),
        ];
      case 'Fire Officer':
        return [
          buildTextField('Officer Name', Icons.person_outline_rounded),
          buildTextField(
            'Fire Station Name',
            Icons.local_fire_department_outlined,
          ),
          buildTextField('Station Email', Icons.email_outlined),
          buildUniqueIdField('Station ID', Icons.verified_outlined),
          buildPasswordField('Password'),
          buildPasswordField('Confirm Password'),
        ];
      case 'Police Officer':
        return [
          buildTextField('Officer Name', Icons.person_outline_rounded),
          buildTextField('Police Station Name', Icons.local_police_outlined),
          buildTextField('Station Email', Icons.email_outlined),
          buildUniqueIdField('Station ID', Icons.verified_outlined),
          buildPasswordField('Password'),
          buildPasswordField('Confirm Password'),
        ];
      case 'Volunteer Head':
        return [
          buildTextField('Head Name', Icons.person_outline_rounded),
          buildTextField('Team Name', Icons.groups_outlined),
          buildTextField('Team Email', Icons.email_outlined),
          buildUniqueIdField('Team ID', Icons.verified_outlined),
          buildPasswordField('Password'),
          buildPasswordField('Confirm Password'),
        ];
      default:
        return [];
    }
  }

  Widget buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF757575), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
        onSaved: (value) => formData[label] = value,
      ),
    );
  }

  Widget buildPasswordField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF757575), fontSize: 14),
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF9E9E9E),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFF9E9E9E),
              size: 20,
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
        onSaved: (value) => formData[label] = value,
      ),
    );
  }

  Widget buildUniqueIdField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF757575), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (value == 'DUPLICATE_ID') return '$label already exists!';
          return null;
        },
        onSaved: (value) => formData[label] = value,
      ),
    );
  }
}

// PulsingLogoWidget Implementation
class PulsingLogoWidget extends StatefulWidget {
  const PulsingLogoWidget({super.key});

  @override
  State<PulsingLogoWidget> createState() => _PulsingLogoWidgetState();
}

class _PulsingLogoWidgetState extends State<PulsingLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFEBEE),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFE53935,
                ).withOpacity(0.3 * _pulseAnimation.value),
                blurRadius: 12 * _pulseAnimation.value,
                spreadRadius: 2 * _pulseAnimation.value,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 40 * _pulseAnimation.value,
              color: const Color(0xFFE53935),
            ),
          ),
        );
      },
    );
  }
}
