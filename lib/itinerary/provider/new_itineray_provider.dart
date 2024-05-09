import 'dart:ffi';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class NewItineraryProvider with ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String>? _countries;
  List<String>? _cities;
  bool _isCountriesLoading = false;
  bool _isCitiesLoading = false;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<String>? get countries => _countries;
  List<String>? get cities => _cities;
  bool get isCountriesLoading => _isCountriesLoading;
  bool get isCitiesLoading => _isCitiesLoading;

  String gptPrompt = """ """;

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

  void clearDates() {
    _startDate = null;
    _endDate = null;
    notifyListeners(); // Notify listeners to update UI
  }
}
