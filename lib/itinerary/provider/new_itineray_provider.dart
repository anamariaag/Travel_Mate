import 'dart:ffi';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class NewItineraryProvider with ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String>? _countries;
  List<String>? _cities;
  List<Map<String, dynamic>>? _gptItinerary;
  bool _isCountriesLoading = false;
  bool _isCitiesLoading = false;
  bool _isgptLoading = false;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<String>? get countries => _countries;
  List<String>? get cities => _cities;
  List<Map<String, dynamic>>? get gptItinerary => _gptItinerary;
  bool get isCountriesLoading => _isCountriesLoading;
  bool get isCitiesLoading => _isCitiesLoading;
  bool get isgptLoading => _isgptLoading;

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _startDate) {
      _startDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _endDate) {
      _endDate = picked;
      notifyListeners();
    }
  }

  Future<void> countryList() async {
    String urlEndpoint = "https://shivammathur.com/countrycity/countries";
    _isCountriesLoading = true;
    notifyListeners(); // Notify that loading started

    Map<String, String> header = {"x-api-key": "API_KEY"};

    // Replace this with your API endpoint
    final response = await get(Uri.parse(urlEndpoint), headers: header);

    if (response.statusCode == 200) {
      // Decode the JSON response into a list of country names
      // final data = (jsonDecode(response.body) as List);
      _countries = List<String>.from(jsonDecode(response.body));

      _isCountriesLoading = false;
      notifyListeners(); // Notify that loading finished
    } else {
      print("No llegué al endpoint");
      print(
          "Error fetching countries: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception("Failed to load countries");
    }
  }

  Future<void> cityList(String countrySelected) async {
    String urlEndpoint =
        "https://shivammathur.com/countrycity/cities/${countrySelected}";
    _isCitiesLoading = true;
    notifyListeners(); // Notify that loading started

    Map<String, String> header = {"x-api-key": "API_KEY"};

    // Replace this with your API endpoint
    final response = await get(Uri.parse(urlEndpoint), headers: header);

    if (response.statusCode == 200) {
      // Decode the JSON response into a list of country names
      // final data = (jsonDecode(response.body) as List);
      _cities = List<String>.from(jsonDecode(response.body));

      _isCitiesLoading = false;
      notifyListeners(); // Notify that loading finished
    } else {
      print("No llegué al endpoint");
      print(
          "Error fetching countries: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception("Failed to load countries");
    }
  }

  Future<void> postgptItinerary(
      String place, String start, String end, String budget) async {
    String gptPrompt = """Create a travel itinerary to the city of ${place} 
It should be a JSON structure:  
- Itinerary Array 
-Every object in the array with everyday information: 'date',  'hour', 'description':name of the place, location: ['latitude, longitude']. 
Do not include meals, only touristic places. 
Skip arrival and return to hotel. 
Trip dates: ${start} - ${end} (follow this date format MM-dd-yyyy)
Budget: ${budget} Mexican pesos 
Only 3 or 4 places per day, hour distributed througout all day
Don´t group by date, leave all the objects on the same level, the date inside each one of them
Don´t give any description extra, just the JSON structrure object """;

    String urlEndpoint =
        "https://travelmategpt.azurewebsites.net/api/gptfunctionhttp?";
    _isgptLoading = true;
    notifyListeners(); // Notify that loading started

    // Replace this with your API endpoint
    final response = await post(Uri.parse(urlEndpoint),
        body: jsonEncode({'message': gptPrompt}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // Decode the JSON response into a list of country names
      // final data = (jsonDecode(response.body) as List);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data.containsKey("completion")) {
        // final completion = data["completion"] as Map<String, dynamic>;
        // final message = completion["message"] as Map<String, dynamic>;
        var content = data["completion"]['message']['content'] as String;
        content = content.replaceAll('```json', '').replaceAll('```', '');

        // print(message);
        print(content);

        // Parse the inner content (this is where the itinerary is)
        // final Map<String, dynamic> itineraryData =
        //     jsonDecode(content) as Map<String, dynamic>;

        final itineraryData = jsonDecode(content) as Map<String, dynamic>;

        print(itineraryData);

        if (itineraryData.containsKey("itinerary")) {
          final rawItinerary = itineraryData["itinerary"] as List<dynamic>;

          _gptItinerary = rawItinerary.map((item) {
            if (item is Map<String, dynamic>) {
              return item;
            } else {
              throw FormatException("Unexpected item type in itinerary");
            }
          }).toList();
        }
      }

      print(_gptItinerary);

      _isgptLoading = false;
      notifyListeners(); // Notify that loading finished
    } else {
      print("No llegué al endpoint");
      print(
          "Error fetching countries: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception("Failed to load countries");
    }
  }

  void clearDates() {
    _startDate = null;
    _endDate = null;
    notifyListeners(); // Notify listeners to update UI
  }
}
