import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:artist_community_admin/constants/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'subcategory';
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseURL/admin/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = (jsonDecode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            // Add more UI for each product as needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          ).then((value) => fetchProducts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String imageUrl;

  Product({required this.id, required this.name, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late Uint8List _selectedImage;
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage() async {
    InputElement? uploadInput = FileUploadInputElement() as InputElement?;
    uploadInput?.click();

    uploadInput?.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.length == 1) {
        final file = files[0];
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _selectedImage = reader.result as Uint8List;
          });
        });
      }
    });
  }

  Future<void> _addProduct() async {
    final String name = _nameController.text;
    final bytes = _selectedImage.buffer.asUint8List();
    final response = await http.post(
      Uri.parse('$baseURL/admin/products'),
      body: {'name': name, 'image': base64Encode(bytes)},
    );
    if (response.statusCode == 200) {
      // Product added successfully
    } else {
      // Failed to add product
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            // ignore: unnecessary_null_comparison
            _selectedImage != null
                ? Image.memory(
              _selectedImage,
              height: 150,
            )
                : const SizedBox(),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addProduct();
                Navigator.pop(context);
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}