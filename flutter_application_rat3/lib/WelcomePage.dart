import 'package:flutter/material.dart';
import 'package:flutter_application_rat3/Login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/rat2.png', 
              fit: BoxFit.cover, // fill the screen
            ),
          ),
          // Content above the background
          Center(
            
            child:Container(
              
              margin:EdgeInsets.only(top: 40),
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Ratatouille",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    //color: Color.fromARGB(255, 46, 54, 63), 
                    color: const Color.fromARGB(255, 20, 88, 144)
                  ),
                ),
                SizedBox(height: 10), // Space between the two texts
                Text(
                  "Where Anyone can cook",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 46, 54, 63),
                    
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(onPressed: (){
                  
                  Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                }, child:  
                Text("let's cook",style: TextStyle(
                  fontSize: 35,
                  //  fontWeight: FontWeight.bold,
                ),
                ),
                style:
                 ElevatedButton.styleFrom(
                  backgroundColor:  Color.fromARGB(255, 20, 88, 144),
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20),)),
    
                ),
                
              ],
            ),)
          ),
        ],
      ),
    );
  }
}
