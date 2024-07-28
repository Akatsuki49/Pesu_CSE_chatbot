import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/missing_info_screen.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final profileImageUrl = authService.getProfileImageUrl();
    final userName = authService.getUserName();
    final userEmail = authService.getUserEmail();

    return SizedBox(
      width: 220,
      child: Drawer(
        backgroundColor:
            Color.fromARGB(255, 18, 18, 18), // Entire drawer background color
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Color.fromARGB(255, 18, 18, 18),
              child: Row(
                children: [
                  // Sahai logo at the top left
                  Image.asset(
                    'assets/images/sah.ai_white.png',
                    height: 70, // Adjust size as needed
                    width: 70,
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildListTile(
                    context,
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isSelected: true, // Highlight 'Home' as selected
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isSelected: false,
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.help,
                    title: 'Help',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isSelected: false,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width *
                        0.97, // Adjust 0.1 to the desired fraction
                  ),
// Space above the custom widget
                  _buildCustomTile(
                    context,
                    title: 'Report Missing Information',
                    onTap: () {
                      // Handle the tap event here
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Color.fromARGB(255, 18, 18, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (profileImageUrl != null)
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(profileImageUrl),
                    )
                  else
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      child: Icon(
                        Icons.account_circle,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'User',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail ?? 'No email',
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 0.0, horizontal: 8.0), // Adjust vertical margin
      decoration: BoxDecoration(
        color: isSelected
            ? Color.fromARGB(255, 32, 32, 32)
            : const Color.fromARGB(
                0, 168, 77, 77), // Background color for the tile
        borderRadius: BorderRadius.circular(25.0), // Rounded corners
      ),
      child: SizedBox(
        height: 50, // Fixed height for the tile
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 0.0, horizontal: 16.0), // Reduced internal padding
          leading: Icon(
            icon,
            color: Colors.white, // White icon color
          ),
          title: Text(
            title,
            style: GoogleFonts.lato(
              color: Colors.white, // White text color
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildCustomTile(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      height: MediaQuery.of(context).size.width *
          0.25, // Relative height for the custom tile
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 210, 43, 43)
            ?.withOpacity(0.5), // Translucent background color
        borderRadius: BorderRadius.circular(25.0), // Rounded corners
      ),
      child: Stack(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MissingInfoScreen()),
                );
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    color: Colors.white, // White text color
                    fontSize: 20, // Slightly bigger text size
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width *
                0.05, // Relative bottom positioning
            right: MediaQuery.of(context).size.width *
                0.05, // Relative right positioning
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06, // Relative size
            ),
          ),
        ],
      ),
    );
  }
}
