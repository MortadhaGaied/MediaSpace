import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../services/backend/auth-service.dart';
import '../../widgets/profile_menu.dart';
import '../intro_screens/onboarding_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> futureUser;
  final AuthenticationService authService = AuthenticationService(); // Define authService here

  @override
  void initState() {
    super.initState();
    futureUser = authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return FutureBuilder<Map<String, dynamic>>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [

                    /// -- IMAGE
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: FutureBuilder<String>(
                            future: authService.getUrlFile(user['profile_picture']),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Image loading error: ${snapshot.error}');
                              } else {
                                return Image.network(snapshot.data!);
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.orangeAccent),
                            child: const Icon(
                              LineAwesomeIcons.alternate_pencil,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("${user['firstname']} ${user['lastname']}", style: Theme.of(context).textTheme.headline4),
                    Text(user['email'], style: Theme.of(context).textTheme.bodyText2),
                    const SizedBox(height: 20),

                    /// -- BUTTON
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {Navigator.pushNamed(context, '/updateProfile');},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent, side: BorderSide.none, shape: const StadiumBorder()),
                        child: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),

                    /// -- MENU
                    ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
                    ProfileMenuWidget(title: "Billing Details", icon: LineAwesomeIcons.wallet, onPress: () {}),
                    ProfileMenuWidget(title: "Votre espace", icon: LineAwesomeIcons.home, onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OnboardingScreen(),
                      ));
                    },),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {}),
                    ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: ()  {
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("LOGOUT"),
                                content: Text("Are you sure, you want to Logout?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () async {
                                      await authService.logout();
                                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
