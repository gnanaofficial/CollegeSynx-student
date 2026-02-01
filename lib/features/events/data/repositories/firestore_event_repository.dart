import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event.dart';
import '../../../../domain/entities/student.dart'; // Core student entity

class FirestoreEventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreEventRepository();

  Future<List<Event>> getAllEvents() async {
    try {
      // Query specific collection path
      final querySnapshot = await _firestore
          .collection('collegesynx/main/events')
          .get();

      // Note: Ideally, to check if isRegistered, we should also fetch registrations for this student.
      // But for now, we returning false for isRegistered to avoid N+1 queries on list load
      // unless we implement a smarter caching/query strategy.
      // Or we can simple check if the student has a registration in subcollection?
      // Since we can't do a collection group query easily without permissions/index,
      // we might just list events.

      return querySnapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<void> registerForEvent(Event event, Student student) async {
    final eventRef = _firestore.doc('collegesynx/main/events/${event.id}');
    final registrationsRef = eventRef.collection('registrations');

    final docRef = registrationsRef.doc(); // Auto-ID for the doc
    final registrationId = docRef.id;

    final now = DateTime.now();

    final registrationData = {
      'amountPaid': 0,
      'checkInStatus': "pending",
      'checkInTime': null,
      'createdAt': Timestamp.fromDate(now),
      'createdBy': student.id,
      'createdByName': student.name,
      'customFieldValues': {},
      'department': student.program,
      'email': '', // student.email not available
      'emailSent': false,
      'eventId': event.id,
      'eventName': event.title,
      'importBatchId': null,
      'paymentStatus': "pending",
      'phone': '', // student.phoneNumber not available
      'qrCode': "",
      'qrGenerated': false,
      'registrationId': registrationId,
      'section': "", // Fallback as Student entity might lack section
      'source': "app",
      'status': "approved",
      'studentName': student.name,
      'studentRollNo': student.id,
      'updatedAt': Timestamp.fromDate(now),
      'year': "1", // Fallback
    };

    print(
      'DEBUG: Attempting registration for event: ${event.id}, student: ${student.id}',
    );
    try {
      await _firestore.runTransaction((transaction) async {
        final eventSnapshot = await transaction.get(eventRef);
        if (!eventSnapshot.exists) {
          throw Exception("Event does not exist!");
        }

        // Increment registeredCount
        // (Using optimistic update: read current, update)
        // Note: FieldValue.increment is better but inside transaction we can read/write.
        final currentCount = eventSnapshot.data()?['registeredCount'] ?? 0;
        final capacity = eventSnapshot.data()?['capacity'] ?? 0;

        if (capacity > 0 && currentCount >= capacity) {
          throw Exception("Event is full!");
        }

        transaction.update(eventRef, {
          'registeredCount': currentCount + 1,
          'hasRegistrations': true,
        });

        transaction.set(docRef, registrationData);
      });
      print(
        'DEBUG: Registration transaction completed successfully for ${event.id}',
      );
    } catch (e) {
      print('DEBUG: Registration transaction failed: $e');
      rethrow;
    }
  }
}
