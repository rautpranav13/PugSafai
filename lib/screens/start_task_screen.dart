import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pug_safai/services/api_services.dart';
import 'package:pug_safai/models/location.dart';

class StartTaskScreen extends StatefulWidget {
  const StartTaskScreen({super.key});

  @override
  State<StartTaskScreen> createState() => _StartTaskScreenState();
}

class _StartTaskScreenState extends State<StartTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Location> _locations = [];
  Location? _selectedLocation;
  final List<XFile> _beforeImages = [];
  final _initialRemarksController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      _locations = await ApiService.getLocations();
      if (_locations.isNotEmpty) {
        // Optionally, set a default selected location or leave it null
        // _selectedLocation = _locations.first;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load locations: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    if (_beforeImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can select a maximum of 5 images.')),
      );
      return;
    }
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            _beforeImages.add(pickedFile);
          });
        }
      }
    } catch (e) {
        if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to pick image: $e')),
         );
       }
    }
  }

  void _removeImage(int index) {
    if (mounted) {
      setState(() {
        _beforeImages.removeAt(index);
      });
    }
  }

  Future<void> _submitStartCleaning() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location.')),
      );
      return;
    }
    if (_beforeImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Convert XFile to File list
      final List<File> beforeFiles =
      _beforeImages.map((xfile) => File(xfile.path)).toList();

      final response = await ApiService.postStartTask(
        context: context,
        address: _selectedLocation!.name,
        siteId: _selectedLocation!.id,
        initialComment: _initialRemarksController.text.trim(),
        beforePhotos: beforeFiles,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task started successfully!')),
      );
      Navigator.pop(context, true); // go back and indicate success
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start task: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  void dispose() {
    _initialRemarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Cleaning Task'),
      ),
      body: _isLoading && _locations.isEmpty // Show loader only if locations are not yet loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Location Dropdown
                    DropdownButtonFormField<Location>(
                      value: _selectedLocation,
                      hint: const Text('Select Location'),
                      isExpanded: true,
                      items: _locations.map((Location location) {
                        return DropdownMenuItem<Location>(
                          value: location,
                          child: Text(location.name ?? 'Unnamed Location'), // Assuming Location has 'name'
                        );
                      }).toList(),
                      onChanged: (Location? newValue) {
                        if (mounted) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        }
                      },
                      validator: (value) => value == null ? 'Please select a location' : null,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Before Cleaning Photos
                    Text('Before Cleaning Photos (Max 5)', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _beforeImages.length < 5 ? _pickImage : null,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Add Photo'),
                    ),
                    const SizedBox(height: 8),
                    _beforeImages.isEmpty
                        ? const Text('No images selected.')
                        : Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _beforeImages.asMap().entries.map((entry) {
                              int idx = entry.key;
                              XFile image = entry.value;
                              return Stack(
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

                    // 3. Initial Remarks
                    TextFormField(
                      controller: _initialRemarksController,
                      decoration: const InputDecoration(
                        labelText: 'Initial Remarks',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      // validator: (value) { // Optional: add validation if remarks are mandatory
                      //   if (value == null || value.trim().isEmpty) {
                      //     return 'Please enter initial remarks';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 30),

                    // 4. Start Cleaning Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitStartCleaning,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Start Cleaning'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
