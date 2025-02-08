import 'package:flutter/material.dart';  // Import the Material design package from Flutter
import 'package:google_fonts/google_fonts.dart';  // Import Google Fonts package for custom fonts
import 'package:pl1_kasir/login.dart';  // Import the login page that the user will navigate to

// This is the Welcome Screen that shows when the app is launched
class MyWelcomeScreen extends StatelessWidget {
  const MyWelcomeScreen({super.key});  // Constructor for MyWelcomeScreen widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Set the background color of the screen to white
      body: Center(  // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,  // Distribute children evenly across the screen
          children: [
            // Display the app's logo image
            ClipRRect(
              child: Image.asset(
                'assets/logo.jpg',  // Path to the logo image asset
                width: 250.0,  // Set the width of the logo image
                height: 250.0,  // Set the height of the logo image
              ),
            ),
            // Row for placing the login button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,  // Center the login button horizontally
              children: [
                SizedBox(width: 10.0),  // Add some space between the elements
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 40),  // Set a fixed size for the login button
                    backgroundColor: Colors.pinkAccent,  // Set the button's background color
                  ),
                  onPressed: () {
                    // When the button is pressed, navigate to the login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()),  // Push the login page to the stack
                    );
                  },
                  child: Text('LOGIN',  // The text displayed on the login button
                      style: GoogleFonts.quicksand(  // Apply the custom Google font for the button text
                          fontSize: 15.0,  // Set the font size of the text
                          fontWeight: FontWeight.bold,  // Set the text to bold
                          color: Colors.white)),  // Set the text color to white
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
