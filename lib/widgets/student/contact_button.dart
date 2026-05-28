import 'package:flutter/material.dart';

class ContactButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ContactButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Contact'),
      ),
    );
  }
}
