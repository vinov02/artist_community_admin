import 'dart:typed_data';
import 'package:artist_community_admin/screens/mydata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../constants/global.dart';

class ImageUploadScreen extends StatefulWidget {
  static const String id = 'products';
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  String _productName = '';
  Uint8List? _imageBytes;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    const url = '$baseURL/upload-image';
    var request = http.MultipartRequest('post', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes('image', _imageBytes!, filename: 'image.jpg'));
    request.fields['name'] = _productName;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Error uploading image');
      print(response.headers);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  ' Add Product Category',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productName = value;
                  });
                },
              ),
              if (_imageBytes != null) Image.memory(_imageBytes!),
              const SizedBox(height: 10,),
              SizedBox(
                height: 30,
                width: 150,
                child: ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Select Image'),
                ),
              ),
             const SizedBox(height: 10,),
              SizedBox(
                height: 30,
                width: 150,
                child: ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 30,
                width: 150,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyData()));
                  },
                  child: const Text('Fetch Image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
