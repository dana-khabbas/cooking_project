import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rat3/Homesecond.dart';

class Publish extends StatefulWidget {
  const Publish({super.key});

  @override
  State<Publish> createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> _ingredientsList = [];
  final TextEditingController _IngredientController = TextEditingController();
  final TextEditingController  _stepsController = TextEditingController();
  final TextEditingController  _titleController = TextEditingController();
  final TextEditingController  _photoController = TextEditingController();

  String? selectedTime;// Variable to store the selected cooking time
 String? selectedLevel;
  final List<String> cookingTimes = [
    "5 min",
    "15 min",
    "30 min",
    "1 hour",
    "1:15 min",
    "1:30 min",
    "2 hours",
    "More than 2 hours",
  ];
final List<String> difficultyLevel = [
    "easy",
    "meduim",
    "hard",
    
  ];
      CollectionReference dishes = FirebaseFirestore.instance.collection('dishes');

 Future<void> addDish(BuildContext context) {
      // Call the user's CollectionReference to add a new dish
      return dishes
          .add({
            'name': _titleController.text, 
            'image': _photoController.text, 
            'ingredients': _ingredientsList,
            'steps':_stepsController.text,
            'time':selectedTime,
            'level':selectedLevel,

             
          })
          .then((value) { 
            // print("dish Added");
           // Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>   Homesecond())), );
          })
          .catchError((error) => print("Failed to add dish: $error"));
    }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new dish"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack with responsive height
              Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.25, // 25% of screen height
                    child: Image.network(
                      "https://i.pinimg.com/736x/48/d1/bd/48d1bd1d41b43de3effa2dbf82ae0327.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.04, // Responsive position
                    left: screenWidth * 0.3,
                    child: Text(
                      "\t \t Inspire us \n with your dish!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.069, // Responsive font size
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
              ),Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: screenHeight * 0.02), 
              Text(
                  "Title",
                  style: TextStyle(fontSize: screenWidth * 0.08), // 8% of screen width
                ),
              
               TextFormField(
                controller: _titleController,
                   decoration: InputDecoration(
                  hintText: "Name of the dish",
                  filled: true, // Fills the background color
                  fillColor: Colors.grey[200], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide.none, // Removes default border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, 
                      horizontal: screenWidth * 0.05,
                    ),
                ),

                  validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the Dish Name';
                      }
                      return null;
  },
                ),
                SizedBox(height: screenHeight * 0.02), 
              Text(
                  "Photo URL",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ),
              
               TextFormField(
                controller: _photoController,
                  decoration: InputDecoration(
                  hintText: "URL(Link) of the dish photo",
                  filled: true, // Fills the background color
                  fillColor: Colors.grey[200], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide.none, // Removes default border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, 
                      horizontal: screenWidth * 0.05,
                    ),
                ),
                  validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the Dish Photo';
                      }
                      return null;}
                ),  
                 SizedBox(height: screenHeight * 0.02), 
              Text(
                  "Ingredients",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ),
                SizedBox(height: screenHeight * 0.01), 
                  TextFormField(
              controller: _IngredientController,
             
              decoration: InputDecoration(
                  hintText: "Add an ingredient",
                  filled: true, // Fills the background color
                  fillColor: Colors.grey[200], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide.none, // Removes default border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, 
                      horizontal: screenWidth * 0.05,
                    ),
                  suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    _addIngredient();
                  },
                ),
                ),
           validator: (value) {
  if (_ingredientsList == null || _ingredientsList.isEmpty) {
    return 'Please add at least one ingredient.';
  }
  return null;
},
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height:  screenHeight * 0.15,
              child:  ListView.builder(
                itemCount: _ingredientsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_ingredientsList[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeIngredient(index),
                    ),
                  );
                },
              ),
            ),
             Text(
                  "Steps",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ),
                SizedBox(height: screenHeight * 0.02),

            TextFormField(
              controller: _stepsController,
                maxLines: 5, // Allows the field to be multiline
                decoration: InputDecoration(
                  hintText: "Recipe steps",
                  filled: true, // Fills the background color
                  fillColor: Colors.grey[200], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide.none, // Removes default border
                  ),
                  contentPadding: EdgeInsets.all(16), // Padding inside the field
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the recipe steps';
                  }
                  return null;
                },
                
              ),
             /* SizedBox(height: screenHeight * 0.02),
              Text(
                  "Video URL",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ), 
              TextFormField(
                
                  decoration: InputDecoration(
                  hintText: "Dish recipe video link (optional)",
                  filled: true, // Fills the background color
                  fillColor: Colors.grey[200], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide.none, // Removes default border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, 
                      horizontal: screenWidth * 0.05,
                    ),
                ),
                  
                ),*/
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Cooking Time",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ), 

                 DropdownButtonFormField<String>(
  value: selectedTime,
  decoration: InputDecoration(
    labelText: "Select Cooking time",
    border: OutlineInputBorder(), // Optional: For better UI
  ),
  items: cookingTimes.map((String time) {
    return DropdownMenuItem<String>(
      value: time,
      child: Text(time),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      selectedTime= newValue!;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select a cooking time';
    }
    return null;
  },
),
            SizedBox(height: screenHeight * 0.03),
                Text(
                  "Difficulty level",
                  style: TextStyle(fontSize: screenWidth * 0.075), // 8% of screen width
                ), 


            DropdownButtonFormField<String>(
  value: selectedLevel,
  decoration: InputDecoration(
    labelText: "Select difficulty level",
    border: OutlineInputBorder(), // Optional: For better UI
  ),
  items: difficultyLevel.map((String level) {
    return DropdownMenuItem<String>(
      value: level,
      child: Text(level),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      selectedLevel = newValue!;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select a difficulty level';
    }
    return null;
  },
),
                    
            
               Container(
                width: double.infinity,
                child:  ElevatedButton(onPressed: (){
                   if (formKey.currentState!.validate()) {
      // If all fields are valid, add the dish
      addDish(context);
       // If validations fail, show a popup message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Your Dish has been succesfuly added', 
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green, // Red background for error
      duration: Duration(seconds: 3), // Show for 3 seconds
    ),
  );
    } else {
       // If validations fail, show a popup message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Please correct the errors before publishing', // The error message function
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red, // Red background for error
      duration: Duration(seconds: 3), // Show for 3 seconds
    ),
  );
    }
                 }, child:  
                Text("Publish",style: TextStyle(
                  fontSize: screenWidth * 0.075,
                  //  fontWeight: FontWeight.bold,
                ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 46, 54, 63),
              //  padding:EdgeInsets.symmetric( /*vertical: screenHeight * 0.015,  horizontal: screenWidth * 0.05,)*/,
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20),)),
                ),
               ),
               SizedBox(height: screenHeight * 0.03),


            
                          

                ],),
              )
              
              
            ],
          ),
        ),
      ),
    );
    
  }
  void _addIngredient() {
    final ingredient = _IngredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        _ingredientsList.add(ingredient);
        _IngredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientsList.removeAt(index);
    });
  }
}
