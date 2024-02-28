import 'package:artist_community_admin/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBr9iOJ3B6s5cM3RXuf-KPODdHb_SWifD4",
        authDomain: "fir-app-cd159.firebaseapp.com",
        projectId: "fir-app-cd159",
        storageBucket: "fir-app-cd159.appspot.com",
        messagingSenderId: "950203864393",
        appId: "1:950203864393:web:ec0cde3b33a2b9cd3af698",
        measurementId: "G-WJGP4GYDXH"
    ),

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'ARTISPIC',
      debugShowCheckedModeBanner: false,
      home:  const LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}


