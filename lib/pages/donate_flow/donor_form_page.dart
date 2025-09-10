import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '/services/database_service.dart';
import '/models/donor.dart';
import '/widgets/theme_page.dart';
import 'package:scanmyblood/services/location_picker_page.dart'; // ✅ ensure ye file bni ho

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
  final _addressController = TextEditingController();

  String _phoneNumber = "";
  String _countryCode = "+92"; // default Pakistan
  bool _isSubmitting = false;

  /// ✅ Submit Form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final donor = Donor(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        contact: "$_countryCode$_phoneNumber",
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
              children: [
                Text(
                  "Your Blood Group: ${widget.myGroup}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),

                /// Name
                _textField(controller: _nameController, label: "Full Name"),
                const SizedBox(height: 12),

                /// City
                _textField(controller: _cityController, label: "City"),
                const SizedBox(height: 12),

                /// Address + Pick Button
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _addressController,
                        label: "Address (auto-filled if picked)",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.map, color: Colors.red),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPickerPage(),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _addressController.text = result["address"];
                            _cityController.text = result["city"];
                          });
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),

                /// Phone with Flag
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  onChanged: (phone) {
                    _countryCode = phone.countryCode;
                    _phoneNumber = phone.number;
                  },
                ),
                const SizedBox(height: 20),

                /// Submit Button
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
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.trim().isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
