import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPassword2Visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratatouille"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [Container(
                    height: 200,
                    width: 150,
                    child: Image.asset('assets/ratImage.png'), 
                  ),
                  SizedBox(height: 20),
                  Text("SignUp", style: TextStyle(fontSize: 30)),
                  SizedBox(height: 10),
                
                TextFormField(
                  controller: _emailController,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                        .hasMatch(email)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  validator: (password) {
                    if (password == null || password.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    label: Text("Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  
                  obscureText: !_isPassword2Visible,
                  controller: _newPasswordController,
                  validator: (confirmPassword) {
                    if (confirmPassword != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPassword2Visible = !_isPassword2Visible;
                        });
                      },
                      icon: Icon(
                        _isPassword2Visible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 25,
                      ),
                    ),
                    label: Text("Confirm Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        print('User registered: ${credential.user!.email}');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "login",
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Your Account has been succesfuly registered', 
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green, // Red background for error
                                    duration: Duration(seconds: 3), // Show for 3 seconds
                                  ),
                                );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'The account already exists for that email.', 
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red, // Red background for error
                                  duration: Duration(seconds: 3), // Show for 3 seconds
                                ),
                              );
                        } else {
                          print('FirebaseAuthException: $e');
                        }
                      } catch (e) {
                        print('Error: $e');
                      }
                    }
                  },
                  child: Text("Register",style: TextStyle(
                  fontSize: 32,
                  //  fontWeight: FontWeight.bold,
                ),),style:
                ElevatedButton.styleFrom(
                  backgroundColor:  Color.fromARGB(255, 46, 54, 63),
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20),))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
