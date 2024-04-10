import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/global.dart';
import 'package:http/http.dart' as http;

class ExhibitionDetails extends StatefulWidget {
  static const String id = 'exhibition';
  const ExhibitionDetails({Key? key}) : super(key: key);

  @override
  State<ExhibitionDetails> createState() => _ExhibitionDetailsState();
}

class Exhibition {
  final String id;
  String name;
  final String imageUrl;
  String description;
  String venue;
  String time;

  Exhibition({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.venue,
    required this.time,
  });
}

class _ExhibitionDetailsState extends State<ExhibitionDetails> {
  List<Exhibition> _exhibitions = [];

  @override
  void initState() {
    super.initState();
    _fetchExhibitions();
  }

  Uint8List? _imageBytes;
  String _name = '';
  String _description = '';
  String _venue = '';
  String _time = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _saveExhibition() async {
    if (_imageBytes == null) return;

    const url = '$baseURL/exhibition/save';
    var request = http.MultipartRequest('post', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes(
      'image_url',
      _imageBytes!,
      filename: 'image_url.jpg',
    ));
    request.fields['name'] = _name;
    request.fields['description'] = _description;
    request.fields['venue'] = _venue;
    request.fields['time'] = _time;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print(response.headers);
    }
  }

  Future<void> _fetchExhibitions() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/exhibitions'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Exhibition> exhibitions = [];

        for (var item in data) {
          exhibitions.add(Exhibition(
            id: item['id'].toString(),
            name: item['name'],
            imageUrl: item['image_url'],
            description: item['description'],
            venue: item['venue'],
            time: item['time'],
          ));
        }

        setState(() {
          _exhibitions = exhibitions;
        });
      } else {
        print('Failed to fetch exhibitions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exhibitions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Exhibition Details ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const Divider(),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Venue',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _venue = value;
                });
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Time',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _time = value;
                });
              },
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 30,
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Pick Image'),
              ),
            ),
            if (_imageBytes != null) Image.memory(_imageBytes!),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 140,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black),
                    onPressed: _saveExhibition,
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SizedBox(
              height: 300, // Adjust height as needed
              child: ListView.builder(
                itemCount: _exhibitions.length,
                itemBuilder: (context, index) {
                  return _buildExhibitionItem(_exhibitions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExhibitionItem(Exhibition exhibition) {
    const imageUrl = 'http://127.0.0.1:8000';
    return ListTile(
      title: Text(exhibition.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Venue: ${exhibition.venue}'),
          Text('Description: ${exhibition.description}'),
          Text('Time: ${exhibition.time}'),
        ],
      ),
      leading: exhibition.imageUrl.isNotEmpty ? Image.network(
          '$imageUrl${exhibition.imageUrl}') : Container(),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(exhibition);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteExhibition(exhibition.id);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Exhibition exhibition) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Exhibition'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: exhibition.name,
                  onChanged: (value) {
                    setState(() {
                      exhibition.name = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  initialValue: exhibition.venue,
                  onChanged: (value) {
                    setState(() {
                      exhibition.venue = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),
                TextFormField(
                  initialValue: exhibition.description,
                  onChanged: (value) {
                    setState(() {
                      exhibition.description = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  initialValue: exhibition.time,
                  onChanged: (value) {
                    setState(() {
                      exhibition.time = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateExhibition(exhibition);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExhibition(String id) async {
    final response = await http.delete(Uri.parse('$baseURL/exhibitions/$id'));

    if (response.statusCode == 200) {
      // Exhibition deleted successfully
      _fetchExhibitions();
    } else {
      // Error occurred
      print('Failed to delete exhibition: ${response.statusCode}');
    }
  }

  Future<void> _updateExhibition(Exhibition exhibition) async {
    final response = await http.put(
      Uri.parse('$baseURL/exhibitions/${exhibition.id}'),
      body: {
        'name': exhibition.name,
        'venue': exhibition.venue,
        'description': exhibition.description,
        'time': exhibition.time,
      },
    );

    if (response.statusCode == 200) {
      // Exhibition updated successfully
      _fetchExhibitions();
    } else {
      // Error occurred
      print('Failed to update exhibition: ${response.statusCode}');
    }
  }
}
