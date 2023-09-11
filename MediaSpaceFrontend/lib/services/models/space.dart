import 'Address.dart';
import 'SpaceEquipement.dart';
import 'SpaceType.dart';

class Space {
  int? id;
  String? name;
  Address? address;
  String? description;
  double? price;
  int? maxGuest;
  int? roomNumber;
  int? bathroomNumber;
  int? floorNumber;
  int? restrictedMinAge;
  int? restrictedMaxAge;
  SpaceType? spaceType;
  String? spaceRule;
  List<String>? amenities;
  List<SpaceEquipement>? equipments;
  List<String>? accessibility;
  List<String>? images;
  double? squareFootage;
  List<String>? availabilities; // Assuming you'll create a SpaceAvailability Dart class
  int? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Space({
    this.id,
    this.name,
    this.address,
    this.description,
    this.price,
    this.maxGuest,
    this.roomNumber,
    this.bathroomNumber,
    this.floorNumber,
    this.restrictedMinAge,
    this.restrictedMaxAge,
    this.spaceType,
    this.spaceRule,
    this.amenities,
    this.equipments,
    this.accessibility,
    this.images,
    this.squareFootage,
    this.availabilities,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
  });
}
