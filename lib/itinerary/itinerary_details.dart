import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/itinerary/itinerary.dart';

void main() => runApp(ItineraryDetails());

class ItineraryDetails extends StatelessWidget {
  Itinerary? itinerary;

  ItineraryDetails({super.key, this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Itinerary Details for  ${itinerary!.title}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ItineraryDetailsScreen(itinerary: itinerary!),
    );
  }
}

class ItineraryDetailsScreen extends StatefulWidget {
  Itinerary itinerary = Itinerary(
      id: "id",
      title: "title",
      description: "description",
      start: DateTime.now(),
      end: DateTime.now(),
      places: List.empty());

  ItineraryDetailsScreen({required this.itinerary});

  @override
  State<ItineraryDetailsScreen> createState() => _ItineraryDetailsScreenState();
}

class _ItineraryDetailsScreenState extends State<ItineraryDetailsScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Start Date: ${DateFormat('EEE, HH:mm, dd/MM/yyyy').format(widget.itinerary.start)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'End Date:  ${DateFormat('EEE, HH:mm, dd/MM/yyyy').format(widget.itinerary.end)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Description: ${widget.itinerary.description}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Lugares a Visitar:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
            height: 300, // Altura de la caja
            child: ListView.builder(
              itemCount: widget.itinerary.places.length,
              itemBuilder: (BuildContext context, int index) {
                final place = widget.itinerary.places[index];
                return ListTile(
                    title: Row(
                      children: [
                        Flexible(
                            child: Text(
                                "${DateFormat('HH:mm a, dd/MM').format(place['start'].toDate())}")),
                        Expanded(child: Text('${place['title']}')),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () =>
                              _showMapDialog(context, place['location']),
                          child: Icon(Icons.place),
                        )),
                        Checkbox(
                          activeColor: Colors.blue,
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    leading: Icon(Icons.place));
              },
            )),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar el viaje
              },
              child: Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para compartir el viaje
              },
              child: Text('Compartir'),
            ),
          ],
        ),
      ]),
    );
  }
}

void _showMapDialog(BuildContext context, GeoPoint geoPoint) {
  LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Location on Map'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: FlutterMap(
              options: MapOptions(center: latLng, zoom: 13.0),
              children: [
                TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
              ]),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
