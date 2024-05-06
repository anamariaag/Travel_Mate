import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/itinerary/bloc/itinerary_bloc.dart';
import 'package:travel_mate/itinerary/itinerary_details.dart';
import 'package:travel_mate/itinerary/new_itinerary.dart';
import 'package:travel_mate/profile/profile.dart';

class MyItineraries extends StatelessWidget {
  MyItineraries({Key? key});

  // Example itinerary data
  final List<String> itineraries = [
    'Itinerary 1',
    'Itinerary 2',
    'Itinerary 3',
    'Itinerary 4',
    'Itinerary 5',
  ];

  @override
  Widget build(BuildContext context) {
    context.read<ItineraryBloc>().add(LoadItineraries());
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "My Itineraries",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                // Aquí manejas lo que sucede cuando se presiona el botón.
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => (Profile()))));
              },
            ),
          ]),
      body: BlocBuilder<ItineraryBloc, ItineraryState>(
        builder: (context, state) {
          if (state is ItinerariesLoading) {
            return CircularProgressIndicator();
          } else if (state is ItinerariesLoaded) {
            return ListView.builder(
              itemCount: state.itineraries.length,
              itemBuilder: (BuildContext context, int index) {
                final itinerary = state.itineraries[index];
                return ListTile(
                  title: Text(itinerary.title),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) =>
                            (ItineraryDetails(itinerary: itinerary)))));
                  }, // Asegúrate de que 'title' es parte de tu modelo de Itinerary
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _showDeleteDialog(context, itinerary.id),
                  ),
                );
              },
            );
          } else if (state is ItineraryError) {
            return Text('Error: ${state.errorMessage}');
          } else {
            return Center(child: Text('No itineraries available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewItinerary()));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String itineraryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this itinerary?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Aquí, dispara el evento de eliminación usando el BLoC
                BlocProvider.of<ItineraryBloc>(context)
                    .add(DeleteItinerary(itineraryId));
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
