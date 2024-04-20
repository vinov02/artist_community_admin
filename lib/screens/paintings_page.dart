import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/global.dart';
import 'package:http/http.dart' as http;

class PaintingsPage extends StatefulWidget {
  static const String id = 'paintings';
  const PaintingsPage({Key? key}) : super(key: key);

  @override
  State<PaintingsPage> createState() => _PaintingsPageState();
}

class Painting {
  final String id;
  String name;
  final String image;
  String description;
  String place;
  String price;

  Painting({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.place,
    required this.price,
  });
}

class _PaintingsPageState extends State<PaintingsPage> {
  List<Painting> _paintings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPaintings();
  }

  Future<void> _fetchPaintings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseURL/painting'));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data['painting'] is List) {
          List<Painting> paintings = [];

          for (var item in data['painting']) {
            paintings.add(Painting(
              id: item['id'].toString(),
              name: item['name'],
              image: item['image'],
              description: item['description'],
              place: item['place'],
              price: item['price'],
            ));
          }

          setState(() {
            _paintings = paintings;
            _isLoading = false;
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid painting data format'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('Failed to fetch paintings: ${response.statusCode}');
      }
    } catch (e) {

      print('Error fetching paintings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paintings Details',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Place')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _paintings.map((painting) {
                      return DataRow(cells: [
                        DataCell(Text(painting.id)),
                        DataCell(Text(painting.name)),
                        DataCell(Text(painting.description)),
                        DataCell(Text(painting.place)),
                        DataCell(Text(painting.price)),
                        DataCell(
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              'http://127.0.0.1:8000${painting.image}',
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit action
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete action
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
