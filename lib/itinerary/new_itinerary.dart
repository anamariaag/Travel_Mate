import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/itinerary/bloc/itinerary_bloc.dart';
import 'package:travel_mate/itinerary/provider/new_itineray_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/itinerary/itinerary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// void main() => runApp(NewItinerary());

class NewItinerary extends StatelessWidget {
  NewItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New itinerary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: NewItinerarScreen(),
    );
  }
}

class NewItinerarScreen extends StatefulWidget {
  const NewItinerarScreen({super.key});

  @override
  State<NewItinerarScreen> createState() => _NewItinerarScreenState();
}

class _NewItinerarScreenState extends State<NewItinerarScreen> {
  @override
  void initState() {
    super.initState();
    final countryProvider =
        Provider.of<NewItineraryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewItineraryProvider>().clearDates();
      countryProvider.countryList();
    });
  }

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController tripnameController = TextEditingController();
  final TextEditingController tripdescriptionController =
      TextEditingController();
  final TextEditingController daysController = TextEditingController();

  List<String> selectedCategories = [];
  int budget = 0;
  int days = 0;

  String? _selectedCountry;
  String? _selectedCity;

  void handleCategorySelection(String category, bool value) {
    setState(() {
      if (value) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
    });
  }

  List<String> categories = [
    "Deportes",
    "Diversión",
    "Animales",
    "Naturaleza",
    "Arte",
    "Música",
  ];

  @override
  Widget build(BuildContext context) {
    DateTime? fromDate = context.watch<NewItineraryProvider>().startDate;
    String? onlyDateFrom =
        fromDate != null ? DateFormat('MM-dd-yyyy').format(fromDate) : null;

    DateTime? toDate = context.watch<NewItineraryProvider>().endDate;
    String? onlyDateEnd =
        toDate != null ? DateFormat('MM-dd-yyyy').format(toDate) : null;

    return Scaffold(body: BlocBuilder<ItineraryBloc, ItineraryState>(
      builder: (context, state) {
        return Stack(children: [
          ListView(padding: EdgeInsets.all(16.0), children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Name of the trip",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300.0,
                  child: Container(
                    child: TextField(
                      controller: tripnameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Icon(
                  Icons.place,
                  size: 35.0,
                )
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Short description",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300.0,
                  child: Container(
                    child: TextField(
                      controller: tripdescriptionController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Icon(
                  Icons.document_scanner_rounded,
                  size: 35.0,
                )
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Select trip destination",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text("Select a Country"),
              value: _selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                  _selectedCity = null;
                });
                context
                    .read<NewItineraryProvider>()
                    .cityList(_selectedCountry ?? "");
              },
              items: context.watch<NewItineraryProvider>().isCountriesLoading
                  ? [
                      DropdownMenuItem(
                          value: '',
                          child: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 8),
                              Text("Loading..."),
                            ],
                          ))
                    ]
                  : (context.watch<NewItineraryProvider>().countries ?? [])
                      .map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(), // Populate the dropdown with country names
            ),
            SizedBox(
              height: 12.0,
            ),
            SizedBox(
              width: 200.0,
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text("Select a City"),
                value: _selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = null;
                    _selectedCity = newValue;
                  });
                },
                items: context.watch<NewItineraryProvider>().isCitiesLoading
                    ? [
                        DropdownMenuItem(
                            value: '',
                            child: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 8),
                                Text("Loading..."),
                              ],
                            ))
                      ]
                    : (context.watch<NewItineraryProvider>().cities ?? [])
                        .map((city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(), // Populate the dropdown with country names
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Define budget",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150.0,
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                          prefixText: '\$',
                          suffixText: '.00',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8.0)),
                      onChanged: (value) {
                        setState(() {
                          budget = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Icon(
                  Icons.monetization_on_rounded,
                  size: 35.0,
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("¿Cúanto días planeas viajar?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Fecha de inicio: ${fromDate != null ? onlyDateFrom : 'No seleccionada'}",
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () => context
                            .read<NewItineraryProvider>()
                            .selectStartDate(context),
                      ),
                      ListTile(
                        title: Text(
                          "Fecha de fin: ${toDate != null ? onlyDateEnd : 'No seleccionada'}",
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () => context
                            .read<NewItineraryProvider>()
                            .selectEndDate(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Likes and Interests",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Wrap(
              children: [
                for (var category in categories)
                  SwitchListTile(
                    title: Text(category),
                    value: selectedCategories.contains(category),
                    onChanged: (value) {
                      handleCategorySelection(category, value);
                    },
                  ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> places = [];
                  String place = "${_selectedCountry} , ${_selectedCity}";

                  //First request the gpt answer with the itinerary (touristic places).
                  await context.read<NewItineraryProvider>().postgptItinerary(
                      place, onlyDateFrom!, onlyDateEnd!, budget.toString());

                  List<dynamic> localgptItinerary =
                      context.read<NewItineraryProvider>().gptItinerary!;

                  for (var item in localgptItinerary) {
                    Map<String, dynamic> individualplace = {
                      "done": false,
                      "start": Timestamp.fromDate(DateFormat("MM-dd-yyyy HH:mm")
                          .parse("${item['date']} ${item['hour']}")),
                      "location": GeoPoint(
                          double.parse((item['location'][0]).toString()),
                          double.parse((item['location'][1]).toString())),
                      "title": item['description'],
                    };
                    places.add(individualplace);

                    // print(item['date']);
                    // print(item['hour']);
                    // print(item['location'][0]);
                    // print(item['location'][1]);
                    // print(item['description']);
                  }

                  // print(places);

                  //after getting response, push the build object (gpt answer included) to firestore.
                  // Map<String, dynamic> itineraryContent = {};

                  // itineraryContent = {
                  //   "description": tripdescriptionController.text,
                  //   "title": tripnameController.text,
                  //   "userId": FirebaseAuth.instance.currentUser!.uid,
                  //   "start": Timestamp.fromDate(fromDate ?? DateTime.now()),
                  //   "end": Timestamp.fromDate(toDate ?? DateTime.now()),
                  //   "duration": (toDate!.difference(fromDate!)).inDays + 1,
                  //   "places": places,
                  // };

                  Itinerary finalIntinerary = Itinerary(
                      id: FirebaseAuth.instance.currentUser!.uid,
                      title: tripnameController.text,
                      description: tripdescriptionController.text,
                      start: fromDate!,
                      end: toDate!,
                      places: places,
                      duration: (toDate.difference(fromDate)).inDays + 1);

                  BlocProvider.of<ItineraryBloc>(context)
                      .add(AddItinerary(finalIntinerary));
                  Navigator.of(context).pop();
                  // prompt a snackbar to the user, successful or failed.
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Create New Trip")],
                )),
            SizedBox(
              height: 16.0,
            ),
            if (context.watch<NewItineraryProvider>().isgptLoading)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("GPT creating Itinerary..."),
                    SizedBox(
                      width: 10.0,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
          ]),
        ]);
      },
    ));
  }
}
