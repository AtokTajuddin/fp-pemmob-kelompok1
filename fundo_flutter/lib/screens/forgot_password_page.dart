import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // 1. STEP TRACKER
  int _currentStep = 0; // 0: Email, 1: OTP, 2: New Password

  // 2. CONTROLLER FORM
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Status password
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color primaryColor = const Color(0xFF10B981);
  final Color dangerColor = const Color(0xFFFF5252);

  final List<String> _stepTitles = [
    "Verify Email",
    "Enter OTP Code",
    "Create New Password"
  ];

  // Next / Back Step Handlers

  void _nextStep() {
    // Simulasi validasi
    if (_currentStep == 0) {
      if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
        _showSnackBar("Please enter a valid email address.");
        return;
      }
      _showSnackBar("OTP sent to ${_emailController.text}");
    } else if (_currentStep == 1) {
      if (_otpController.text.length != 6) {
        _showSnackBar("Please enter the 6-digit OTP.");
        return;
      }
      _showSnackBar("OTP verified successfully!");
    } else if (_currentStep == 2) {
      if (_newPasswordController.text != _confirmPasswordController.text || _newPasswordController.text.length < 6) {
        _showSnackBar("Passwords must match and be at least 6 characters.");
        return;
      }
      _showSnackBar("Password changed successfully! Redirecting...");
      Navigator.pop(context); 
      return;
    }
    
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // BUILDER FOR EACH STEP CONTENT

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildEmailInput();
      case 1:
        return _buildOtpInput();
      case 2:
        return _buildNewPasswordInput();
      default:
        return Container();
    }
  }

  // Input Email
  Widget _buildEmailInput() {
    return Column(
      children: [
        const Text(
          "Enter your email to receive a verification code.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email Address",
            hintText: "example@email.com",
            prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // Input OTP
  Widget _buildOtpInput() {
    return Column(
      children: [
        Text(
          "We sent a 6-digit code to ${_emailController.text}.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: "Verification Code",
            counterText: "",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => _showSnackBar("Resending code..."),
          child: Text("Resend Code", style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }

  // New Password
  Widget _buildNewPasswordInput() {
    return Column(
      children: [
        const Text(
          "Your new password must be different from previous passwords.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        // Input New Password
        TextField(
          controller: _newPasswordController,
          obscureText: !_isNewPasswordVisible,
          decoration: InputDecoration(
            labelText: "New Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        // Input Confirm Password
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: _previousStep,
        ),
        title: Text(
          _stepTitles[_currentStep],
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStepContent(_currentStep),
            
            const SizedBox(height: 50),

            // Continue / Reset Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: Text(
                  _currentStep == 2 ? "Reset Password" : "Continue",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}