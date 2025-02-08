import 'package:flutter/material.dart';  // Importing the Flutter Material Design library for UI components
import 'package:google_fonts/google_fonts.dart';  // Importing Google Fonts to use custom fonts
import 'package:pl1_kasir/admin/produk/produk.dart';  // Import the ProdukPage widget
import 'package:pl1_kasir/admin/pelanggan/pelanggan.dart';  // Import the PelangganPage widget
import 'package:pl1_kasir/admin/penjualan/penjualan.dart';  // Import the PenjualanPage widget
import 'package:pl1_kasir/admin/penjualan/detailpenjualan.dart';  // Import the DetailPenjualanPage widget // Import the UserPage widget
import 'package:pl1_kasir/admin/user/user.dart';
import 'package:pl1_kasir/sign.dart';  // Import the MySignUp widget for registration
import 'package:pl1_kasir/welcome.dart';  // Import the MyWelcomeScreen widget for the welcome page

// Define the StatefulWidget for the HomePage
class AdminMyHomePage extends StatefulWidget {
  @override
  _AdminMyHomePageState createState() => _AdminMyHomePageState();  // Create the state for the home page
}

class _AdminMyHomePageState extends State<AdminMyHomePage> {
  int _selectedIndex = 1; // Default index for the selected tab, starting at the Pelanggan tab (index 1)

  // Function to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected index when a tab is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Set the background color of the scaffold to white
      drawer: Drawer(
          backgroundColor: Colors.pinkAccent,  // Set the background color of the drawer to pink accent
          child: ListView(
            children: [
              DrawerHeader(
                  child:
                      Text('Wizz Me', style: TextStyle(color: Colors.white))  // Header of the drawer with white text
              ),
              // ListTile for the "Register" option
              ListTile(
                title: Text(
                  'Register',
                  style: GoogleFonts.quicksand(color: Colors.white),  // Apply custom font to the text
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySignUp()),  // Navigate to the MySignUp page
                  );
                },
              ),
              // ListTile for the "User" option
              ListTile(
                title: Text(
                  'User',
                  style: GoogleFonts.quicksand(color: Colors.white),  // Apply custom font to the text
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminUserPage()),  // Navigate to the UserPage
                  );
                },
              ),
              // ListTile for the "Logout" option
              ListTile(
                title: Text(
                  'Logout',
                  style: GoogleFonts.quicksand(color: Colors.white),  // Apply custom font to the text
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyWelcomeScreen()),  // Navigate to the welcome screen on logout
                  );
                },
              )
            ],
          )),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,  // Set the app bar background color to pink accent
        foregroundColor: Colors.white,  // Set the app bar icon and text color to white
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),  // Add padding around the avatar
            child: CircleAvatar(
              backgroundColor: Colors.white,  // Set the avatar background color to white
              foregroundColor: Colors.pinkAccent,  // Set the avatar icon color to pink accent
              child: Icon(Icons.person),  // Display a person icon inside the avatar
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,  // Set the initial index to the selected tab
        children: const [
          AdminProdukPage(),  // First tab (Produk)
          AdminPelangganPage(),  // Second tab (Pelanggan)
          AdminPenjualanPage(),  // Third tab (Penjualan)
          AdminDetailPenjualanPage(),  // Fourth tab (Detail Penjualan)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),  // Icon for the Produk tab
            label: 'Produk',  // Label for the Produk tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),  // Icon for the Pelanggan tab
            label: 'Pelanggan',  // Label for the Pelanggan tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),  // Icon for the Penjualan tab
            label: 'Penjualan',  // Label for the Penjualan tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),  // Icon for the Detail Penjualan tab
            label: 'Detail Penjualan',  // Label for the Detail Penjualan tab
          ),
        ],
        currentIndex: _selectedIndex,  // Set the current selected index based on _selectedIndex
        selectedItemColor: Colors.pinkAccent,  // Set the color for the selected tab icon
        unselectedItemColor: Colors.grey,  // Set the color for unselected tab icons
        onTap: _onItemTapped,  // Call the _onItemTapped function when a tab is tapped
      ),
    );
  }
}
