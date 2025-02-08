import 'package:flutter/material.dart'; // Import the Material Design package for UI components
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom fonts
import 'package:pl1_kasir/admin/home.dart'; // Import the home page to navigate after successful login
import 'package:pl1_kasir/petugas/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase for database interaction

void main() {
  runApp(MyLoginPage()); // Run the app with the MyLoginPage widget
}

class MyLoginPage extends StatelessWidget {
  MyLoginPage({super.key}); // Constructor for MyLoginPage widget

  final TextEditingController _usernameController =
      TextEditingController(); // Controller for the username input
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for the password input

  @override
  Widget build(BuildContext context) {
    // Function to handle the login process
    // Function to handle the login process
    Login() async {
      try {
        // Query Supabase to check if the username and password match any entry in the database
        var result = await Supabase.instance.client
            .from('user') // Query the 'user' table in Supabase
            .select() // Select all columns
            .eq('username',
                _usernameController.text) // Check if username matches
            .eq('password',
                _passwordController.text) // Check if password matches
            .single(); // Only expect one result

        if (result != null) {
          // Retrieve the role of the user
          String role = result[
              'role']; // Assuming 'role' column exists in the 'user' table

          // Navigate based on the role
          if (role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdminMyHomePage(), // Navigate to Admin's home page
              ),
            );
          } else if (role == 'petugas') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(), // Navigate to Petugas's home page
              ),
            );
          }
        } else {
          // If result is null (no matching user), show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Username atau password salah'),
              backgroundColor: Colors.pinkAccent,
            ),
          );
        }
      } catch (error) {
        // If an error occurs, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan, silakan coba lagi.'),
            backgroundColor: Colors.pinkAccent,
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.white, // Set background color of the app bar to white
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                  context); // When back button is pressed, pop the current screen
            },
            icon: Icon(
              Icons.arrow_back_ios_new, // Icon for the back button
              color: Colors.white, // Set the color of the back button icon
              size: 20, // Set the size of the back button icon
            ),
            style: IconButton.styleFrom(
              fixedSize: Size(3, 3), // Set size for the back button
              backgroundColor: Colors
                  .pinkAccent, // Set the background color of the back button
            ),
          ),
        ),
        body: Container(
          color: Colors.white, // Set the background color of the body to white
          padding:
              EdgeInsets.all(10.0), // Set padding inside the body container
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround, // Spread out the children horizontally
                children: [
                  Text('LOGIN', // Display 'LOGIN' text
                      style: GoogleFonts.quicksand(
                          // Apply custom Google font for the text
                          fontSize: 20.0, // Set the font size
                          fontWeight: FontWeight.bold, // Set the text to bold
                          color: Colors
                              .pinkAccent)), // Set the text color to pink accent
                ],
              ),
              SizedBox(
                  height:
                      50.0), // Add space between the title and the username field
              TextFormField(
                controller:
                    _usernameController, // Bind the controller to the username text field
                decoration: InputDecoration(
                  labelText: 'Username', // Label text for the username field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          25.0)), // Set rounded borders for the input field
                  suffixIcon: Icon(Icons
                      .person), // Display a person icon inside the text field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Username';
                  }
                  return null;
                },
              ),
              SizedBox(
                  height:
                      30.0), // Add space between the username field and the password field
              TextFormField(
                controller:
                    _passwordController, // Bind the controller to the password text field
                obscureText: true, // Hide the text input (password input)
                decoration: InputDecoration(
                  labelText: 'Password', // Label text for the password field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          25.0)), // Set rounded borders for the input field
                  suffixIcon: Icon(
                      Icons.lock), // Display a lock icon inside the text field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0), // Add some space below the password field
              SizedBox(
                  height: 50.0), // Add additional space before the login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(400, 45), // Set the size of the login button
                  backgroundColor: Colors
                      .pinkAccent, // Set the background color of the login button
                ),
                onPressed: () {
                  Login(); // Call the Login function when the button is pressed
                },
                child: Text('LOGIN', // Text displayed on the login button
                    style: GoogleFonts.quicksand(
                      // Apply custom Google font for the button text
                      fontSize: 15.0, // Set the font size of the button text
                      fontWeight:
                          FontWeight.bold, // Set the button text to bold
                      color: Colors.white, // Set the button text color to white
                    )),
              ),
            ],
          ),
        ));
  }
}
