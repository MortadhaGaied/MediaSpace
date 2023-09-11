import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class ReservationRequestWidget extends StatefulWidget {
  @override
  _ReservationRequestWidgetState createState() => _ReservationRequestWidgetState();
}

class _ReservationRequestWidgetState extends State<ReservationRequestWidget> {
  // Define your variables here, e.g., for prices, selected date, etc.
  double spaceRentalPrice = 150.0;
  double additionalElementPrice = 56.0;
  double fees = 20.6;
  double totalPrice = 226.6;
  List<String> savedCards = ['Card 1', 'Card 2', 'Card 3'];
  String? selectedCard;
  TextEditingController cardController = TextEditingController();

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
              // Title
              Text(
                "Demande de reservation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Event Type TextField
              Text("Type evenement"),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Entrez le type d\'événement',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // TODO: Add Date and Time pickers here

              // Number of participants
              Text("Nombre des participants"),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Entrez le nombre de participants',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Pricing Tables
              buildPricingTable1(),
              SizedBox(height: 20),
              buildPricingTable2(),
              SizedBox(height: 20),

              // Expandable Panels
              buildExpandablePanel("Panel Header 1", Text("Panel Content 1")),
              buildExpandablePanel("Panel Header 2", Text("Panel Content 2"), isLast: true),
              SizedBox(height: 20),

              // Acceptance Checkbox
              CheckboxListTile(
                title: Text("J'ai lu et j'accepte les règles du proprietaire"),
                value: true, // TODO: Bind this to a variable
                onChanged: (bool? value) {
                  // Handle checkbox change
                },
              ),
              SizedBox(height: 20),

              // TODO: Add credit card selection and addition logic here
              Text("Choisir une carte enregistrée"),
              for (var card in savedCards)
                RadioListTile<String>(
                  title: Text(card),
                  value: card,
                  groupValue: selectedCard,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCard = value;
                    });
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Ajouter une nouvelle carte'),
                        content: TextField(
                          controller: cardController,
                          decoration: InputDecoration(hintText: 'Entrez les informations de la carte'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Integrate Stripe here to save the card
                              // For now, just adding to the list
                              setState(() {
                                savedCards.add(cardController.text);
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Sauvegarder'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Ajouter une nouvelle carte"),
              ),

              // Message to owner
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Envoyez un message au propriétaire',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Reservation Button
              ElevatedButton(
                onPressed: () {
                  // Handle reservation request
                },
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

              // Footer Text
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

  Widget buildPricingTable1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Location d'espace", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total location d’espace"),
            Text("$spaceRentalPrice DT"),
          ],
        ),
      ],
    );
  }

  Widget buildPricingTable2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Prix", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total location d’espace"),
            Text("$spaceRentalPrice DT"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Element supplementaire"),
            Text("$additionalElementPrice DT"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Frais"),
            Text("$fees DT"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$totalPrice DT", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget buildExpandablePanel(String header, Widget expandedContent, {bool isLast = false}) {
    // Your provided expandable panel code
    return Container();
  }
}
