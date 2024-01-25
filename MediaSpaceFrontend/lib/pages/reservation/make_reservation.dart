import 'package:MediaSpaceFrontend/services/backend/auth-service.dart';
import 'package:MediaSpaceFrontend/services/backend/reservation-service.dart';
import 'package:MediaSpaceFrontend/services/models/reservationStatus.dart';
import 'package:MediaSpaceFrontend/widgets/equipement_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../services/backend/space-service.dart';
import '../../services/models/reservation.dart';
import '../../services/models/reservationequipement.dart';
class ReservationRequestWidget extends StatefulWidget {
  final int spaceId;
  final int ownerId;
  ReservationRequestWidget({required this.spaceId, required this.ownerId});
  @override
  _ReservationRequestWidgetState createState() => _ReservationRequestWidgetState();
}
class _ReservationRequestWidgetState extends State<ReservationRequestWidget> {
  double spaceRentalPrice = 0;
  double additionalElementPrice = 0;
  double fees = 0;
  double totalPrice = 0;
  String? selectedCard;
  TextEditingController cardController = TextEditingController();
  Map<String, dynamic> spaceData = {};
  bool isLoading = true;
  String? selectedEventType;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int numberOfParticipants=1;
  final _participantsController = TextEditingController();
  List<dynamic> equipments =[];
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    loadSpaceData().then((_) {
      if (spaceData['eventPrices'] != null && spaceData['eventPrices'].isNotEmpty) {
        final firstEventType = spaceData['eventPrices'].first['eventType'];
        setState(() {
          selectedEventType = firstEventType;
          spaceRentalPrice = spaceData['eventPrices'].first['price'];
          updateSpaceRentalPrice();  // Update the price based on duration
        });
      }
    });
  }


  @override
  void dispose() {
    _participantsController.dispose();
    super.dispose();
  }
  Future<void> loadSpaceData() async {
    SpaceService spaceService = SpaceService();
    final response = await spaceService.retrieveSpace(widget.spaceId);
    if (response.statusCode == 200) {
      setState(() {
        spaceData = json.decode(response.body);
        print(spaceData);
        equipments=spaceData['equipments'];
        print("llll\n");
        print(equipments);
        print("ssss\n");
        print(spaceData['equipments']);
        isLoading = false;
      });
    } else {
      print('Failed to load space data');
    }
  }
  int getDayOfWeekNumber(String dayOfWeek) {
    const dayOfWeekToNumber = {
      'MONDAY': DateTime.monday,
      'TUESDAY': DateTime.tuesday,
      'WEDNESDAY': DateTime.wednesday,
      'THURSDAY': DateTime.thursday,
      'FRIDAY': DateTime.friday,
      'SATURDAY': DateTime.saturday,
      'SUNDAY': DateTime.sunday,
    };
    return dayOfWeekToNumber[dayOfWeek.toUpperCase()] ?? 0;
  }
  int getFirstDayOfWeekNumber() {
    if (spaceData['availabilities'] != null && spaceData['availabilities'].isNotEmpty) {
      String firstDayOfWeek = spaceData['availabilities'][0]['dayOfWeek'];
      return getDayOfWeekNumber(firstDayOfWeek);
    }
    return 0;
  }
  DateTime getNextAvailableDate() {
    List<String> availableDays = spaceData['availabilities']
        ?.map<String>((a) => a['dayOfWeek'].toString().toUpperCase())
        .toList() ?? [];
    List<int> availableWeekdayNumbers = availableDays
        .map<int>(getDayOfWeekNumber)
        .toList();

    DateTime now = DateTime.now();
    DateTime nextAvailableDate = now.add(Duration(days: 1));
    while (true) {
      if (availableWeekdayNumbers.contains(nextAvailableDate.weekday) &&
          nextAvailableDate.isAfter(now.add(Duration(days: 1)))) {
        break;
      }
      nextAvailableDate = nextAvailableDate.add(Duration(days: 1));
    }
    return nextAvailableDate;
  }
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      if (isTimeWithinAvailability(picked)) {
        setState(() {
          startTime = picked;
          if (endTime != null) {
            updateSpaceRentalPrice();
          }
        });
      } else {
        // Show an error message if the time is not within the availability
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected time is not within the availability.')),
        );
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? (startTime ?? TimeOfDay.now()).replacing(hour: (startTime?.hour ?? TimeOfDay.now().hour) + 1),
    );
    if (picked != null && picked != endTime) {
      if (isTimeWithinAvailability(picked)) {
        setState(() {
          endTime = picked;
          updateSpaceRentalPrice();
        });
      } else {
        // Show an error message if the time is not within the availability
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected time is not within the availability.')),
        );
      }
    }
  }
  int calculateHours(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    return endTime.difference(startTime).inHours;
  }
  void updateSpaceRentalPrice() {
    if (startTime != null && endTime != null) {
      int duration = calculateHours(startTime!, endTime!);
      setState(() {
        spaceRentalPrice = spaceData['eventPrices'].first['price'] * duration;
        calculateFees();
        calculateTotalPrice();
      });
    }
  }


  bool isTimeWithinAvailability(TimeOfDay time) {
    // Assuming availabilities for the selected date are loaded in a list 'selectedDayAvailabilities'
    for (var availability in spaceData['availabilities']) {
      final startTime = TimeOfDay(hour: int.parse(availability['startTime'].split(':')[0]), minute: int.parse(availability['startTime'].split(':')[1]));
      final endTime = TimeOfDay(hour: int.parse(availability['endTime'].split(':')[0]), minute: int.parse(availability['endTime'].split(':')[1]));

      if ((time.hour > startTime.hour || (time.hour == startTime.hour && time.minute >= startTime.minute)) &&
          (time.hour < endTime.hour || (time.hour == endTime.hour && time.minute <= endTime.minute))) {
        return true;
      }
    }
    return false;
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: getNextAvailableDate(),
      firstDate: getNextAvailableDate(),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        List<int> availableWeekdays = spaceData['availabilities']
            ?.map<int>((a) => getDayOfWeekNumber(a['dayOfWeek']))
            .toList() ?? [];
        return availableWeekdays.contains(day.weekday);
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  List<ReservationEquipment> reservationEquipments = [];

  void _updateEquipmentQuantity(int equipmentId, int quantity) {
    setState(() {
      final index = reservationEquipments.indexWhere((eq) => eq.idEquipment == equipmentId);
      if (quantity > 0) {
        if (index != -1) {
          // Update quantity if the equipment is already in the list
          reservationEquipments[index].quantity = quantity;
        } else {
          // Add equipment to the list if it's not there and quantity is not zero
          reservationEquipments.add(ReservationEquipment(idEquipment: equipmentId, quantity: quantity));
        }
      } else if (index != -1) {
        // If quantity is zero, remove the equipment from the list
        reservationEquipments.removeAt(index);
      }
      calculateAdditionalElementPrice();
      calculateFees();
      calculateTotalPrice();
    });
  }
  void calculateAdditionalElementPrice() {
    double totalAdditionalPrice = 0.0;

    for (var reservedEquipment in reservationEquipments) {
      var equipmentData = spaceData['equipments'].firstWhere(
            (equipment) => equipment['id'] == reservedEquipment.idEquipment,
        orElse: () => null,
      );

      if (equipmentData != null) {
        double equipmentPrice = equipmentData['price'];
        int quantity = reservedEquipment.quantity;
        totalAdditionalPrice += equipmentPrice * quantity;
      }
    }
    setState(() {
      additionalElementPrice = totalAdditionalPrice;
    });
  }
  void calculateFees() {
    setState(() {
      fees = (spaceRentalPrice + additionalElementPrice) * 0.2;
    });
  }

  void calculateTotalPrice() {
    setState(() {
      totalPrice = spaceRentalPrice + additionalElementPrice + fees;
    });
  }
  Future<void> fetchCurrentUserAndUpdateReservation() async {
    AuthenticationService authService = AuthenticationService();
    try {
      final currentUser = await authService.getCurrentUser();
      final reservation = createReservation(currentUser['id']);
      await sendReservation(reservation);
    } catch (error) {
      print('Error fetching user or creating reservation: $error');
      // Handle error (e.g., show a dialog to the user)
    }
  }
  Future<void> sendReservation(Reservation reservation) async {
    ReservationService reservationService=ReservationService();
    try {
      print("****************\n");
      print("Reservation Details: ${jsonEncode(reservation.toJson())}");

      final result = await reservationService.addReservation(reservation);
      print("Reservation Created: ${jsonEncode(result.toJson())}");
      // Handle successful reservation creation (e.g., navigate to a confirmation page)
    } catch (error) {
      print('Error sending reservation: $error');
      // Handle error (e.g., show an error message to the user)
    }
  }

  Reservation createReservation(int userId) {
    return Reservation(
      id: null, // ID will be null for a new reservation
      totalPrice: totalPrice,
      idSpace: widget.spaceId,
      idUser:userId, // Replace with actual user ID
      eventType: selectedEventType ?? 'OTHER',
      nbParticipant: int.tryParse(_participantsController.text) ?? 1,
      date: selectedDate ?? DateTime.now(),
      startTime: DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        startTime?.hour ?? 0,
        startTime?.minute ?? 0,
      ),
      endTime: DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        endTime?.hour ?? 0,
        endTime?.minute ?? 0,
      ),
      reservationStatus: ReservationStatus.PENDING,
      reservationEquipments: reservationEquipments,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Space Reservation')),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Demande de reservation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Type d\'événement',
                  border: OutlineInputBorder(),
                ),
                value: selectedEventType,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEventType = newValue;
                      spaceRentalPrice = spaceData['eventPrices'].firstWhere(
                            (price) => price['eventType'] == newValue,
                        orElse: () => {'price': 0.0},
                      )['price'];
                      calculateFees();
                      calculateTotalPrice();
                    });
                  }
                },

                items: spaceData['eventPrices']
                    ?.map<DropdownMenuItem<String>>((eventPrice) {
                  return DropdownMenuItem<String>(
                    value: eventPrice['eventType'],
                    child: Text(eventPrice['eventType']),
                  );
                })?.toList() ?? [],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date Picker
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        selectedDate != null
                            ? "${selectedDate!.toLocal()}".split(' ')[0]
                            : 'Select Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // Spacing between buttons

                  // Start Time Picker
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectStartTime(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        startTime != null
                            ? "${startTime!.format(context)}"
                            : 'Start Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // Spacing between buttons

                  // End Time Picker
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectEndTime(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        endTime != null
                            ? "${endTime!.format(context)}"
                            : 'End Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Nombre des participants"),
              TextFormField(
                controller: _participantsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Nombre des participants',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) > spaceData['maxGuest']) {
                    setState(() {
                      _errorMessage = 'Le nombre de participants ne peut pas dépasser ${spaceData['maxGuest']}';
                    });
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              Column(
                children: <Widget>[
                  if (_errorMessage != null) ...[
                    SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Equipement",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              for(var equipment in spaceData['equipments'])
                 EquipmentCard(
                  equipmentId: equipment['id'],
                  equipmentName: equipment['name'],
                  imageUrl: equipment['image'],
                  price: equipment['price'],
                  maxQuantity: equipment['quantity'],
                  description: equipment['description'],
                  onQuantityChange: _updateEquipmentQuantity,
                ),
              SizedBox(height: 20),
              Text(
                "Révision et Paiement",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildLocationPricingTable(),
              SizedBox(height: 20),
              buildEquipmentPricingTable(),
              SizedBox(height: 20),
              buildTotalPricingTable(),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text("J'ai lu et j'accepte les règles du proprietaire"),
                value: true,
                onChanged: (bool? value) {
                  // Handle checkbox change
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Envoyez un message au propriétaire',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => fetchCurrentUserAndUpdateReservation(),
                child: Text("Demande de reservation"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "En cliquant sur Demande de réservation, vous demandez à réserver l’espace de Jhon et une retenue sera placée sur votre carte. Si Jhon accepte, votre réservation sera confirmée et votre carte sera débitée.\n\nJhon répond généralement dans les 2 heures\n\nEn cliquant sur Demande de réservation, vous acceptez également le Contrat de Services de Peerspace, qui comprend les Règles de la communauté et la Politique d’annulation et de remboursement.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget buildLocationPricingTable() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location d'espace",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total location d’espace"),
                  Text("$spaceRentalPrice DT"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEquipmentPricingTable() {
    List<TableRow> rows = [
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Element supplementaire', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Quantite', style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Prix', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          ),
        ],
      ),
    ];

    for (var reservedEquipment in reservationEquipments) {
      var equipmentData = spaceData['equipments'].firstWhere(
            (equipment) => equipment['id'] == reservedEquipment.idEquipment,
        orElse: () => null,
      );

      if (equipmentData != null) {
        rows.add(
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(equipmentData['name']),
              ),
              Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('${reservedEquipment.quantity}'),
              )),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('${(reservedEquipment.quantity * equipmentData['price']).toStringAsFixed(2)} DT', textAlign: TextAlign.right),
              ),
            ],
          ),
        );
      }
    }

    rows.add(
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Total Element supplementaire', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TableCell(
            child: SizedBox.shrink(), // Empty cell
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('$additionalElementPrice DT', textAlign: TextAlign.right),
          ),
        ],
      ),
    );

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        1: IntrinsicColumnWidth(), // This will ensure that the quantity column width is based on content
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      children: rows,
    );
  }


  Widget buildTotalPricingTable() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Prix",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total location d’espace"),
                  Text("$spaceRentalPrice DT"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Element supplementaire"),
                  Text("$additionalElementPrice DT"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Frais"),
                  Text("${(spaceRentalPrice + additionalElementPrice) * 0.2} DT"),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("$totalPrice DT", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget buildExpandablePanel(String header, Widget expandedContent, {bool isLast = false}) {
    // Your provided expandable panel code
    return Container();
  }
}