import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'mock_ai.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key); 
  @override
  DonorScreenState createState() => DonorScreenState();
}

class DonorScreenState extends State<DonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  File? _imageFile;
  bool isUploading = false;
  String? aiMatch, freshness;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() => isUploading = true);
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('donations/$fileName.jpg')
            .putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Mock AI
        aiMatch = await mockGeminiMatch(foodNameController.text, locationController.text);
        freshness = await mockExpiry(foodNameController.text);

        await FirebaseFirestore.instance.collection('donations').add({
          'food_name': foodNameController.text,
          'location': locationController.text,
          'image_url': imageUrl,
          'match': aiMatch,
          'expiry': freshness,
          'timestamp': Timestamp.now(),
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Donation submitted')));
        foodNameController.clear();
        locationController.clear();
        setState(() {
          _imageFile = null;
          isUploading = false;
        });
      } catch (e) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isUploading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: foodNameController,
                      decoration: InputDecoration(labelText: 'Food Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter food name' : null,
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Pickup Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter location' : null,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                      onPressed: _pickImage,
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(_imageFile!, height: 150),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitDonation,
                      child: Text('Submit Donation'),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
