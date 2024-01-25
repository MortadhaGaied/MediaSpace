

import 'package:MediaSpaceFrontend/services/models/space_event_price.dart';

import 'Address.dart';
import 'SpaceEquipement.dart';
import 'SpaceType.dart';
import 'spaceavailability.dart';

class Space {
  int? id;
  String? name;
  Address? address;
  String? description;
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
  List<SpaceAvailability>? availabilities;
  int? ownerId;
  List<SpaceEventPrice>? eventPrices;
  DateTime? createdAt;
  DateTime? updatedAt;

  Space({
    this.id,
    this.name,
    this.address,
    this.description,
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
    this.eventPrices,
    this.createdAt,
    this.updatedAt,
  });
}
