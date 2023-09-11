import 'package:demo/widgets/page3step3.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../services/models/Address.dart';
import '../../services/models/SpaceType.dart';
import '../../services/models/space.dart';
import '../../services/models/spaceavailability.dart';
import '../../widgets/page2_step3.dart';
import '../../widgets/select_space_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiStepForm(),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  String? selectedSpaceType;
  String? ownerType;
  int currentStep = 0;
  int currentPage = 0;
  double? spaceArea;
  List<String> accessibilityOptions = [];
  List<String> selectedEquipments = [];
  bool isOtherChecked = false;
  String? otherAccessibilityOption;
  String? spaceTitle;
  String? spaceDescription;
  int? ageRestriction;
  List<SpaceAvailability> spaceAvailabilityList = [];
  Space space = Space(
    address: Address(),
    amenities: [],
    equipments: [],
    accessibility: [],
    availabilities: [],
  );

  Widget getFirstPageContent(int step) {
    String title = "";
    String subTitle = "";
    String description = "";

    switch (step) {
      case 0:
        title = "Etape 1 : Les bases";
        subTitle = "Partager des informations sur ton endroit";
        description =
        "Dans cette etape on vous demande de nous dire de quelle type votre espace est et si tous l’espace peut etre louer ou pas ensuite dit nous la localisation de votre endroit et combien des utilisateurs peut contenire";
        break;
      case 1:
        title = "Etape 2 : Les atouts de votre espace";
        subTitle = "Donnez aux locataires un avant-goût";
        description =
        "Donnez vie à votre espace en ajoutant des photos professionnelles, une description engageante et des équipements de qualité pour attirer les locataires.";
        break;
      case 2:
        title = "Etape 3 : Disponibilité et tarification";
        subTitle = "Donnez aux locataires un avant-goût";
        description =
        "Assurez-vous que votre espace est disponible pour les locataires en configurant facilement les heures, les jours et les semaines de disponibilité. Définissez également les prix de location par heure pour maximiser vos revenus. N'oubliez pas de préciser les options de sécurité disponibles, comme le parking et les caméras de surveillance.";
        break;
    }

    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/form.PNG'), // Replace with your image URL or asset
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            subTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );

  }


  Widget getSecondPageContent() {


    List<Map<String, String>> spaceTypes = [
      {'type': 'Maison', 'icon': 'assets/images/facebook.png','spaceType':'HOUSE'},
      {'type': 'Appartement', 'icon': 'assets/images/facebook.png','spaceType':'APARTMENT'},
      {'type': 'Bureau', 'icon': 'assets/images/facebook.png','spaceType':'OFFICE'},
      {'type': 'Studio', 'icon': 'assets/images/facebook.png','spaceType':'STUDIO'},
      {'type': 'Restaurant', 'icon': 'assets/images/facebook.png','spaceType':'BARRESTO'},
      {'type': 'Salle des fetes', 'icon': 'assets/images/facebook.png','spaceType':'HOUSE'},
      {'type': 'Theatre', 'icon': 'assets/images/facebook.png','spaceType':'HOUSE'},
      {'type': 'Bateau', 'icon': 'assets/images/facebook.png','spaceType':'BOAT'},
      {'type': 'Hotel', 'icon': 'assets/images/facebook.png','spaceType':'HOTEL'},
      {'type': 'Galerie', 'icon': 'assets/images/facebook.png','spaceType':'GALLERY'},
    ];

    return Column(
      children: [
        Text(
          "De quelle type est votre espace?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
            ),
            itemCount: spaceTypes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    space.spaceType = SpaceType.values.firstWhere((e) => e.toString() == 'Fruit.' + spaceTypes[index]['spaceType']!);
                  });
                  print(selectedSpaceType);
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(

                    color: selectedSpaceType == spaceTypes[index]['type']
                        ? Colors.blue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        spaceTypes[index]['icon']!,
                        height: 50,
                        width: 50,
                      ),
                      Text(
                        spaceTypes[index]['type']!,
                        style: TextStyle(
                          color: selectedSpaceType == spaceTypes[index]['type']
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget getThirdPageContent() {
    List<Map<String, String>> ownerTypes = [
      {'type': 'Individual', 'icon': 'assets/images/facebook.png'},
      {'type': 'Company', 'icon': 'assets/images/facebook.png'},
      {'type': 'Organization', 'icon': 'assets/images/facebook.png'},
    ];

    return Column(
      children: [
        Text(
          "What type of owner are you?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: ownerTypes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    ownerType = ownerTypes[index]['type'];
                  });
                  print(ownerType);
                },
                child: Container(
                  height: 100,
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ownerType == ownerTypes[index]['type']
                        ? Colors.blue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        ownerTypes[index]['icon']!,
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        ownerTypes[index]['type']!,
                        style: TextStyle(
                          color: ownerType == ownerTypes[index]['type']
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget getFourthPageContent() {
    TextEditingController countryController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController postalCodeController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0), // Add space around the edge
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Où est situé votre place?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: countryController,
            decoration: InputDecoration(
              labelText: 'Pays',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Adresse',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: stateController,
            decoration: InputDecoration(
              labelText: 'Etat/Region',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: 'Ville',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: postalCodeController,
            decoration: InputDecoration(
              labelText: 'Code postal',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
  Widget getFifthPageContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            "Détails de l’espace et accessibilité",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildCounterRow("Nombre de chambres", space.roomNumber ?? 0, () {
            setState(() {
              space.roomNumber = (space.roomNumber ?? 0) + 1;
            });

          }, () {
            setState(() {
              if (space.roomNumber! > 0) space.roomNumber = (space.roomNumber ?? 0) - 1;
            });
          }),
          buildCounterRow("Nombre des toilettes", space.bathroomNumber?? 0, () {
            setState(() {
              space.bathroomNumber = (space.bathroomNumber ?? 0) + 1;
            });
          }, () {
            setState(() {
              if (space.bathroomNumber! > 0) space.bathroomNumber = (space.bathroomNumber ?? 0) - 1;
            });
          }),
          buildCounterRow("Nombre d’étages", space.floorNumber?? 0, () {
            setState(() {
              space.floorNumber = (space.floorNumber ?? 0) + 1;
            });
          }, () {
            setState(() {
              if (space.floorNumber! > 0) space.floorNumber = (space.floorNumber ?? 0) - 1;
            });
          }),
          SizedBox(height: 20),
          Text("Quelle est la superficie estimée de l’espace disponible pour un événement?"),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              spaceArea = double.tryParse(value);
            },
            decoration: InputDecoration(
              suffixText: 'm²',
            ),
          ),
          SizedBox(height: 20),
          Text("Comment les invités peuvent-ils accéder à votre espace ?"),
          buildCheckBoxRow("Ascenseur", "Escalier"),
          buildCheckBoxRow("Rampe", "Escalier mécanique"),
          CheckboxListTile(
            title: Text("Autre"),
            value: isOtherChecked,
            onChanged: (bool? value) {
              setState(() {
                isOtherChecked = value!;
              });
            },
            activeColor: Colors.blue,
          ),
          if (isOtherChecked)
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Autre',
              ),
              onChanged: (value) {
                otherAccessibilityOption = value;
              },
            ),
        ],
      ),
    );
  }
  Widget buildCheckBoxRow(String label1, String label2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CheckboxListTile(
            title: Text(label1),
            value: space.accessibility?.contains(label1),
            onChanged: (bool? value) {
              setState(() {
                value == true
                    ? space.accessibility?.add(label1)
                    : space.accessibility?.remove(label1);
              });
            },
            activeColor: Colors.blue,
          ),
        ),
        Expanded(
          child: CheckboxListTile(
            title: Text(label2),
            value: space.accessibility?.contains(label2),
            onChanged: (bool? value) {
              setState(() {
                value == true
                    ? space.accessibility?.add(label2)
                    : space.accessibility?.remove(label2);
              });
            },
            activeColor: Colors.blue,
          ),
        ),
      ],
    );
  }
  Widget buildCounterRow(String label, int counter, Function onIncrement, Function onDecrement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                onDecrement();
              },
            ),
            Text("$counter"),
            SizedBox(width: 15),
            Container(
              width: 25,
              height: 25,
              color: Colors.black,
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add, color: Colors.white, size: 18),
                  onPressed: () {
                    onIncrement();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget getSecondPageStep2Content() {
    List<Map<String, String>> generalEquipments = [
      {'name': 'Wifi', 'icon': 'assets/images/facebook.png'},
      {'name': 'TV', 'icon': 'assets/images/facebook.png'},
      {'name': 'Cuisine', 'icon': 'assets/images/facebook.png'},
      {'name': 'Climatisation', 'icon': 'assets/images/facebook.png'},
      {'name': 'Insonore', 'icon': 'assets/images/facebook.png'},
      {'name': 'Tableau', 'icon': 'assets/images/facebook.png'},
      {'name': 'Table', 'icon': 'assets/images/facebook.png'},
      {'name': 'Eclairage photographie', 'icon': 'assets/images/facebook.png'},
    ];

    List<Map<String, String>> exceptionalEquipments = [
      {'name': 'Piscine', 'icon': 'assets/images/facebook.png'},
      {'name': 'Equipement de sport', 'icon': 'assets/images/facebook.png'},
    ];

    List<Map<String, String>> securityItems = [
      {'name': 'Extincteur', 'icon': 'assets/images/facebook.png'},
      {'name': 'Trousse de premiers soins', 'icon': 'assets/images/facebook.png'},
      {'name': 'Decteur de fumée', 'icon': 'assets/images/facebook.png'},
    ];

    Widget buildSelectionBoxes(List<Map<String, String>> items) {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (space.amenities == null) {
                  space.amenities = [];
                }
                String name = items[index]['name']!;
                if (space.amenities!.contains(name)) {
                  space.amenities!.remove(name);
                } else {
                  space.amenities!.add(name);
                }
              });
            },
            child: Container(
              margin: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: (space.amenities?.contains(items[index]['name']) ?? false)
                    ? Colors.blue
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [ // Added boxShadow
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    items[index]['icon']!,
                    height: 50,
                    width: 50,
                  ),
                  Text(
                    items[index]['name']!,
                    style: TextStyle(
                      color: (space.amenities?.contains(items[index]['name']) ?? false)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Dites aux clients ce que votre lieu a à offrir",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          buildSelectionBoxes(generalEquipments),
          SizedBox(height: 20),
          Text(
            "Avez-vous des équipements exceptionnels?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          buildSelectionBoxes(exceptionalEquipments),
          SizedBox(height: 20),
          Text(
            "Avez-vous l’un de ces éléments de sécurité?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          buildSelectionBoxes(securityItems),
        ],
      )


    );
  }
  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
  Widget getThirdPageStep2Content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vous aurez besoin de 4 photos pour commencer. Vous pouvez en ajouter d'autres ou apporter des modifications ultérieurement.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            loadAssets();
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: images.isEmpty
                ? Center(
              child: Text(
                "Choisissez au moins 4 photos",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : buildGridView(),
          ),
        ),
      ],
    );

  }
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
  Widget getFourthPageStep2Content() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController ageRestrictionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Details",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              spaceTitle = value;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              spaceDescription = value;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: ageRestrictionController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age Restriction',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              ageRestriction = int.tryParse(value);
            },
          ),
        ],
      ),
    );
  }

  Widget getPageTwoStep3Content() {
    Map<String, bool> daysOpen = {
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': false,
      'Sunday': false,
    };

    Map<String, TimeOfDay> openingTime = {};
    Map<String, TimeOfDay> closingTime = {};

    return Padding(
      padding: const EdgeInsets.all(16.0), // Add space on the edges
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quelles sont vos heures d’ouverture?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "Les heures d’ouverture sont les jours et les heures de la semaine où votre logement est ouvert aux réservations d’hôtes (c’est-à-dire votre disponibilité générale). Les clients ne pourront pas réserver d’heures en dehors de vos heures d’ouverture",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          ...daysOpen.keys.map((day) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day),
                SizedBox(width: 10), // Add a little space between the day and the toggle button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      daysOpen[day] = !daysOpen[day]!;
                    });
                  },
                  child: Text(daysOpen[day]! ? "Ouvert" : "Fermer"),
                  style: ElevatedButton.styleFrom(
                    primary: daysOpen[day]! ? Colors.black : Colors.grey, // Change color when it's on
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );

  }
  void displayList(){
    print(spaceAvailabilityList);
    for (SpaceAvailability availability in spaceAvailabilityList) {
      print('Day of Week: ${availability.dayOfWeek}');
      print('Start Time: ${availability.startTime.hour}:${availability.startTime.minute}');
      print('End Time: ${availability.endTime.hour}:${availability.endTime.minute}');
      print('---');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Step Form'),
      ),
      body: Column(
        children: [
          // Step Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  color: index == currentStep ? Colors.blue : Colors.grey,
                  child: Center(
                    child: Text(''),
                  ),
                ),
              );
            }),
          ),
          // Content
          Expanded(
            child: currentPage == 0
                ? getFirstPageContent(currentStep)
                : (currentStep == 0 && currentPage == 1)
                ? getSecondPageContent()
                : (currentStep == 0 && currentPage == 2)
                ? getThirdPageContent()
                : (currentStep == 0 && currentPage == 3)
                ? getFourthPageContent()
                : (currentStep == 0 && currentPage == 4)
                ? getFifthPageContent()
                : (currentStep == 1 && currentPage == 1)
                ? getSecondPageStep2Content()
                : (currentStep == 1 && currentPage == 2)
                ? getThirdPageStep2Content()
                : (currentStep == 1 && currentPage == 3)
                ? getFourthPageStep2Content()
                : (currentStep == 2 && currentPage == 1)
                ? PageTwoStep3(spaceAvailabilityList: spaceAvailabilityList)
                : (currentStep == 2 && currentPage == 2)
                ? PageThreeStep3()

                : Center(
              child: Text('Page ${currentPage + 1} of Step ${currentStep + 1}'),
            ),
          ),

          // Progress Bar
          LinearProgressIndicator(
            value: (currentPage + 1) / (currentStep == 1 ? 4 : 5),
          ),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  displayList();
                  setState(() {
                    if (currentPage > 0) {
                      currentPage--;
                    } else if (currentStep > 0) {
                      currentStep--;
                      currentPage = currentStep == 1 ? 3 : 4;
                    }
                  });
                },
                child: Text('Previous'),
              ),
              ElevatedButton(
                onPressed: () {
                  displayList();
                  setState(() {
                    if (currentPage < (currentStep == 1 ? 3 : 4)) {
                      currentPage++;
                    } else if (currentStep < 2) {
                      currentStep++;
                      currentPage = 0;
                    }
                  });
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
