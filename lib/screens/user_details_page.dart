import 'dart:async';
import 'dart:convert';
import 'package:artist_community_admin/constants/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  static const String id = 'user';
  const UserDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late Future<List<User>> _futureUsers;
  late String _searchQuery = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseURL/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user details');
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
                ' User Details',
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
              child: FutureBuilder<List<User>>(
                future: _futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<User> filteredUsers = snapshot.data!
                        .where((user) =>
                        user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();
                    return SizedBox(
                      width: double.infinity, // Set width to fill the available space
                      height: 400, // Set height to increase the size of the table
                      child: UserTable(users: filteredUsers),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    floatingActionButton:FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () {
        // Show dialog using Builder widget to access the context
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Builder(
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add User'),
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
                        // Get values from text controllers
                        String name = nameController.text;
                        String email = emailController.text;
                        String mobile = mobileController.text;

                        // Perform API call to add user
                        final response = await http.post(
                          Uri.parse('$baseURL/user/register'),
                          body: {
                            'name': name,
                            'mobile': mobile,
                            'email': email,
                            'password':'12345678',
                            'confirm_password':'12345678'
                          },
                        );

                        if (response.statusCode == 200) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          setState(() {
                            _futureUsers = fetchUsers();
                          }); // Refresh the user list
                        } else {
                          print(response.body);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to add user'),
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
        );
      },
      child: const Icon(Icons.add),
    ),

    );
  }
}


class User {
  final int id;
  final String name;
  final String email;
  final String mobile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}

class UserTable extends StatefulWidget {
  final List<User> users;

  const UserTable({Key? key, required this.users}) : super(key: key);

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
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
      rows: widget.users.map((user) => DataRow(
          cells: [
            DataCell(Text(user.id.toString())),
            DataCell(Text(user.name)),
            DataCell(Text(user.email)),
            DataCell(Text(user.mobile)),
            DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final TextEditingController nameController =
                          TextEditingController(text: user.name);
                          final TextEditingController emailController =
                          TextEditingController(text: user.email);
                          final TextEditingController mobileController =
                          TextEditingController(text: user.mobile);

                          return AlertDialog(
                            title: const Text('Edit User'),
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
                                    Uri.parse('$baseURL/users/${user.id}'),
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
                                        content: Text('User details updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    setState(() {}); // Refresh the table
                                  } else {
                                    // Failed to update user details
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to update user details'),
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
                                'Are you sure you want to delete this user?'),
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
                                      Uri.parse('$baseURL/users/${user.id}'));
                                  if (response.statusCode == 200) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'User deleted successfully'),
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
                                        Text('Failed to delete user'),
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
