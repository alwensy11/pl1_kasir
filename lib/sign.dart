import 'package:flutter/material.dart'; // Import Flutter's Material design package
import 'package:pl1_kasir/admin/home.dart'; // Import the home page to navigate to after successful registration
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom fonts
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase to interact with the backend

// The MySignUp widget allows users to register
class MySignUp extends StatelessWidget {
  const MySignUp({super.key}); // Constructor for MySignUp widget

  @override
  Widget build(BuildContext context) {
    // Define text controllers for the username and password fields
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final supabase =
        Supabase.instance.client; // Get the Supabase client instance

    // Function to handle user registration
    void registerUser() async {
      String username =
          usernameController.text.trim(); // Get and trim the username input
      String password =
          passwordController.text.trim(); // Get and trim the password input

      // Check if both fields are not empty
      if (username.isNotEmpty && password.isNotEmpty) {
        final response = await supabase.from('user').insert({
          'username': username, // Insert the username
          'password':
              password, // Insert the password (Note: In a real app, the password should be hashed)
          'role': 'petugas', // Assign the role 'petugas'
        });

        // If registration is successful (no error in response)
        if (response == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminMyHomePage()), // Navigate to the home page
          );
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.white, // Set the app bar background color to white
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                  context); // Go back to the previous screen when back button is pressed
            },
            icon: Icon(
              Icons.arrow_back_ios_new, // Set the icon to an arrow
              color: Colors.white, // Set the icon color to white
              size: 20, // Set the icon size
            ),
            style: IconButton.styleFrom(
              fixedSize: Size(3, 3), // Set fixed size for the back button
              backgroundColor: Colors
                  .pinkAccent, // Set the background color of the back button
            ),
          ),
        ),
        body: Container(
          color: Colors.white, // Set the body background color to white
          padding: EdgeInsets.all(10.0), // Add padding inside the container
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            children: [
              // Title text for the registration screen
              Text('REGISTER',
                  style: GoogleFonts.quicksand(
                      // Apply custom Google font style
                      fontSize: 20.0, // Set font size
                      fontWeight: FontWeight.bold, // Set font weight to bold
                      color:
                          Colors.pinkAccent)), // Set font color to pinkAccent
              SizedBox(height: 50.0), // Add space between text and input fields

              // Text field for entering username
              TextFormField(
                  controller:
                      usernameController, // Attach the username controller
                  decoration: InputDecoration(
                    labelText: 'Username', // Label for the username field
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            25.0)), // Rounded corners for the input field
                    suffixIcon: Icon(Icons
                        .person), // Add a person icon as a suffix to the input field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Username';
                    }
                  }),
              SizedBox(
                  height:
                      30.0), // Add space between username and password fields

              // Text field for entering password (with obscure text)
              TextFormField(
                controller:
                    passwordController, // Attach the password controller
                obscureText:
                    true, // Set obscureText to true to hide the password input
                decoration: InputDecoration(
                  labelText: 'Password', // Label for the password field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          25.0)), // Rounded corners for the input field
                  suffixIcon: Icon(Icons
                      .lock), // Add a lock icon as a suffix to the password field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50.0), // Add space before the register button

              // Register button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(400, 45), // Set a fixed size for the button
                  backgroundColor: Colors
                      .pinkAccent, // Set the background color to pinkAccent
                ),
                onPressed:
                    registerUser, // Call the registerUser function when the button is pressed
                child: Text('REGISTER',
                    style: GoogleFonts.quicksand(
                      // Apply custom Google font style to the button text
                      fontSize: 15.0, // Set the font size
                      fontWeight:
                          FontWeight.bold, // Set the font weight to bold
                      color: Colors.white, // Set the font color to white
                    )),
              ),
            ],
          ),
        ));
  }
}
