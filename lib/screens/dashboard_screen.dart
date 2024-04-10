import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/global.dart';

class DashBoardScreen extends StatefulWidget {
  static const String id = 'dashboard';
   const DashBoardScreen({
    super.key,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('$baseURL/admin/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        //print(response.body);
        throw Exception('Failed to logout');
      }
    } catch (e) {
      // Handle errors
     // print('Error logging out: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXL6l97sVfO4AO1EzhsnKeTXU9MAo6YAZ9yxAlvbNzZg&s"),
                          radius: 26.0,
                        ),
                        const SizedBox(width: 20,),
                        IconButton(
                            onPressed: (){
                              _logout();
                            },
                            icon: const Icon(Icons.logout))
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    //Now let's start with the dashboard main rapports
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.article,
                                        size: 26.0,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Artists",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "6 Artists",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.comment,
                                          size: 26.0,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "Comments",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "+32 Comments",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 26.0,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "Subscribers",
                                          style: TextStyle(
                                            fontSize: 26.0,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "3.2M Subscribers",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        size: 26.0,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Revenue",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "2.300 \$",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Now let's set the article section
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "6 Artists",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "3 new Artists",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300.0,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Type Artist Name",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),

                    //let's set the filter section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.deepPurple.shade400,
                          ),
                          label: Text(
                            "2024, February 12, February 13, February 14",
                            style: TextStyle(
                              color: Colors.deepPurple.shade400,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton(
                                hint: const Text("Filter by"),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Date",
                                    child: Text("Date"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Comments",
                                    child: Text("Comments"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Views",
                                    child: Text("Views"),
                                  ),
                                ],
                                onChanged: (value) {}),
                            const SizedBox(
                              width: 20.0,
                            ),
                            DropdownButton(
                                hint: const Text("Order by"),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Date",
                                    child: Text("Date"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Comments",
                                    child: Text("Comments"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Views",
                                    child: Text("Views"),
                                  ),
                                ],
                                onChanged: (value) {}),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    //Now let's add the Table
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.grey.shade200),
                            columns: const [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Artist Name")),
                              DataColumn(label: Text("Creation Date")),
                              DataColumn(label: Text("Views")),
                              DataColumn(label: Text("Comments")),
                            ],
                            rows: [
                              DataRow(cells: [
                                const DataCell(Text("0")),
                                const DataCell(
                                    Text("How to build a Flutter Web App")),
                                DataCell(Text("${DateTime.now()}")),
                                const DataCell(Text("2.3K Views")),
                                const DataCell(Text("102Comments")),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text("1")),
                                const DataCell(
                                    Text("How to build a Flutter Mobile App")),
                                DataCell(Text("${DateTime.now()}")),
                                const DataCell(Text("21.3K Views")),
                                const DataCell(Text("1020Comments")),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text("2")),
                                const DataCell(
                                    Text("Flutter for your first project")),
                                DataCell(Text("${DateTime.now()}")),
                                const DataCell(Text("2.3M Views")),
                                const DataCell(Text("10K Comments")),
                              ]),
                            ]),
                        //Now let's set the pagination
                        const SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "1",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "2",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "3",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "See All",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}