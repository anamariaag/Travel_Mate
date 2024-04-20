part of 'itinerary_bloc.dart';

sealed class ItineraryEvent extends Equatable {
  const ItineraryEvent();

  @override
  List<Object?> get props => [];
}

// Evento para cargar todos los itinerarios
class LoadItineraries extends ItineraryEvent {}

// Evento para añadir un nuevo itinerario
class AddItinerary extends ItineraryEvent {
  final Itinerary itinerary;

  const AddItinerary(this.itinerary);

  @override
  List<Object?> get props => [itinerary];
}

// Evento para actualizar un itinerario existente
class UpdateItinerary extends ItineraryEvent {
  final Itinerary itinerary;

  const UpdateItinerary(this.itinerary);

  @override
  List<Object?> get props => [itinerary];
}

// Evento para eliminar un itinerario
class DeleteItinerary extends ItineraryEvent {
  final String itineraryId;

  const DeleteItinerary(this.itineraryId);

  @override
  List<Object?> get props => [itineraryId];
}
