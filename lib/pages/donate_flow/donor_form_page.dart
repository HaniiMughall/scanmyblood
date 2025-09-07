import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/services/database_service.dart';
import '/models/donor.dart';
import '/widgets/theme_page.dart';

class DonorFormPage extends StatefulWidget {
  final String myGroup;
  const DonorFormPage({required this.myGroup, super.key});

  @override
  _DonorFormPageState createState() => _DonorFormPageState();
}

class _DonorFormPageState extends State<DonorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final donor = Donor(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        contact: _contactController.text.trim(),
        bloodGroup: widget.myGroup,
        verified: false,
      );

      await DatabaseService.instance.addDonor(donor);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Thank you for registering!")),
        );
        Navigator.pop(context);
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      title: "Register as Donor",
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ jitni zarurat hai utni height
            children: [
              Text(
                "Your Blood Group: ${widget.myGroup}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              _textField(controller: _nameController, label: "Name"),
              const SizedBox(height: 12),
              _textField(controller: _cityController, label: "City"),
              const SizedBox(height: 12),
              _textField(controller: _contactController, label: "Contact"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit",
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) => v == null || v.trim().isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
