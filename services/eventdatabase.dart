import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {

  // Create Event
  static Future<void> createEvent(
      String id, Map<String, dynamic> addEventDetails) async {

    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .set(addEventDetails);
  }

  // Update Event
  static Future<void> updateEvent(
      String id, Map<String, dynamic> updateEventDetails) async {

    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .update(updateEventDetails);
  }

  // Delete Event (Good to add)
  static Future<void> deleteEvent(String id) async {

    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .delete();
  }
}