import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rat3/Signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
 /* void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratatouille"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 150,
                  child: Image.asset('assets/ratImage.png'),
                ),
                SizedBox(height: 20),
                Text("Login to start cooking", style: TextStyle(fontSize: 30)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffix: Icon(Icons.person_2_sharp),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 25,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        if (userCredential.user != null) {
                          await _firestore
                              .collection("Users")
                              .doc(userCredential.user!.uid)
                              .set(
                            {'uid': userCredential.user!.uid},
                            SetOptions(merge: true),
                          );

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "homesecond", (route) => false);
                        }
                      } on FirebaseAuthException catch (e) {
                        String message = e.message ?? "Authentication failed.";
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Login",style: TextStyle(
                  fontSize: 32,
                  //  fontWeight: FontWeight.bold,
                ),),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:  Color.fromARGB(255, 46, 54, 63),
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20),))
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",),
                    TextButton(
                      onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: ((context) =>   Signup())),
                  );
                      },
                      child: Text("Sign up",style: TextStyle(
                 color:  Color.fromARGB(255, 46, 54, 63)
                  //  fontWeight: FontWeight.bold,
                ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
