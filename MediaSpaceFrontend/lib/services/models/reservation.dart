import 'package:MediaSpaceFrontend/services/models/reservationStatus.dart';
import 'package:MediaSpaceFrontend/services/models/reservationequipement.dart';

class Reservation {
  final int? id; // Nullable because it might not exist before creation
  final double totalPrice;
  final int idSpace;
  final int idUser;
  final String eventType; // Assuming this is a string enum in your Flutter app
  final int nbParticipant;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final ReservationStatus reservationStatus;
  final List<ReservationEquipment> reservationEquipments;

  Reservation({
    this.id,
    required this.totalPrice,
    required this.idSpace,
    required this.idUser,
    required this.eventType,
    required this.nbParticipant,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reservationStatus,
    required this.reservationEquipments,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'],
    totalPrice: json['totalPrice'].toDouble(),
    idSpace: json['idSpace'],
    idUser: json['idUser'],
    eventType: json['eventType'],
    nbParticipant: json['nbParticipant'],
    date: DateTime.parse(json['date']),
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    reservationStatus: _parseReservationStatus(json['reservationStatus']),
    reservationEquipments: List<ReservationEquipment>.from(
      json['reservationEquipments']
          ?.map((x) => ReservationEquipment.fromJson(x)) ?? [],
    ),
  );
  static ReservationStatus _parseReservationStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return ReservationStatus.ACCEPTED;
      case 'REJECTED':
        return ReservationStatus.REJECTED;
      case 'PENDING':
      default:
        return ReservationStatus.PENDING;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'totalPrice': totalPrice,
    'idSpace': idSpace,
    'idUser': idUser,
    'eventType': eventType,
    'nbParticipant': nbParticipant,
    'date': date.toIso8601String(),
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'reservationStatus': reservationStatus,
    'reservationEquipments': reservationEquipments.map((x) => x.toJson()).toList(),
  };
}
