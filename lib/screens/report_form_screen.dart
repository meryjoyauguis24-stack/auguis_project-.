import 'package:flutter/material.dart';

import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _hasError = false;
  bool _testErrorState = false;

  String _statusMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
      _hasError = false;
    });

    try {
      // Simulate a submission delay.
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Temporary test for the Error State.
      if (_testErrorState) {
        throw Exception('Report submission failed.');
      }

      setState(() {
        _statusMessage = 'Report submitted successfully!';
        _hasError = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Failed to submit report. Please try again.';
        _hasError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Form'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.description, size: 60, color: Colors.blue),
                  const SizedBox(height: 16),

                  const Text(
                    'Create a Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  AppTextField(
                    label: 'Name',
                    hint: 'Enter your name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Report Title',
                    hint: 'Enter report title',
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a report title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Description',
                    hint: 'Describe your report',
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  AppButton(
                    text: 'Submit Report',
                    isLoading: _isLoading,
                    onPressed: _submitReport,
                  ),
                  const SizedBox(height: 16),

                  if (_statusMessage.isNotEmpty)
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _hasError ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Temporary switch for testing the Error State.
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Test Error State'),
                    subtitle: const Text(
                      'Turn on to simulate a failed submission.',
                    ),
                    value: _testErrorState,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _testErrorState = value;
                              _statusMessage = '';
                              _hasError = false;
                            });
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
