import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    this.onLoginSuccess,
    this.onNavigateRegister,
    this.onForgotPassword,
    this.initialEmail,
    super.key,
  });

  final void Function(String name, String email)? onLoginSuccess;
  final VoidCallback? onNavigateRegister;
  final VoidCallback? onForgotPassword;
  final String? initialEmail;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.initialEmail ?? 'student@example.com',
    );
    _passwordController.text = 'bodima123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final email = _emailController.text.trim();
    final name = email.split('@').first.replaceAll('.', ' ');
    final displayName = name.isEmpty
        ? 'Verified User'
        : '${name[0].toUpperCase()}${name.substring(1)}';

    MockRepository.instance.isLoggedIn = true;
    MockRepository.instance.userName = displayName;
    MockRepository.instance.userEmail = email;

    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!(displayName, email);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Luxury Welcome Header
                Text(
                  'Welcome Back to BODIMA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Log in to explore boardings near your university, access your shortlist, and message hosts.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 28),

                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Email Field
                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g. kasun@sliit.lk',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 18),

                // Password Field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.onForgotPassword != null) {
                          widget.onForgotPassword!();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon:
                        const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submitLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.darkPrimary : AppColors.teal,
                      foregroundColor:
                          isDark ? AppColors.deepNavy : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Navigate to Register
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          if (widget.onNavigateRegister != null) {
                            widget.onNavigateRegister!();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
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
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    this.onRegisterSuccess,
    this.onNavigateLogin,
    super.key,
  });

  final void Function(String name, String email)? onRegisterSuccess;
  final VoidCallback? onNavigateLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedUniversity = 'SLIIT (Malabe)';
  UserRole _role = UserRole.student;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    MockRepository.instance.isLoggedIn = true;
    MockRepository.instance.userName = name;
    MockRepository.instance.userEmail = email;
    MockRepository.instance.userPhone = _phoneController.text.trim();
    MockRepository.instance.userUniversity = _selectedUniversity;
    MockRepository.instance.currentRole = _role;

    if (widget.onRegisterSuccess != null) {
      widget.onRegisterSuccess!(name, email);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join BODIMA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create your student or host account to start exploring and listing boardings.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 20),

                // Role Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkElevatedSurface
                        : AppColors.softMint.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = UserRole.student),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _role == UserRole.student
                                  ? (isDark
                                      ? AppColors.darkSurface
                                      : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _role == UserRole.student
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: isDark ? 0.3 : 0.05,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Student',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _role == UserRole.student
                                      ? (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.teal)
                                      : (isDark
                                          ? AppColors.darkSecondaryText
                                          : AppColors.secondaryText),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = UserRole.owner),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _role == UserRole.owner
                                  ? (isDark
                                      ? AppColors.darkSurface
                                      : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _role == UserRole.owner
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: isDark ? 0.3 : 0.05,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Boarding Owner',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _role == UserRole.owner
                                      ? (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.teal)
                                      : (isDark
                                          ? AppColors.darkSecondaryText
                                          : AppColors.secondaryText),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your full name'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Kasun Chamara',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!v.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g. student@sliit.lk',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                Text(
                  'Contact Phone Number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your phone number'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +94 77 123 4567',
                    prefixIcon: Icon(Icons.phone_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // University (for students)
                if (_role == UserRole.student) ...[
                  Text(
                    'Campus / University',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedUniversity,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedUniversity = val);
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.school_outlined, size: 20),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'SLIIT (Malabe)',
                        child: Text('SLIIT (Malabe)'),
                      ),
                      DropdownMenuItem(
                        value: 'UoM (Moratuwa)',
                        child: Text('UoM (Moratuwa)'),
                      ),
                      DropdownMenuItem(
                        value: 'NSBM (Homagama)',
                        child: Text('NSBM (Homagama)'),
                      ),
                      DropdownMenuItem(
                        value: 'USJ (Nugegoda)',
                        child: Text('USJ (Nugegoda)'),
                      ),
                      DropdownMenuItem(
                        value: 'UOC (Colombo)',
                        child: Text('UOC (Colombo)'),
                      ),
                      DropdownMenuItem(
                        value: 'Kelaniya Uni',
                        child: Text('Kelaniya Uni'),
                      ),
                      DropdownMenuItem(
                        value: 'Other Campus',
                        child: Text('Other Campus / Institute'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Password
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                  decoration: InputDecoration(
                    hintText: 'Create strong password',
                    prefixIcon:
                        const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submitRegister,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.darkPrimary : AppColors.teal,
                      foregroundColor:
                          isDark ? AppColors.deepNavy : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          if (widget.onNavigateLogin != null) {
                            widget.onNavigateLogin!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
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
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Your Password?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email address and we will send you a password reset verification link.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mark_email_read_rounded,
                        color: AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Reset instructions have been sent to ${_emailController.text}. Please check your inbox.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to Login'),
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      if (_emailController.text.contains('@')) {
                        setState(() => _sent = true);
                      }
                    },
                    child: const Text('Send Reset Link'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
