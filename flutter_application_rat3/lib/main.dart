import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rat3/Homesecond.dart';
import 'package:flutter_application_rat3/Login.dart';
import 'package:flutter_application_rat3/Publish.dart';
import 'package:flutter_application_rat3/Signup.dart';
import 'package:flutter_application_rat3/WelcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyBBJrVg-feIK4okgZMuLT4DYe-gDDISvk8', // From `current_key`
    appId:
        '1:109552235004:android:366be86a31eed63540c279', // From `mobilesdk_app_id`
    messagingSenderId: '109552235004', // From `project_number`
    projectId: 'ratproject3-d91dd', // From `project_id`
    storageBucket:
        'ratproject3-d91dd.appspot.com', // Corrected storage bucket URL
  ) );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: {
          "signin": (context) => const Signup(),
          "login": (context) => const Login(),
         
          "homesecond": (context) =>  Homesecond(),
          "Publish": (context) =>  Publish(),
         // "AddNewDishPage": (context) =>  AddNewDishPage(),

          
        },
        title: 'Flutter Demo',
        theme:
         ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Color.fromARGB(255, 46, 54, 63),
          titleTextStyle: TextStyle(color: Colors.white,fontSize: 30),
          ),
       
          

          useMaterial3: false,
        ),

       
         home:WelcomePage() );
      
  }
}
