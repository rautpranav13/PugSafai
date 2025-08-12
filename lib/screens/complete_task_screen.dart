import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pug_safai/widgets/checklist_widget.dart';
import '../services/api_services.dart';

class CompleteTaskScreen extends StatefulWidget {
  final String taskId;

  const CompleteTaskScreen({super.key, required this.taskId});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _finalCommentController = TextEditingController();
  final List<XFile> _afterImages = [];

  bool _isSubmitting = false;

  /// Capture an image from the camera (max 5)
  Future<void> _captureImage() async {
    if (_afterImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can capture a maximum of 5 photos.')),
      );
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _afterImages.add(pickedFile);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _afterImages.removeAt(index);
    });
  }

  Future<void> _submitCompletion() async {
    if (_finalCommentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a final comment.')),
      );
      return;
    }
    if (_afterImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture at least one after photo.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ApiService.putCompletedTask(
        context: context,
        taskId: widget.taskId,
        finalComment: _finalCommentController.text.trim(),
        afterPhotos: _afterImages.map((xfile) => File(xfile.path)).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed successfully!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. After Cleaning Photos
            Text('After Cleaning Photos (Max 5)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _afterImages.length < 5 ? _captureImage : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Photo'),
            ),
            const SizedBox(height: 8),
            _afterImages.isEmpty
                ? const Text('No images captured.')
                : Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _afterImages.asMap().entries.map((entry) {
                int idx = entry.key;
                XFile image = entry.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.file(
                      File(image.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeImage(idx),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            /// 2. Final Comment
            TextField(
              controller: _finalCommentController,
              decoration: const InputDecoration(
                labelText: 'Final Comment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            /// 3. Checklist placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(8.0),
                child: const ChecklistWidget(),
              ),
            ),

            /// 4. Complete Work Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _isSubmitting ? null : _submitCompletion,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Complete Work'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
