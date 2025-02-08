import 'package:flutter/material.dart'; // Import Flutter's Material design package
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom fonts// Import MySignUp page for user registration
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase for backend integration

// UserPage widget that displays the list of users
class UserPage extends StatefulWidget {
  const UserPage({super.key}); // Constructor for UserPage widget

  @override
  State<UserPage> createState() =>
      _UserPageState(); // Create the state for UserPage
}

class _UserPageState extends State<UserPage> {
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
              UserPage()), // Navigate to the welcome screen on logout
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
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      // Add shadow effect to the container
                      BoxShadow(
                        color: Colors.pinkAccent
                            .withOpacity(0.5), // Shadow color with transparency
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
                            userr['role'] ?? 'No role', // Display the user role
                            style: GoogleFonts.roboto(
                                fontSize:
                                    14)), // Apply custom font style to role
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
