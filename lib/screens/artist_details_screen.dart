import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/global.dart';

class ArtistDetailsScreen extends StatefulWidget {
  static const String id = 'artist';
  const ArtistDetailsScreen({super.key});

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  late Future<List<Artist>> _futureArtist;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureArtist = fetchArtist();
  }

  Future<List<Artist>> fetchArtist() async {
    final response = await http.get(Uri.parse('$baseURL/artist'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artist details');
    }
  }
  void _showAddArtistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();
        final TextEditingController mobileController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Artist'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                String newName = nameController.text;
                String newEmail = emailController.text;
                String newMobile = mobileController.text;

                // Add new artist
                await _addNewArtist(newName, newEmail, newMobile);

                // ignore: use_build_context_synchronously
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),

          ],
        );
      },
    );
  }
  Future<void> _addNewArtist(String name, String email, String mobile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/artist/register'),
        body: {
          'name': name,
          'email': email,
          'mobile': mobile,
          'password':'12345678',
          'confirm_password':'12345678'
        },
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artist added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _futureArtist = fetchArtist();
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add artist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add artist. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                ' Artist Details',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search artist...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: FutureBuilder<List<Artist>>(
                future: _futureArtist,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Artist> filteredArtists = snapshot.data!
                        .where((artist) =>
                        artist.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();
                    return SizedBox(
                      width: double.infinity, // Set width to fill the available space
                      height: 400, // Set height to increase the size of the table
                      child: ArtistTable(artist: filteredArtists),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: _showAddArtistDialog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Artist {
  final int id;
  final String name;
  final String email;
  final String mobile;

  Artist({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}

class ArtistTable extends StatefulWidget {
  final List<Artist> artist;

  const ArtistTable({Key? key, required this.artist}) : super(key: key);

  @override
  State<ArtistTable> createState() => _ArtistTableState();
}

class _ArtistTableState extends State<ArtistTable> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Mobile')),
        DataColumn(label: Text('Actions')),
      ],
      rows: widget.artist
          .map(
            (artist) => DataRow(
          cells: [
            DataCell(Text(artist.id.toString())),
            DataCell(Text(artist.name)),
            DataCell(Text(artist.email)),
            DataCell(Text(artist.mobile)),
            DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final TextEditingController nameController =
                          TextEditingController(text: artist.name);
                          final TextEditingController emailController =
                          TextEditingController(text: artist.email);
                          final TextEditingController mobileController =
                          TextEditingController(text: artist.mobile);

                          return AlertDialog(
                            title: const Text('Edit Artist'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration:
                                    const InputDecoration(labelText: 'Name'),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration:
                                    const InputDecoration(labelText: 'Email'),
                                  ),
                                  TextField(
                                    controller: mobileController,
                                    decoration:
                                    const InputDecoration(labelText: 'Mobile'),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                                onPressed: () async {
                                  String newName = nameController.text;
                                  String newEmail = emailController.text;
                                  String newMobile = mobileController.text;
                                  final response = await http.put(
                                    Uri.parse('$baseURL/artist/${artist.id}'),
                                    body: {
                                      'name': newName,
                                      'email': newEmail,
                                      'mobile': newMobile,
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    // User details updated successfully
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Artist details updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    setState(() {}); // Refresh the table
                                  } else {
                                    // Failed to update user details
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to update artist details'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 20,),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this artist?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final response = await http.delete(
                                      Uri.parse('$baseURL/artist/${artist.id}'));
                                  if (response.statusCode == 200) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Artist deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    setState(() {}); // Refresh the table
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                        Text('Failed to delete artist'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}
