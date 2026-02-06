import 'package:flutter/material.dart';

class Session {
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String type;
  String location;
  bool present;

  Session({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.location = "",
    this.present = false,
  });
}
