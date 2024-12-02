import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/AdminMechanicADD.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddMechanicScreen extends StatefulWidget {
  const AddMechanicScreen({super.key});

  @override
  _AddMechanicScreenState createState() => _AddMechanicScreenState();
}

class _AddMechanicScreenState extends State<AddMechanicScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to get input values
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _experienceController.clear();
    _passwordController.clear();
    setState(() {
      _image = null; // Clear the selected image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Mechanic',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage, // Function to pick image
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : null, // Show picked image
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 40,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_nameController, 'Mechanic Name'),
              SizedBox(height: 20),
              _buildTextField(_emailController, 'Email'),
              SizedBox(height: 20),
              _buildTextField(_phoneController, 'Phone Number'),
              SizedBox(height: 20),
              _buildTextField(_experienceController, 'Years of Experience'),
              SizedBox(height: 30),
              _buildTextField(_passwordController, 'Password',
                  isPassword: true),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "experience": _experienceController.text,
                      "phone": _phoneController.text
                    };
                    await MechanicReg(context, _emailController.text,
                        _passwordController.text, data, _image);
                    _clearForm(); // Clear fields after submission
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                ),
                child: Text(
                  'Register Mechanic',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword, // Set to true if this is a password field
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.blueGrey[600]),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
