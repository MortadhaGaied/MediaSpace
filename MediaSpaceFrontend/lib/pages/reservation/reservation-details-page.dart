import 'package:flutter/material.dart';
import 'package:MediaSpaceFrontend/services/models/reservation.dart';
import 'package:MediaSpaceFrontend/services/models/reservationequipement.dart';
import 'package:pdf/pdf.dart';

import '../../services/backend/auth-service.dart';
import '../../widgets/image-slider.dart';
import '../../widgets/space-card.dart';
import '../search-pages/space-details-page.dart';
import 'make_reservation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class ReservationDetailsPage extends StatelessWidget {
  final Reservation reservation;
  final Map space;

  ReservationDetailsPage({required this.reservation, required this.space});
  Map<String, dynamic> owner = {};
  AuthenticationService authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SpaceCard(space: space),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SpaceDetailsPage(spaceId: space['id']),
                    ),
                  );
                },
                child: Container(
                  height: 350,
                  child: MyImageSlider(images: space['images']),
                ),
              ),



              SizedBox(height: 10),
              // Price, Guest, Reserve Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${space['name']}",
                    style: TextStyle(fontSize: 35),
                  ),


                ],
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  Text("${space['address']['city']} ${space['address']['state']}"),

                ],
              ),
              SizedBox(height: 20),
              Text(
                'Reservation Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              detailItem('Event Type', reservation.eventType),
              detailItem('Total Price', "\$${reservation.totalPrice.toStringAsFixed(2)}"),
              detailItem('Participants', reservation.nbParticipant.toString()),
              detailItem('Date', formatDate(reservation.date)),
              detailItem('Start Time', formatTime(reservation.startTime)),
              detailItem('End Time', formatTime(reservation.endTime)),
              SizedBox(height: 20),
              Text(
                'Equipment Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildEquipmentList(reservation.reservationEquipments),
              SizedBox(height: 20),
              buildPricingTable(),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _createPdfAndPrint(context),
                child: Text('Download PDF'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    // Implement your date formatting
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(DateTime time) {
    // Implement your time formatting
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget buildEquipmentList(List<ReservationEquipment> equipments) {
    return Column(
      children: equipments
          .map((equipment) => ListTile(
        title: Text("Equipement name"),
        subtitle: Text('Quantity: ${equipment.quantity}'),
        trailing: Text("\$555"),
      ))
          .toList(),
    );
  }

  Widget buildPricingTable() {
    double additionalPrice = reservation.reservationEquipments.fold(
        0, (previousValue, element) => previousValue + (element.quantity * 255));
    double fees = (reservation.totalPrice + additionalPrice) * 0.2;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pricingRow('Total Space Rental', "\$${reservation.totalPrice.toStringAsFixed(2)}"),
            pricingRow('Total Equipment Price', "\$${additionalPrice.toStringAsFixed(2)}"),
            pricingRow('Fees', "\$${fees.toStringAsFixed(2)}"),
            Divider(),
            pricingRow('Total', "\$${(reservation.totalPrice + additionalPrice + fees).toStringAsFixed(2)}", bold: true),
          ],
        ),
      ),
    );
  }

  Widget pricingRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          Text(
            value,
            style: bold ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }
  Future<void> _createPdfAndPrint(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reservation Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _detailItem('Event Type', reservation.eventType),
              _detailItem('Total Price', "\$${reservation.totalPrice.toStringAsFixed(2)}"),
              _detailItem('Participants', reservation.nbParticipant.toString()),
              _detailItem('Date', formatDate(reservation.date)),
              _detailItem('Start Time', formatTime(reservation.startTime)),
              _detailItem('End Time', formatTime(reservation.endTime)),
              pw.Divider(),
              pw.Text('Equipment Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.ListView.builder(
                itemCount: reservation.reservationEquipments.length,
                itemBuilder: (context, index) {
                  final equipment = reservation.reservationEquipments[index];
                  return _equipmentItem(equipment);
                },
              ),
              _pricingTable(context),
            ],
          );
        },
      ),
    );

    // Save the PDF file and print it
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _detailItem(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  pw.Widget _equipmentItem(ReservationEquipment equipment) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("Equipment name"),
        pw.Text('Quantity: ${equipment.quantity}'),
        pw.Text("\$99"),
      ],
    );
  }

  pw.Widget _pricingTable(pw.Context context) {
    double additionalPrice = reservation.reservationEquipments.fold(
        0, (previousValue, element) => previousValue + (element.quantity * 22));
    double fees = (reservation.totalPrice + additionalPrice) * 0.2;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pricingRow('Total Space Rental', "\$${reservation.totalPrice.toStringAsFixed(2)}"),
        _pricingRow('Total Equipment Price', "\$${additionalPrice.toStringAsFixed(2)}"),
        _pricingRow('Fees', "\$${fees.toStringAsFixed(2)}"),
        pw.Divider(),
        _pricingRow('Total', "\$${(reservation.totalPrice + additionalPrice + fees).toStringAsFixed(2)}", bold: true),
      ],
    );
  }

  pw.Widget _pricingRow(String label, String value, {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : pw.TextStyle(),
        ),
        pw.Text(
          value,
          style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : pw.TextStyle(),
        ),
      ],
    );
  }




}
