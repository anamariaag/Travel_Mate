part of 'itinerary_bloc.dart';

sealed class ItineraryState extends Equatable {
  const ItineraryState();

  @override
  List<Object?> get props => [];
}

// Estado inicial cuando la app inicia o no se ha realizado ninguna acción
class ItineraryInitial extends ItineraryState {
  const ItineraryInitial();
}

// Estado cuando los itinerarios están siendo cargados
class ItinerariesLoading extends ItineraryState {
  const ItinerariesLoading();
}

// Estado cuando los itinerarios han sido cargados exitosamente
class ItinerariesLoaded extends ItineraryState {
  final List<Itinerary> itineraries;

  const ItinerariesLoaded(this.itineraries);

  @override
  List<Object?> get props => [itineraries];
}

// Estado cuando ocurre un error al intentar cargar los itinerarios
class ItineraryError extends ItineraryState {
  final String errorMessage;

  const ItineraryError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// Estado para representar la adición exitosa de un itinerario
class ItineraryAdded extends ItineraryState {
  final Itinerary itinerary;

  const ItineraryAdded(this.itinerary);

  @override
  List<Object?> get props => [itinerary];
}

// Estado para representar la eliminación exitosa de un itinerario
class ItineraryDeleted extends ItineraryState {
  final String itineraryId;

  const ItineraryDeleted(this.itineraryId);

  @override
  List<Object?> get props => [itineraryId];
}
