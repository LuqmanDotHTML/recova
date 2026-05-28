import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_constants.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(email: _emailCtrl.text.trim(), password: _passCtrl.text);
    if (!mounted) return;
    if (success) {
      switch (auth.role) {
        case UserRole.student: context.go(AppRoutes.studentHome);
        case UserRole.admin: context.go(AppRoutes.adminHome);
        case UserRole.guest: context.go(AppRoutes.guestHome);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 60),
              Icon(Icons.search, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Welcome back', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailCtrl, label: 'Email', hint: 'student@university.edu',
                prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passCtrl, label: 'Password', hint: 'Enter your password',
                prefixIcon: Icons.lock_outline, obscureText: !_showPass,
                suffix: IconButton(
                  icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
                validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(text: 'Log In', onPressed: _login, isLoading: auth.isLoading),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(onPressed: () => context.push(AppRoutes.register), child: const Text('Register')),
                ],
              ),
              const Divider(height: 32),
              CustomButton(
                text: 'Continue as Guest', isOutline: true,
                onPressed: () => context.go(AppRoutes.guestHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
