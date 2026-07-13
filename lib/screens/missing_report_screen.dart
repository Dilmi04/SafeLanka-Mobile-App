import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/report_model.dart';
import '../services/firebase_service.dart';

class ReportMissingPersonScreen extends StatefulWidget {
  const ReportMissingPersonScreen({Key? key}) : super(key: key);

  @override
  State<ReportMissingPersonScreen> createState() => _ReportMissingPersonScreenState();
}

class _ReportMissingPersonScreenState extends State<ReportMissingPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedFile;
  Uint8List? _webImageBytes;
  bool _isLoading = false;

  // Controllers to grab user inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, 
        imageQuality: 50, 
      );
      
      if (selected != null) {
        if (kIsWeb) {
          final bytes = await selected.readAsBytes();
          setState(() {
            _pickedFile = selected;
            _webImageBytes = bytes;
          });
        } else {
          setState(() {
            _pickedFile = selected;
          });
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a photo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String imageUrl = await _firebaseService.uploadImage(_pickedFile!);

      if (imageUrl.isEmpty) {
        throw Exception("Failed to upload image. Please check your internet connection.");
      }

      ReportModel report = ReportModel(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        description: _descriptionController.text.trim(),
        lastSeenLocation: _locationController.text.trim(),
        lastSeenDate: _selectedDate ?? DateTime.now(),
        imageUrl: imageUrl,
        status: 'Missing',
        reportedBy: FirebaseAuth.instance.currentUser?.uid ?? 'Guest',
      );

      await _firebaseService.addReport(report);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            fillColor: Colors.white,
            filled: true,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFBFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Missing Person',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Photo Uploader Container Box
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                              ),
                              child: _pickedFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: kIsWeb
                                      ? (_webImageBytes != null
                                          ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                                          : const CircularProgressIndicator())
                                      : Image.file(File(_pickedFile!.path), fit: BoxFit.cover),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined, color: Colors.grey[400], size: 48),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Add Photo',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 2. Input Fields
                          _buildFormField(
                            label: 'Full Name',
                            hint: 'Enter full name',
                            controller: _nameController,
                          ),
                          _buildFormField(
                            label: 'Age',
                            hint: 'Enter age',
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildFormField(
                            label: 'Last Seen Location',
                            hint: 'Enter location',
                            controller: _locationController,
                          ),
                          _buildFormField(
                            label: 'Last Seen Date',
                            hint: 'Select Date',
                            controller: _dateController,
                            readOnly: true,
                            suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[500], size: 20),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                  _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                          ),
                          _buildFormField(
                            label: 'Description',
                            hint: 'Any other information...',
                            controller: _descriptionController,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Persistent Bottom Button Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit Report',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
