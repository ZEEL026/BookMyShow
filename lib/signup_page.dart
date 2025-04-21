import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Map<String, String> _errors = {
    'name': '',
    'email': '',
    'phoneNumber': '',
    'password': '',
    'confirmPassword': '',
  };
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _shakeController;

  // Validation patterns
  final _namePattern = RegExp(r'^[a-zA-Z\s]{2,}$');
  final _emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _phonePattern = RegExp(r'^\d{10}$');
  final _passwordPattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$');

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _nameController.addListener(() => _validateField('name'));
    _emailController.addListener(() => _validateField('email'));
    _phoneNumberController.addListener(() => _validateField('phoneNumber'));
    _passwordController.addListener(() => _validateField('password'));
    _confirmPasswordController.addListener(() => _validateField('confirmPassword'));
  }

  void _validateField(String field) {
    setState(() {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (field == 'name') {
        if (name.isEmpty) {
          _errors['name'] = 'Name is required';
        } else if (!_namePattern.hasMatch(name)) {
          _errors['name'] = 'Name must be 2+ letters or spaces';
        } else {
          _errors['name'] = '';
        }
      }

      if (field == 'email') {
        if (email.isEmpty) {
          _errors['email'] = 'Email is required';
        } else if (!_emailPattern.hasMatch(email)) {
          _errors['email'] = 'Invalid email address';
        } else {
          _errors['email'] = '';
        }
      }

      if (field == 'phoneNumber') {
        if (phoneNumber.isEmpty) {
          _errors['phoneNumber'] = 'Phone number is required';
        } else if (!_phonePattern.hasMatch(phoneNumber)) {
          _errors['phoneNumber'] = 'Must be 10 digits';
        } else {
          _errors['phoneNumber'] = '';
        }
      }

      if (field == 'password') {
        if (password.isEmpty) {
          _errors['password'] = 'Password is required';
        } else if (!_passwordPattern.hasMatch(password)) {
          _errors['password'] = '8+ chars, 1 upper, 1 lower, 1 number, 1 special';
        } else {
          _errors['password'] = '';
        }
      }

      if (field == 'confirmPassword') {
        if (confirmPassword.isEmpty) {
          _errors['confirmPassword'] = 'Confirm password is required';
        } else if (confirmPassword != password) {
          _errors['confirmPassword'] = 'Passwords do not match';
        } else {
          _errors['confirmPassword'] = '';
        }
      }

      if (_errors[field]!.isNotEmpty) {
        _shakeController.forward(from: 0);
      }
    });
  }

  Future<void> _signUp() async {
    _validateField('name');
    _validateField('email');
    _validateField('phoneNumber');
    _validateField('password');
    _validateField('confirmPassword');

    if (_errors.values.any((error) => error.isNotEmpty)) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .collection('docs')
            .add({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errors['email'] = e.message ?? 'Sign up failed. Please try again.';
        _isLoading = false;
        _shakeController.forward(from: 0);
      });
    } catch (e) {
      setState(() {
        _errors['email'] = 'An error occurred: $e';
        _isLoading = false;
        _shakeController.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFD81B60), Colors.red[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeScaleTransition(
            animation: primaryAnimation,
            child: child,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _shakeController,
                        curve: Curves.easeIn,
                      ),
                      child: Text(
                        'BookMyShow',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Now',
                            style: GoogleFonts.poppins(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Create your account to book movies',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Name Field
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                            errorText: _errors['name'],
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _errors['email'],
                          ),
                          const SizedBox(height: 16),

                          // Phone Number Field
                          _buildTextField(
                            controller: _phoneNumberController,
                            hintText: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            errorText: _errors['phoneNumber'],
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Create Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            errorText: _errors['password'],
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            errorText: _errors['confirmPassword'],
                          ),
                          const SizedBox(height: 28),

                          // Sign Up Button
                          Align(
                            alignment: Alignment.center,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : AnimatedBuilder(
                                    animation: _shakeController,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(6 * sin(2 * pi * _shakeController.value), 0),
                                        child: child,
                                      );
                                    },
                                    child: GestureDetector(
                                      onTapDown: (_) => setState(() {}),
                                      onTapUp: (_) => _signUp(),
                                      child: Transform.scale(
                                        scale: _isLoading ? 1.0 : 1.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [const Color(0xFFD81B60), Colors.red[900]!],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.35),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'Sign Up',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(6 * sin(2 * pi * _shakeController.value), 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white70,
              ),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.red[300]!, Colors.red[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  errorText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }
}