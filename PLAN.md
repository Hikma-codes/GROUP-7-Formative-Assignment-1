# Implementation Plan for ALU Academic Assistant

## Current State Analysis

### What's Already Implemented:
- ✅ Dashboard with today's date, sessions list, assignments list
- ✅ Attendance percentage display with color warning (< 75%)
- ✅ Pending assignments count
- ✅ Assignments creation (title, due date, course, priority)
- ✅ Sessions creation (title, date, start/end time)
- ✅ Mark assignments complete/incomplete
- ✅ Record attendance for sessions
- ✅ Delete assignments and sessions
- ✅ Storage service for persistence

### What's Missing:
1. Dashboard: Current academic week display
2. Session model: Location field (optional)
3. Session types: Class, Mastery Session, Study Group, PSL Meeting
4. Assignments: create_file/Edit functionality
5. Sessions: create_file/Edit functionality

## Implementation Plan

### Phase 1: Model Updates
- [ ] Update `Session` model to add `location` field (optional)
- [Service` to handle ] Update `Storage new location field
- [ ] Update session types to match requirements

### Phase 2: Dashboard Updates
- [ ] Add academic week calculation and display
- [ ] Add visual warning indicator for low attendance

### Phase 3: Assignment Screen Updates
- [ ] Add edit functionality for assignments
- [ ] Pre-fill dialog with existing assignment data

### Phase 4: Schedule Screen Updates
- [ ] Add location field to add session dialog
- [ ] Add edit functionality for sessions
- [ ] Pre-fill dialog with existing session data
- [ ] Allow editing attendance status

## Files to Modify:
1. `lib/models/session.dart` - Add location field
2. `lib/services/storage_service.dart` - Handle location in serialization
3. `lib/screens/dashboard_screen.dart` - Add academic week, improve warnings
4. `lib/screens/assignments_screen.dart` - Add edit functionality
5. `lib/screens/schedule_screen.dart` - Add location field and edit functionality

