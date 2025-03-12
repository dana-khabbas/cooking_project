import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_rat3/Details.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QueryDocumentSnapshot> favoriteDishes = [];

  // Fetch favorite dishes from Firestore
  Future<void> getFavorites() async {
    try {
      final String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Fetch user's favorite dishes from Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('favorites')
          .get();

      setState(() {
        favoriteDishes = querySnapshot.docs;
      });
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 46, 54, 63),
      ),
      body: favoriteDishes.isEmpty
          ? Center(child: Text("No favorites yet"))
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteDishes.length,
              itemBuilder: (context, index) {
                final dish = favoriteDishes[index];

                // Check if the required fields exist in the document
              /* if (!dish.exists || !dish.data()?.containsKey('name')) {
                  return Center(child: Text("Dish data not available"));
                }*/

                final dishName = dish["name"];
                final dishImage = dish["image"];
                final dishLevel = dish["level"];
                final dishTime = dish["time"];
                final dishIngredients = dish["ingredients"]+ "\n";
                final dishSteps = dish["steps"];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                          dishName: dishName,
                          image: dishImage,
                          ingredients: dishIngredients,
                          steps: dishSteps,
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
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            dishImage,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Dish Name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dishName,
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
                            "$dishLevel | $dishTime",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
