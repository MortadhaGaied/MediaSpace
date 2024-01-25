import 'package:MediaSpaceFrontend/widgets/customp_appbar.dart';
import 'package:MediaSpaceFrontend/widgets/custom_bottomNavigationBar.dart';
import 'package:MediaSpaceFrontend/widgets/top_spaces.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/backend/space-service.dart';
import '../../widgets/space-card.dart';
import 'filter-page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> spaceList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SpaceService spaceService = SpaceService();
    http.Response response = await spaceService.retrieveAllSpaces();
    if (response.statusCode == 200) {
      print('Retrieved all spaces successfully');
      setState(() {
        spaceList = json.decode(response.body);
        print(spaceList[3]);
      });
    } else {
      print('Failed to retrieve spaces: ${response.statusCode}');
    }
  }
  int _selectedindex=0;
  List<IconData> icons=[
    FontAwesomeIcons.desktop,
    FontAwesomeIcons.home,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.road

  ];
  Widget _buildIcon(int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedindex=index;
        });
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(color: _selectedindex==index?Colors.grey[350]:Color(0xFFEEBEE),
        borderRadius: BorderRadius.circular(30.0)
        ),
        child: Icon(icons[index],size: 25.0,color:  Colors.black,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


    appBar: CustomAppBar(
        title1:'Media' ,
        title2: 'Space',
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the place',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterPage()),
                    );
                  },
                  icon: Icon(Icons.filter_list),
                ),

              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:icons
                  .asMap()
                  .entries
                  .map(
                    (MapEntry map)=>_buildIcon(map.key),
                  ).toList(),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items in a row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.6, // Adjust this for your design
                ),
                itemCount: spaceList.length,
                itemBuilder: (context, index) {
                  return SpaceCard(space: spaceList[index]);
                },
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
