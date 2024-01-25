import 'package:MediaSpaceFrontend/widgets/page3step3.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

import '../../services/models/Address.dart';
import '../../services/models/SpaceType.dart';
import '../../services/models/space.dart';
import '../../services/models/spaceavailability.dart';
import '../../widgets/map_position.dart';
import '../../widgets/page2_step3.dart';
import 'package:permission_handler/permission_handler.dart';
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

  String? ownerType;
  int currentStep = 0;
  int currentPage = 0;
  bool isOtherChecked = false;

  ValueNotifier<LatLng?> pickedPosition = ValueNotifier<LatLng?>(null);
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
    List<Map<String, dynamic>> spaceTypes = [
      {'type': 'Maison', 'icon': Icons.home,'spaceType':'HOUSE'},
      {'type': 'Appartement', 'icon': Icons.apartment,'spaceType':'APARTMENT'},
      {'type': 'Bureau', 'icon':Icons.maps_home_work ,'spaceType':'OFFICE'},
      {'type': 'Studio', 'icon':Icons.headset ,'spaceType':'STUDIO'},
      {'type': 'Restaurant', 'icon':Icons.tapas ,'spaceType':'BARRESTO'},
      {'type': 'Salle des fetes', 'icon': Icons.castle,'spaceType':'HOUSE'},
      {'type': 'Theatre', 'icon': Icons.theaters,'spaceType':'HOUSE'},
      {'type': 'Bateau', 'icon': Icons.directions_boat,'spaceType':'BOAT'},
      {'type': 'Hotel', 'icon': Icons.hotel,'spaceType':'HOTEL'},
      {'type': 'Galerie', 'icon': Icons.color_lens,'spaceType':'GALLERY'},
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
              SpaceType currentSpaceType = SpaceType.values.firstWhere(
                      (e) => e.toString() == 'SpaceType.' + spaceTypes[index]['spaceType']!,
                  orElse: () => SpaceType.HOUSE
              );
              return GestureDetector(
                onTap: () {
                  setState(() {
                    space.spaceType = currentSpaceType;
                  });
                  print(space.spaceType.toString());
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: space.spaceType == currentSpaceType ? Colors.blue : Colors.white,
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
                      Icon(
                        spaceTypes[index]['icon'],
                        size: 70,
                        color: space.spaceType == currentSpaceType ? Colors.white : Colors.black,
                      ),
                      SizedBox(height: 10),
                      Text(
                        spaceTypes[index]['type']!,
                        style: TextStyle(
                          fontSize: 20,
                          color: space.spaceType == currentSpaceType ? Colors.white : Colors.black,
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
    List<Map<String, dynamic>> ownerTypes = [
      {'type': 'Individual', 'icon': Icons.person},
      {'type': 'Company', 'icon': Icons.business},
      {'type': 'Organization', 'icon': Icons.group},
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
                      SizedBox(width: 10,),
                      Icon(
                        ownerTypes[index]['icon'],
                        size: 70,
                        color: ownerType == ownerTypes[index]['type']
                            ? Colors.white
                            : Colors.black,
                      ),
                      SizedBox(width: 30),
                      Text(
                        ownerTypes[index]['type']!,
                        style: TextStyle(
                          fontSize: 25,
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
    TextEditingController address1Controller = TextEditingController();
    TextEditingController address2Controller = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController postalCodeController = TextEditingController();
    String? _selectedRegion;
    Map<String, LatLng> tunisiaRegions = {
      'Ariana': LatLng(36.8665, 10.1647),
      'Beja': LatLng(36.7256, 9.18169),
      'Ben Arous': LatLng(36.7473, 10.2219),
      'Bizerte': LatLng(37.2744, 9.8745),
      'Gabes': LatLng(33.8815, 10.0982),
      'Gafsa': LatLng(34.4227, 8.7842),
      'Jendouba': LatLng(36.5034, 8.7753),
      'Kairouan': LatLng(35.6781, 10.0963),
      'Kasserine': LatLng(35.1676, 8.8365),
      'Kebili': LatLng(33.7044, 8.9690),
      'Kef': LatLng(36.1693, 8.7049),
      'Mahdia': LatLng(35.5049, 11.0628),
      'Manouba': LatLng(36.8083, 10.0972),
      'Medenine': LatLng(33.3549, 10.5054),
      'Monsatir': LatLng(35.7836, 10.8259), // Note: It might be "Monastir", so check the name
      'Nabeul': LatLng(36.4561, 10.7376),
      'Sfax': LatLng(34.7452, 10.7613),
      'Sidi Bouzid': LatLng(35.0382, 9.4849),
      'Siliana': LatLng(36.0845, 9.3708),
      'Sousse': LatLng(35.8254, 10.6084),
      'Tataouine': LatLng(32.9297, 10.4510),
      'Tozeur': LatLng(33.9197, 8.1339),
      'Tunis': LatLng(36.8065, 10.1815),
      'Zaghouan': LatLng(36.4043, 10.1421),
    };
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Où est situé votre place?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Address Fields
            Text("Adresse"),
            SizedBox(height: 10),
            TextFormField(
              controller: address1Controller,
              decoration: InputDecoration(
                labelText: 'Adresse 1',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (space.address == null) {
                  space.address = Address();
                }
                space.address!.street = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: address2Controller,
              decoration: InputDecoration(
                labelText: 'Adresse 2',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (space.address == null) {
                  space.address = Address();
                }
                space.address!.street = (space.address!.street ?? '') + ', ' + (value ?? '');
              },
            ),
            SizedBox(height: 10),

            // Region Dropdown for Tunisia
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              items: tunisiaRegions.keys.map((region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegion = newValue;
                  if (_selectedRegion != null && tunisiaRegions.containsKey(_selectedRegion!)) {
                    pickedPosition.value = tunisiaRegions[_selectedRegion!];
                  }
                });
              },
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
              onChanged: (value) {
                if (space.address == null) {
                  space.address = Address();
                }
                space.address!.city = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: postalCodeController,
              decoration: InputDecoration(
                labelText: 'Code postal',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (space.address == null) {
                  space.address = Address();
                }
                space.address!.zipCode = value;
              },
            ),
            SizedBox(height: 10),
            CustomMap2(
              pickedPosition: pickedPosition,
              onConfirm: (position) {
                // Store the position or handle it
                if (space.address == null) {
                  space.address = Address();
                }
                space.address!.latitude = position.latitude;
                space.address!.longitude = position.longitude;

                print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
              },
            ),
          ],
        ),
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
              space.squareFootage = double.tryParse(value);
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
                space.accessibility?.add(value);
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
    List<Map<String, dynamic>> generalEquipments = [
      {'name': 'Wifi', 'icon': Icons.wifi},
      {'name': 'TV', 'icon': Icons.tv},
      {'name': 'Cuisine', 'icon': Icons.restaurant},
      {'name': 'Climatisation', 'icon': Icons.ac_unit},
      {'name': 'Insonore', 'icon': Icons.volume_off},
      {'name': 'Tableau', 'icon': Icons.border_color},
      {'name': 'Table', 'icon': Icons.table_chart},
      {'name': 'Eclairage photographie', 'icon': Icons.lightbulb_outline},
    ];
    List<Map<String, dynamic>> exceptionalEquipments = [
      {'name': 'Piscine', 'icon': Icons.pool},
      {'name': 'Equipement de sport', 'icon': Icons.sports},
    ];
    List<Map<String, dynamic>> securityItems = [
      {'name': 'Extincteur', 'icon': Icons.fire_extinguisher},
      {'name': 'Trousse de premiers soins', 'icon': Icons.medical_services},
      {'name': 'Decteur de fumée', 'icon': Icons.smoke_free},
    ];
    Widget buildSelectionBoxes(List<Map<String, dynamic>> items) {
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
                  Icon(
                    items[index]['icon'],
                    size: 50,
                    color: (space.amenities?.contains(items[index]['name']) ?? false)
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    items[index]['name']!,
                    style: TextStyle(
                      fontSize: 20, // Adjust this value as needed
                      color: (space.amenities?.contains(items[index]['name']) ?? false)
                          ? Colors.white
                          : Colors.black,
                    ),
                    textAlign: TextAlign.center, // This centers the text
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
  String _error = 'No Error Detected';
  Future<void> loadAssets() async {
    if (await _requestPermission(Permission.photos)) {
      List<Asset> resultList = <Asset>[];
      String error = 'No Error Detected';
      try {
        resultList = await MultipleImagesPicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Select Images",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
        print(error);
      }
      if (!mounted) return;

      setState(() {
        images = resultList;
        _error = error;
      });
    } else {
      setState(() {
        _error = 'Permission not granted to access photos';
      });
    }
  }
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
  Widget getThirdPageStep2Content() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vous aurez besoin de 4 photos pour commencer. Vous pouvez en ajouter d'autres ou apporter des modifications ultérieurement.",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                loadAssets();
              },
              child: DottedBorder(
                dashPattern: [8, 4],
                strokeWidth: 2,
                color: Colors.grey,
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 300,
                    child: images.isEmpty
                        ? Center(
                      child: Text(
                        "Choisissez au moins 4 photos",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    )
                        : buildGridView(),
                  ),
                ),
              ),
            ),
          ),
          if (_error.isNotEmpty) Center(child: Text('Error: $_error')),
        ],
      ),
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
    List<String> ageRestrictions = [
      "Tout les ages",
      "18+",
      "21+",
    ];

    // If you haven't initialized these properties of the 'space' object, ensure you do so.
    String selectedAgeRestriction = space.restrictedMinAge != null ?
    (space.restrictedMinAge == 18 ? "18+" :
    (space.restrictedMinAge == 21 ? "21+" : "Tout les ages")) :
    "Tout les ages";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Donnez un titre à votre espace",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: titleController..text = space.name ?? '',  // Initialize with space's name if available.
            decoration: InputDecoration(
              labelText: 'Titre',
              hintText: "Titre",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              space.name = value;
            },
          ),
          SizedBox(height: 20),
          Text(
            "Ajouter une description pour votre espace",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: descriptionController..text = space.description ?? '',  // Initialize with space's description if available.
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "",
            ),
            onChanged: (value) {
              space.description = value;
            },
          ),
          SizedBox(height: 20),
          Text(
            "Qui est autorisé dans votre espace?",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedAgeRestriction,
            items: ageRestrictions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedAgeRestriction = newValue!;

                // Convert the selected string to the appropriate age restriction.
                if (newValue == "18+") {
                  space.restrictedMinAge = 18;
                } else if (newValue == "21+") {
                  space.restrictedMinAge = 21;
                } else {
                  space.restrictedMinAge = null; // This represents "Tout les ages".
                }
              });
            },
          ),
        ],
      ),
    );
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
                ? PageTwoStep3(spaceAvailabilityList: space.availabilities)
                : (currentStep == 2 && currentPage == 2)
                ? PageThreeStep3(eventPrices:space.eventPrices)

                : Center(
              child: Text('Page ${currentPage + 1} of Step ${currentStep + 1}'),
            ),
          ),
          LinearProgressIndicator(
            value: (currentPage + 1) / (currentStep == 1 ? 4 : 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
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