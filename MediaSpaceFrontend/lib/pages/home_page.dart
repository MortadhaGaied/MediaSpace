import 'package:demo/widgets/customp_appbar.dart';
import 'package:flutter/material.dart';
import 'package:demo/pages/search-pages/search_page.dart';

import '../widgets/custom_bottomNavigationBar.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1:'Media' ,
        title2: 'Space',
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/bghome.jpeg',
              fit: BoxFit.cover,
            ),
            color: Colors.grey.withOpacity(0.7),
          ),

          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              'Organisez des événements de rêve grâce à nous.',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],

                    hintText: 'Enter the place',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    
                    hintText: 'Enter the event type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  child: Text(
                    'Chercher',
                    style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.orange,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(3)
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
