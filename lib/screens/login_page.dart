// import 'package:artist_community_admin/components/side_menu.dart';
import 'dart:convert';
import 'package:artist_community_admin/components/side_menu.dart';
import 'package:artist_community_admin/constants/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9]{8}$');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();


  Future<void> _login() async {

    if(_formkey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String name = 'Admin'.trim();

      var response = await http.post(
          Uri.parse('$baseURL/admin/login'),
          body: {
            'email': username,
            'password': password,
            'name':name
          },
          headers: {
            'Accept': 'application/json'
          }
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String token = responseBody['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message']),
            backgroundColor: Colors.green, // Set background color for success message
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SideMenu()));
        print(response.body);
      } else {
        var errorResponse = jsonDecode(response.body);
        print(errorResponse);
        final errorMessage = errorResponse['error'];


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(errorMessage ?? 'An error occurred'),
          ),
        );

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  const Text('ARTISPIC',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body:  Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: 400,
                  width: 500,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                  ),
                child:  Column(
                  children: [
                    const SizedBox(height: 50,),
                    const Align(
                    alignment : Alignment.center,
                    child: Text('Log In',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                      ),
                    ),
                   ),
                    Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration:  const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Colors.grey
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'please enter email';
                            }else if (!emailRegex.hasMatch(value)) {
                              return 'please enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration:  const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'please enter password';
                            }
                            else if(!passwordRegex.hasMatch(value)){
                              return 'please enter minimum 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          width: 400,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black
                            ),
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}