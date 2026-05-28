import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImagePicked;

  const ImagePickerWidget({super.key, this.imageFile, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera)),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery)),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1024, imageQuality: 80);
    if (picked != null) onImagePicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: imageFile != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageFile!, width: double.infinity, height: 180, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: CircleAvatar(
                      radius: 16, backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.white),
                        onPressed: () => onImagePicked(null),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 40, color: theme.colorScheme.outline),
                  const SizedBox(height: 8),
                  Text('Add photo', style: theme.textTheme.bodySmall),
                ],
              ),
      ),
    );
  }
}
