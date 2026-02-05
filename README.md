ALU Academic Assistant (Flutter)

A simple Flutter app with a focus on students. It assists you in staying organized in three major aspects: assignments, studying, and attendance management.

What it assists you in doing:
- Managing your upcoming assignments
- Organizing your study sessions
- Monitoring your attendance and calculating your overall attendance percentage

Major Features:
1) Home Dashboard:
- Displays the current date and your position within the academic week
- Displays today’s sessions
- Draws attention to tasks that are due this week
- Displays your overall attendance percentage
- Sends a reminder if your attendance falls below 75%
- Displays the overall number of due assignments

2) Assignment Management:
- Creates new assignments
- Views all assignments
- Marks assignments as completed
- Edits assignments
- Deletes assignments

3) Session Scheduling:
- Creates new study sessions
- Views all sessions
- Tracks attendance for each session
- Edits sessions
- Deletes sessions

Session Types:
- Class
- Mastery Session
- Study Group
- PSL Meeting
- Automatically calculates attendance percentages based on previous sessions and the current one
- Notifies you when attendance drops below 75%
- Maintains a record of attendance

Technical Notes

Navigation
- The app employs a BottomNavigationBar with three pages: Dashboard, Assignments, Schedule

Data Storage
- The app employs shared_preferences to store assignments and sessions, keeping it light

Stored Data
- assignments: title, course, due date, priority, done
- sessions: title, date, start time, end time, type, location, present/absent

Project Structure

Main Folders
- lib/screens/
  - dashboard_screen.dart
  - assignments_screen.dart
  - schedule_screen.dart
- lib/models/
  - assignment.dart
  - session.dart
- lib/services/
  - storage_service.dart

Getting Started

Prerequisites
- Make sure Flutter is installed
- Have an emulator, simulator, or physical device at hand

Run
1. Get dependencies
   flutter pub get

2. Run the application
   flutter run

Usage Tips
- Begin by creating sessions and marking yourself as Present or Absent
- Then create assignments and mark them as done as you complete them

Known Limitations
- The academic week begins with the semester
- If you want the exact date, you can set the semester start date in the app settings
