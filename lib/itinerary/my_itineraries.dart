import 'package:flutter/material.dart';
import 'package:travel_mate/itinerary/new_itinerary.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Itineraries",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: itineraries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(itineraries[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Delete'),
                      content: Text(
                          'Are you sure you want to delete this itinerary?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewItinerary()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
