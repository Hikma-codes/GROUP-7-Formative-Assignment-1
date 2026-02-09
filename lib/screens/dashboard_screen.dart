import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Assignment> assignments = [];
  List<Session> sessions = [];

  bool _isOnOrBeforeToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    return !d.isAfter(today);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData();
  }

  void loadData() async {
    final a = await StorageService.loadAssignments();
    final s = await StorageService.loadSessions();

    setState(() {
      assignments = a;
      sessions = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    // Calculate academic week (assuming semester starts on a Monday)
    final now = DateTime.now();
    final semesterStart = DateTime(now.year, 1, 1); // Simplified - should be actual semester start
    final daysSinceStart = now.difference(semesterStart).inDays;
    final academicWeek = (daysSinceStart / 7).ceil();

    final sessionsToCount = sessions.where((s) => _isOnOrBeforeToday(s.date)).toList();
    final presentCount = sessionsToCount.where((s) => s.present).length;
    final attendance = sessionsToCount.isEmpty ? 100.0 : (presentCount / sessionsToCount.length) * 100.0;

    final pendingAssignments = assignments.where((a) => !a.completed).length;
    final dueSoonAssignments = assignments
        .where(
          (a) =>
              !a.completed &&
              a.dueDate.isBefore(DateTime.now().add(const Duration(days: 7))) &&
              a.dueDate.isAfter(DateTime.now().subtract(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final todaysSessions = sessions.where((s) =>
        s.date.day == DateTime.now().day &&
        s.date.month == DateTime.now().month &&
        s.date.year == DateTime.now().year);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ALU Academic Assistant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1e3a8a), Color(0xFF3b82f6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      today,
                      style: TextStyle(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Academic Week $academicWeek",
                      style: TextStyle(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.school_rounded,
                      title: "Attendance",
                      value: "${attendance.toStringAsFixed(1)}%",
                      color: attendance >= 75 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.assignment_rounded,
                      title: "Pending",
                      value: "$pendingAssignments",
                      color: const Color(0xFFf59e0b),
                    ),
                  ),
                ],
              ),

              if (attendance < 75) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Warning: Your attendance is below 75%",
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Today's Sessions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Sessions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3a8a),
                    ),
                  ),
                  Text(
                    "${todaysSessions.length} sessions",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (todaysSessions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No classes scheduled for today",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enjoy your free time! 🎉",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...todaysSessions.map((session) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF1e3a8a).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.class_rounded,
                          color: Color(0xFF1e3a8a),
                        ),
                      ),
                      title: Text(
                        session.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${session.type} • ${session.startTime.format(context)} - ${session.endTime.format(context)}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: session.present
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.radio_button_unchecked, color: Colors.grey[400]),
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Upcoming Assignments
              const Text(
                "Upcoming Assignments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e3a8a),
                ),
              ),

              const SizedBox(height: 12),

              if (dueSoonAssignments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "All caught up!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...dueSoonAssignments.map((assignment) {
                  final daysLeft = assignment.dueDate.difference(DateTime.now()).inDays;
                  final isUrgent = daysLeft <= 2;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUrgent
                              // ignore: deprecated_member_use
                              ? Colors.red.withOpacity(0.1)
                              // ignore: deprecated_member_use
                              : const Color(0xFFf59e0b).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.assignment_rounded,
                          color: isUrgent ? Colors.red : const Color(0xFFf59e0b),
                        ),
                      ),
                      title: Text(
                        assignment.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${assignment.course} • Due: ${DateFormat('MMM d').format(assignment.dueDate)}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isUrgent ? Colors.red : const Color(0xFFf59e0b),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          daysLeft == 0 ? "Today" : "$daysLeft days",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
