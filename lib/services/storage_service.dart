import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assignment.dart';
import '../models/session.dart';

class StorageService {
  static const String assignmentsKey = "assignments";
  static const String sessionsKey = "sessions";

  // Save assignments
  static Future<void> saveAssignments(List<Assignment> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = assignments
        .map((a) => jsonEncode({
              "title": a.title,
              "course": a.course,
              "dueDate": a.dueDate.toIso8601String(),
              "priority": a.priority,
              "completed": a.completed,
            }))
        .toList();

    await prefs.setStringList(assignmentsKey, encoded);
  }

  // Load assignments
  static Future<List<Assignment>> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(assignmentsKey) ?? [];

    return list.map((item) {
      final data = jsonDecode(item);
      return Assignment(
        title: data["title"],
        course: data["course"],
        dueDate: DateTime.parse(data["dueDate"]),
        priority: data["priority"],
        completed: data["completed"],
      );
    }).toList();
  }

  // Save sessions
  static Future<void> saveSessions(List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = sessions
        .map((s) => jsonEncode({
              "title": s.title,
              "date": s.date.toIso8601String(),
              "startHour": s.startTime.hour,
              "startMinute": s.startTime.minute,
              "endHour": s.endTime.hour,
              "endMinute": s.endTime.minute,
              "type": s.type,
              "location": s.location,
              "present": s.present,
            }))
        .toList();

    await prefs.setStringList(sessionsKey, encoded);
  }

  // Load sessions
  static Future<List<Session>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(sessionsKey) ?? [];

    return list.map((item) {
      final data = jsonDecode(item);
      return Session(
        title: data["title"],
        date: DateTime.parse(data["date"]),
        startTime: TimeOfDay(hour: data["startHour"], minute: data["startMinute"]),
        endTime: TimeOfDay(hour: data["endHour"], minute: data["endMinute"]),
        type: data["type"],
        location: data["location"] ?? "",
        present: data["present"],
      );
    }).toList();
  }
}