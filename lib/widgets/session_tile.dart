import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  final Function(bool) onToggle;

  const SessionTile({
    super.key,
    required this.session,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(session.title),
      subtitle: Text(
        "${session.type} • ${session.startTime.format(context)} - ${session.endTime.format(context)}",
      ),
      trailing: Switch(
        value: session.present,
        onChanged: onToggle,
      ),
    );
  }
}