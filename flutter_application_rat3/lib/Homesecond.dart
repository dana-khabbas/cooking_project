import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_rat3/Details.dart';
import 'package:flutter_application_rat3/Drawer.dart';
import 'package:flutter_application_rat3/Login.dart';
import 'package:flutter_application_rat3/Publish.dart';

class Homesecond extends StatefulWidget {
  @override
  _HomesecondState createState() => _HomesecondState();
}

class _HomesecondState extends State<Homesecond> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<QueryDocumentSnapshot> userDishes = [];
  final Set<String> favoriteDishes = {}; // Track favorite dishes by their names

  Future<void> addDishToFavorites({
    required String name,
    required String image,
    required String ingredients,
    required String steps,
    required String time,
    required String level,
  }) async {
    try {
      // Get the current user's UID
      final String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final String favoriteId = _firestore
          .collection('Users')
          .doc(userId)
          .collection('favorites')
          .doc()
          .id;

      final userFavoritesRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId);

      // Add the dish to the user's favorites
      await userFavoritesRef.set({
        'name': name,
        'image': image,
        'ingredients': ingredients,
        'steps': steps,
        'time': time,
        'level': level,
      });

      print("Dish added to favorites!");
    } catch (e) {
      print("Error adding dish to favorites: $e");
    }
  }

  // Fetch dishes from Firestore
  void getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("dishes").get();
    userDishes.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredDishes = userDishes
        .where((dish) => dish["name"]!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => Publish())),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 46, 54, 63),
      ),
      appBar: AppBar(
        title: Text('Ratatouille'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 46, 54, 63),
      ),
      drawer: DrawerPage(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section: Image with "Let's Cook" Text
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    "https://lumiere-a.akamaihd.net/v1/images/pp_ratatouille_herobanner_mobile_19736_4c2e46ac.jpeg?region=0,0,640,480",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "Let's Cook",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for recipes...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            // GridView Section for Recipes
            Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredDishes.length,
                itemBuilder: (context, index) {
                  final dish = filteredDishes[index];
                  final isFavorite = favoriteDishes.contains(dish["name"]!);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            dishName: dish["name"]!,
                            image: dish["image"]!,
                            ingredients: dish["ingredients"].join("\n")!,
                            steps: dish["steps"]!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dish Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              dish["image"]!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Dish Name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dish["name"]!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Dish Info
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "${dish["level"]!} | ${dish["time"]!}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          // Add to Favorites Icon
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                favoriteDishes.remove(dish["name"]);
                              } else {
                                await addDishToFavorites(
                                  name: dish["name"],
                                  image: dish["image"],
                                  ingredients: dish["ingredients"].join(", "),
                                  steps: dish["steps"],
                                  time: dish["time"],
                                  level: dish["level"],
                                );
                                favoriteDishes.add(dish["name"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${dish["name"]} added to favorites!'),
                                  ),
                                );
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
