import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rat3/FavouritePage.dart';
import 'package:flutter_application_rat3/Login.dart';
import 'package:flutter_application_rat3/Publish.dart';


class DrawerPage extends StatefulWidget {
  const DrawerPage(BuildContext context, {super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}


class _DrawerPageState extends State<DrawerPage> {

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child:
         Container(
          color: const Color.fromARGB(255, 46, 54, 63), 
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: const Color(0xFFFFF5CD),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 130,
                     child: Image.asset('assets/ratImage.png'),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.home,
                      size: 28,
                      color: Color.fromARGB(172, 82, 128, 199),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                  
                  });

                  Navigator.pop(context);
                },
              ),
              const Divider(
                color: Color.fromARGB(15, 156, 125, 128),
                thickness: 2,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.food_bank,
                      size: 28,
                      color: Colors.orange
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Add New dish',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) =>   Publish())),
                  );

setState(() {
                    
                  });
                },
              ),
              const Divider(
                color: Color(0x0f836164),
                thickness: 2,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 28,
                      color: Colors.red
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Favorites',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: ((context) =>   FavoritesPage())),
                  );
                  setState(() {
               
                  });
                 
                  
                },
              ),
              const Divider(
                color: Color(0x0f836164),
                thickness: 2,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 28,
                      color:  Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Logout',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );                },
              ),
            ],
          ),
        ),
      );
      
  }
}