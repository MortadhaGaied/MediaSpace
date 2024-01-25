class ReservationEquipment {
  final int idEquipment;
  int quantity;

  ReservationEquipment({
    required this.idEquipment,
    required this.quantity,
  });

  factory ReservationEquipment.fromJson(Map<String, dynamic> json) => ReservationEquipment(
    idEquipment: json['idEquipment'],
    quantity: json['quantity'],
  );

  Map<String, dynamic> toJson() => {
    'idEquipment': idEquipment,
    'quantity': quantity,
  };
}