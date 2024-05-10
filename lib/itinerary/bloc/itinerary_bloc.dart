import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_mate/itinerary/itinerary.dart';
import 'package:travel_mate/itinerary/itinerary_repository.dart';

part 'itinerary_event.dart';
part 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final ItineraryRepository _itineraryRepository;

  ItineraryBloc(this._itineraryRepository) : super(ItineraryInitial()) {
    on<LoadItineraries>(_onLoadItineraries);
    on<AddItinerary>(_onAddItinerary);
    on<UpdateItinerary>(_onUpdateItinerary);
    on<DeleteItinerary>(_onDeleteItinerary);
  }

  Future<void> _onLoadItineraries(
      LoadItineraries event, Emitter<ItineraryState> emit) async {
    emit(ItinerariesLoading());
    try {
      final itineraries = await _itineraryRepository.getItineraries();
      emit(ItinerariesLoaded(itineraries));
    } catch (e) {
      emit(ItineraryError('Failed to load itineraries: $e'));
    }
  }

  Future<void> _onAddItinerary(
      AddItinerary event, Emitter<ItineraryState> emit) async {
    try {
      await _itineraryRepository.addItinerary(event.itinerary);
      emit(ItineraryAdded(event.itinerary));
      final itineraries = await _itineraryRepository.getItineraries();
      emit(ItinerariesLoaded(itineraries));
    } catch (e) {
      emit(ItineraryError('Failed to add itinerary: $e'));
    }
  }

  Future<void> _onUpdateItinerary(
      UpdateItinerary event, Emitter<ItineraryState> emit) async {
    try {
      await _itineraryRepository.updateItinerary(event.itinerary);
      emit(ItinerariesLoaded(await _itineraryRepository
          .getItineraries())); // Reloads all to update the UI
    } catch (e) {
      emit(ItineraryError('Failed to update itinerary: $e'));
    }
  }

  Future<void> _onDeleteItinerary(
      DeleteItinerary event, Emitter<ItineraryState> emit) async {
    try {
      await _itineraryRepository.deleteItinerary(event.itineraryId);
      emit(ItineraryDeleted(event.itineraryId));
      final itineraries = await _itineraryRepository.getItineraries();
      emit(ItinerariesLoaded(itineraries));
    } catch (e) {
      emit(ItineraryError('Failed to delete itinerary: $e'));
    }
  }
}
