
import 'package:flutter/material.dart';



class RecipeDetailPage extends StatelessWidget {
  final String dishName;
  final String image;
  final String ingredients;
  final String steps;

  RecipeDetailPage({
    required this.dishName,
    required this.image,
    required this.ingredients,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dishName),
        backgroundColor: Color.fromARGB(255, 46, 54, 63),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                "Ingredients:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(ingredients),
              SizedBox(height: 16),
              Text(
                "Steps:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(steps),
            ],
          ),
        ),
      ),
    );
  }
}