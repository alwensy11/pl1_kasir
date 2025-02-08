import 'package:flutter/material.dart'; // Import Flutter's Material design package
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom fonts
import 'package:pl1_kasir/admin/user/edit.dart'; // Import EditUserPage for editing user details
import 'package:pl1_kasir/sign.dart'; // Import MySignUp page for user registration
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase for backend integration

// UserPage widget that displays the list of users
class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key}); // Constructor for UserPage widget

  @override
  State<AdminUserPage> createState() =>
      _AdminUserPageState(); // Create the state for UserPage
}

class _AdminUserPageState extends State<AdminUserPage> {
  List<Map<String, dynamic>> users =
      []; // List to store user data from Supabase

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Call fetchUsers to load user data when the page is initialized
  }

  // Function to fetch users from Supabase
  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client
        .from('user')
        .select(); // Fetch all users from the 'user' table

    setState(() {
      users = List<Map<String, dynamic>>.from(
          response); // Update the users list with the fetched data
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminUserPage()), // Navigate to the welcome screen on logout
    );
  }

  // Function to delete a user based on the user ID
  Future<void> _deleteUser(int id) async {
    try {
      await Supabase.instance.client
          .from('user')
          .delete()
          .eq('user_id', id); // Delete user from Supabase based on user ID
      fetchUsers(); // Refresh the users list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'User tidak ditemukan: $e'))); // Show an error message if the deletion fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent, // Set app bar background color
          foregroundColor: Colors.white, // Set app bar icon and text color
          actions: [
            Padding(
              padding:
                  const EdgeInsets.all(12.0), // Padding around the avatar icon
              child: CircleAvatar(
                backgroundColor: Colors.white, // Circle background color
                foregroundColor: Colors.pinkAccent, // Avatar icon color
                child: Icon(Icons.person), // Person icon inside the avatar
              ),
            )
          ],
        ),
        backgroundColor: Colors.white, // Set background color of the page
        body: users.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator if the users list is empty
            : ListView.builder(
                // Build a list view to display the users
                itemCount: users.length, // Number of users in the list
                itemBuilder: (context, index) {
                  final userr =
                      users[index]; // Get the user data for the current index
                  return Container(
                    margin:
                        EdgeInsets.all(10), // Margin around each user container
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // Set background color of the container
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                      boxShadow: [
                        // Add shadow effect to the container
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(
                              0.5), // Shadow color with transparency
                          blurRadius: 15, // Blur radius of the shadow
                          offset: Offset(5, 5), // Shadow offset
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                          userr['username'] ??
                              'No username', // Display the username
                          style: GoogleFonts.quicksand(
                              // Apply custom font style to the text
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align subtitle to the left
                        children: [
                          Text(
                              userr['role'] ??
                                  'No role', // Display the user role
                              style: GoogleFonts.roboto(
                                  fontSize:
                                      14)), // Apply custom font style to role
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Align buttons at the end of the row
                        children: [
                          // Edit button to edit user details
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue), // Edit icon
                            onPressed: () async {
                              final result = await Navigator.push(
                                // Navigate to the EditUserPage
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminEditUserPage(
                                    username: userr[
                                        'username'], // Pass current username to the edit page
                                    password: userr[
                                        'password'], // Pass current password to the edit page
                                  ),
                                ),
                              );

                              if (result != null) {
                                // If result is not null, update the user in the list
                                setState(() {
                                  users[index] = {
                                    'username': result[
                                        'username'], // Update the username
                                    'password': result[
                                        'password'], // Update the password
                                  };
                                });
                              }
                            },
                          ),
                          // Delete button to delete user
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red), // Delete icon
                            onPressed: () {
                              _deleteUser(userr[
                                  'user_id']); // Call _deleteUser function to delete the user
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(
              16.0), // Padding around the floating action button
          child: ElevatedButton(
            onPressed: () async {
              // Navigate to the MySignUp page and await the result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MySignUp()),
              );

              // If the result is true, refresh the user list
              if (result == true) {
                fetchUsers(); // Refresh users after a new user has been added
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.pinkAccent, // Set background color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    360), // Round the corners of the button
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15), // Padding inside the button
            ),
            child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Align children in a minimal space
                children: [
                  Icon(Icons.add, color: Colors.white)
                ] // Add icon inside the button
                ),
          ),
        ));
  }
}
