// request_blood_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:scanmyblood/models/blood_request.dart';
import 'package:scanmyblood/services/database_service.dart';
import 'dart:ui';

class RequestBloodPage extends StatefulWidget {
  const RequestBloodPage({super.key});

  @override
  State<RequestBloodPage> createState() => _RequestBloodPageState();
}

class _RequestBloodPageState extends State<RequestBloodPage> {
  final _formKey = GlobalKey<FormState>();
  final _bloodGroupController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactController = TextEditingController();
  bool _submitting = false;

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final id = const Uuid().v4();
    final r = BloodRequest(
      id: id,
      requesterName: 'Anonymous',
      bloodGroup: _bloodGroupController.text.trim(),
      city: _cityController.text.trim(),
      contact: _contactController.text.trim(),
      status: RequestStatus.pending,
    );

    try {
      await DatabaseService.instance.addRequest(r);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request created & nearby donors notified ✅'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting request ❌')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('Emergency Request'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.red, Colors.black87])))),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black87, Colors.red])),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            'Enter details to notify nearby donors immediately',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        _glassTextField(
                            controller: _cityController,
                            label: 'City / Location'),
                        const SizedBox(height: 12),
                        _glassTextField(
                            controller: _bloodGroupController,
                            label: 'Required blood group'),
                        const SizedBox(height: 12),
                        _glassTextField(
                            controller: _contactController,
                            label: 'Contact number (optional)',
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _submitRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _submitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Notify Nearby Donors'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassTextField(
      {required TextEditingController controller,
      required String label,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
    );
  }
}
