import 'package:demo/pages/auth_pages/login_signup/login_screen.dart';
import 'package:demo/pages/home_page.dart';
import 'package:demo/pages/messaging_pages/chat_page.dart';
import 'package:demo/pages/profile_pages/profile_screen.dart';
import 'package:demo/services/backend/auth-service.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final AuthenticationService _authenticationService=AuthenticationService();
  Future<void> navigate(BuildContext context, Widget destination) async {
    bool loggedIn = await _authenticationService.isLoggedIn();
    if (loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(destination: destination,)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  icon: Icon(Icons.search),
                  color: Colors.white,
                ),
                Text('Explore', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    navigate(context, ChatPage());
                  },
                  icon: Icon(Icons.favorite),
                  color: Colors.white,
                ),
                Text('Whitelist', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.video_library),
                  color: Colors.white,
                ),
                Text('Videos', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    navigate(context, ChatPage());
                  },
                  icon: Icon(Icons.message),
                  color: Colors.white,
                ),
                Text('Messages', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    navigate(context, ProfileScreen());
                  },
                  icon: Icon(Icons.person),
                  color: Colors.white,
                ),
                Text('Profile', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
