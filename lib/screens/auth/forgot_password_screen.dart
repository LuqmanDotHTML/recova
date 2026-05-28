import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _reset() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    await context.read<AuthProvider>().resetPassword(_emailCtrl.text.trim());
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mark_email_read, size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Check your email', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('We sent a password reset link to ${_emailCtrl.text}', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  CustomButton(text: 'Back to Login', onPressed: () => Navigator.pop(context)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your email and we\'ll send you a reset link.',
                    style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  CustomTextField(controller: _emailCtrl, label: 'Email', hint: 'student@university.edu',
                    prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  CustomButton(text: 'Send Reset Link', onPressed: _reset),
                ],
              ),
      ),
    );
  }
}
