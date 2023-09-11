import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../services/backend/auth-service.dart';
class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}
class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late Future<Map<String, dynamic>> futureUser;
  final AuthenticationService authService = AuthenticationService();  // Assuming you have AuthenticationService

  // Form fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    futureUser = authService.getCurrentUser();

    // Initialize controllers with empty string, will update once we get user details
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _phoneNumberController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: futureUser,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('User not found.'));
      } else {
        Map<String, dynamic> user = snapshot.data!;
        _nameController.text = "${user['firstname']} ${user['lastname']}";
        _emailController.text = user['email'];
        _phoneNumberController.text = user['phone_number'].toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Edit Profile", style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              // -- IMAGE with ICON
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
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.amber),
                      child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          label: Text("Full Name"),
                          prefixIcon: Icon(LineAwesomeIcons.user)
                      ),
                    ),
                    const SizedBox(height: 40 - 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          label: Text("Email"),
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1)
                      ),
                    ),
                    const SizedBox(height: 40 - 20),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                          label: Text("Phone Number"),
                          prefixIcon: Icon(LineAwesomeIcons.phone)
                      ),
                    ),
                    const SizedBox(height: 40 - 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon:
                        IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "Joined",
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "tJoinedAt",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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