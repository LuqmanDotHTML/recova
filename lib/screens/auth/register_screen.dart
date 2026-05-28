import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _studentIdCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _studentIdCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      fullName: _nameCtrl.text.trim(),
      studentId: _studentIdCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please log in.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CustomTextField(controller: _nameCtrl, label: 'Full Name', hint: 'Ahmad bin Ali', prefixIcon: Icons.person_outline,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            CustomTextField(controller: _studentIdCtrl, label: 'Student ID', hint: '2021123456', prefixIcon: Icons.badge_outlined,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            CustomTextField(controller: _emailCtrl, label: 'Email', hint: 'student@university.edu', prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null),
            const SizedBox(height: 16),
            CustomTextField(controller: _phoneCtrl, label: 'Phone (optional)', hint: '0123456789', prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            CustomTextField(controller: _passCtrl, label: 'Password', hint: 'Min 6 characters', prefixIcon: Icons.lock_outline,
              obscureText: !_showPass,
              suffix: IconButton(icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _showPass = !_showPass)),
              validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null),
            const SizedBox(height: 16),
            CustomTextField(controller: _confirmCtrl, label: 'Confirm Password', hint: 'Re-enter password', prefixIcon: Icons.lock_outline,
              obscureText: !_showPass,
              validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
            const SizedBox(height: 24),
            CustomButton(text: 'Register', onPressed: _register, isLoading: auth.isLoading),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already have an account? '),
              TextButton(onPressed: () => context.pop(), child: const Text('Log in')),
            ]),
          ],
        ),
      ),
    );
  }
}
