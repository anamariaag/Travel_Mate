import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final List<Map<String, dynamic>> places;

  Itinerary(
      {required this.id,
      required this.title,
      required this.description,
      required this.start,
      required this.end,
      required this.places});

  // Método para crear un objeto Itinerary desde un DocumentSnapshot
  factory Itinerary.fromSnapshot(DocumentSnapshot snapshot) {
    //print(snapshot['places']);
    var itemList = snapshot['places'] as List<dynamic>?;
    List<Map<String, dynamic>> maps = List.empty();
    if (itemList != null) {
      maps = itemList.map((item) => item as Map<String, dynamic>).toList();
    }
    return Itinerary(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        start: snapshot['start'].toDate(),
        end: snapshot['end'].toDate(),
        places: maps);
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  // Método para crear una Location desde un GeoPoint
  factory Location.fromGeoPoint(GeoPoint geoPoint) {
    return Location(latitude: geoPoint.latitude, longitude: geoPoint.longitude);
  }
}
