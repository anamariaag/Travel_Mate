import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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
          '${itinerary!.title}',
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
      duration: 2,
      description: "description",
      start: DateTime.now(),
      end: DateTime.now(),
      places: List.empty());

  ItineraryDetailsScreen({required this.itinerary});

  @override
  State<ItineraryDetailsScreen> createState() => _ItineraryDetailsScreenState();
}

class _ItineraryDetailsScreenState extends State<ItineraryDetailsScreen> {
  List<DateTime> _generateDateOptions(DateTime start, DateTime end) {
    List<DateTime> options = [];
    DateTime currentDate = DateTime.utc(start.year, start.month, start.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      options.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1)); // Avanza un día
    }
    return options;
  }

  List<Map<String, dynamic>> _filterPlacesByDate(
      DateTime day, List<Map<String, dynamic>> itineraries) {
    List<Map<String, dynamic>> places = [];

    for (var place in itineraries) {
      DateTime date = place['start'].toDate();
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        places.add(place);
      }
    }

    return places;
  }

  List<Map<String, dynamic>> _datePlaces = [];
  bool _acceptTerms = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Expanded(
                child: Text(
                  'Description: ${widget.itinerary.description}',
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Lugares a Visitar:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<DateTime>(
            value: _selectedDate, // Opción seleccionada actualmente
            onChanged: (newValue) {
              setState(() {
                _selectedDate = newValue!; // Actualiza la opción seleccionada
                _datePlaces =
                    _filterPlacesByDate(newValue, widget.itinerary.places);
              });
            },
            items: _generateDateOptions(
                    widget.itinerary.start, widget.itinerary.end)
                .map((DateTime value) {
              return DropdownMenuItem<DateTime>(
                  value: value,
                  child: Text(DateFormat('dd/MM')
                      .format(value)) // Widget que representa la opción
                  );
            }).toList(),
          ),
          SizedBox(height: 10),
          Container(
            height: 250, // Altura de la caja
            child: ListView.builder(
              itemCount: _datePlaces!.length,
              itemBuilder: (BuildContext context, int index) {
                final place = _datePlaces![index];
                return ListTile(
                  leading: IconButton(
                    onPressed: () => _showMapDialog(context, place['location']),
                    icon: Icon(Icons.place),
                  ),
                  title: Text('${place['title']}'),
                  subtitle: Text(
                    "${DateFormat('HH:mm a').format(place['start'].toDate())}",
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  trailing: Checkbox(
                    activeColor: Colors.blue,
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Lógica para compartir el viaje
                },
                child: Text('Compartir'),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

void _showMapDialog(BuildContext context, GeoPoint geoPoint) async {
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition();

  LatLng userLatLng = LatLng(position.latitude, position.longitude);
  LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location on Map'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: FlutterMap(
                options: MapOptions(center: latLng, zoom: 16.0),
                children: [
                  TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayer(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latLng,
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: userLatLng,
                      builder: (ctx) => Container(
                        child:
                            Icon(Icons.person_pin_circle, color: Colors.blue),
                      ),
                    ),
                  ])
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
  } else if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location on Map'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: FlutterMap(
                options: MapOptions(center: latLng, zoom: 16.0),
                children: [
                  TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayer(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latLng,
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    )
                  ])
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
}
