import 'package:flutter/material.dart';  // Import Flutter's Material design package
import 'package:supabase_flutter/supabase_flutter.dart';  // Import Supabase for backend integration

// Create the EditUserPage widget, which takes username and password as input
class AdminEditUserPage extends StatefulWidget {
  final String username;  // Username parameter
  final String password;  // Password parameter

  const AdminEditUserPage({
    Key? key,
    required this.username,  // Constructor to initialize username
    required this.password,  // Constructor to initialize password
  }) : super(key: key);

  @override
  _AdminEditUserPageState createState() => _AdminEditUserPageState();  // Create state for EditUserPage
}

// Create the state class for the EditUserPage widget
class _AdminEditUserPageState extends State<AdminEditUserPage> {
  final _formKey = GlobalKey<FormState>();  // Global key to manage the form state

  late TextEditingController _usernameController;  // Controller for the username input
  late TextEditingController _passwordController;  // Controller for the password input

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);  // Initialize username controller
    _passwordController = TextEditingController(text: widget.password);  // Initialize password controller
  }

  @override
  void dispose() {
    _usernameController.dispose();  // Dispose username controller when the widget is destroyed
    _passwordController.dispose();  // Dispose password controller when the widget is destroyed
    super.dispose();
  }

  // Function to update the user information in the Supabase database
  Future<void> _updateUser() async {
    // Send an update request to Supabase to update user details based on the username
    final response = await Supabase.instance.client
        .from('user')  // Reference to the 'user' table
        .update({
          'username': _usernameController.text,  // Update the username field
          'password': _passwordController.text,  // Update the password field
        })
        .eq('username', widget.username)  // Filter by the existing username
        .select();  // Perform the query

    if (response.error == null) {
      print('User berhasil diperbarui');  // Success message
    } else {
      print('Gagal memperbarui user: ${response.error!.message}');  // Error message if update fails
    }
  }

  // Function to save the updated user data
  void _saveUser() async {
    if (_formKey.currentState!.validate()) {  // Check if form validation passes
      await _updateUser();  // Call the update function to update user data in Supabase

      // Return to the previous screen with the updated data
      Navigator.pop(context, {
        'username': _usernameController.text,  // Pass the updated username back
        'password': _passwordController.text,  // Pass the updated password back
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),  // App bar with the title 'Edit User'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding around the body content
        child: Form(
          key: _formKey,  // Assign the form key to the form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,  // Stretch widgets across the main axis
            children: [
              // Username input field with validation
              TextFormField(
                controller: _usernameController,  // Bind the username controller to this field
                decoration: const InputDecoration(labelText: 'Username'),  // Label for the field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';  // Validation error if username is empty
                  }
                  return null;  // Return null if the validation is successful
                },
              ),
              const SizedBox(height: 16.0),  // Space between input fields
              
              // Password input field with validation
              TextFormField(
                controller: _passwordController,  // Bind the password controller to this field
                decoration: const InputDecoration(labelText: 'Password'),  // Label for the field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';  // Validation error if password is empty
                  }
                  return null;  // Return null if the validation is successful
                },
              ),
              const SizedBox(height: 24.0),  // Space before the save button
              
              // Save button that triggers the saveUser function when pressed
              ElevatedButton(
                onPressed: _saveUser,  // Call _saveUser function on press
                child: const Text('Simpan'),  // Button text 'Simpan' (Save)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to add a getter for error handling (though unused in your code)
extension on PostgrestList {
  get error => null;  // Dummy getter to avoid error, as it isn't used elsewhere
}
