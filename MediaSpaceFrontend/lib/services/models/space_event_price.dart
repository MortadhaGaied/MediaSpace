
import 'package:MediaSpaceFrontend/services/models/space.dart';

enum SpaceEventType {
  MEETING,
  PARTY,
  PRODUCTION,
}

class SpaceEventPrice {
  int? id;
  SpaceEventType? eventType;
  double? price;

  SpaceEventPrice({
    required this.id,
    required this.eventType,
    required this.price,
  });
}
