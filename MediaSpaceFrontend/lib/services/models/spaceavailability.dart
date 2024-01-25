import 'package:flutter/material.dart';

class SpaceAvailability {
  String? dayOfWeek;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  SpaceAvailability({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
  @override
  String toString() {
    return 'SpaceAvailability(dayOfWeek: $dayOfWeek, startTime: ${startTime?.hour}:${startTime?.minute}, endTime: ${endTime?.hour}:${endTime?.minute})';
  }
}
