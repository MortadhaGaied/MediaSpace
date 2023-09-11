import 'package:flutter/material.dart';

class SpaceAvailability {
  final String dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  SpaceAvailability({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
