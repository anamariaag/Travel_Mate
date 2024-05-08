import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_mate/itinerary/itinerary.dart';

class ItineraryRepository {
  final FirebaseFirestore firestore;

  ItineraryRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  // Método para obtener todos los itinerarios
  Future<List<Itinerary>> getItineraries() async {
    try {
      // Accedemos a la colección 'itinerary'
      QuerySnapshot querySnapshot = await firestore
          .collection('itinerary')
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      print("itinerarios");
      print(querySnapshot);
      // Convertimos los resultados en una lista de objetos Itinerary
      return querySnapshot.docs
          .map((doc) => Itinerary.fromSnapshot(doc))
          .toList();
    } catch (e) {
      // Manejo de errores
      throw Exception('Error fetching itineraries: $e');
    }
  }

  // Método para añadir un nuevo itinerario
  Future<void> addItinerary(Itinerary itinerary) async {
    try {
      // Añadimos el nuevo itinerario a la colección 'itinerary'
      await firestore.collection('itinerary').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'id': itinerary.id,
        'title': itinerary.title,
        'description': itinerary.description,
        'start': itinerary.start,
        'end': itinerary.end,
        'places': itinerary
            .places // Asegúrate de que el tipo de fecha sea compatible con Firestore
      });
    } catch (e) {
      throw Exception('Failed to add itinerary: $e');
    }
  }

  // Método para actualizar un itinerario existente
  Future<void> updateItinerary(Itinerary itinerary) async {
    try {
      await firestore.collection('itinerary').doc(itinerary.id).update({
        'title': itinerary.title,
        'description': itinerary.description,
        'start': itinerary.start,
        'end': itinerary.end,
        'places': itinerary
      });
    } catch (e) {
      throw Exception('Failed to update itinerary: $e');
    }
  }

  // Método para eliminar un itinerario
  Future<void> deleteItinerary(String itineraryId) async {
    try {
      await firestore.collection('itinerary').doc(itineraryId).delete();
    } catch (e) {
      throw Exception('Failed to delete itinerary: $e');
    }
  }
}
