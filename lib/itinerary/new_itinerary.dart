import 'package:flutter/material.dart';

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
  final TextEditingController destinyController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  List<String> selectedCategories = [];

  int budget = 0;
  int days = 0;

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
    "Comida",
    "Naturaleza",
    "Arte",
    "Tecnología",
    "Música",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(children: [
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Ingresa tu lugar de destino",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    controller: destinyController,
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
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Define tu presupuesto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        suffixText: " días",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8.0)),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Icon(
                Icons.calendar_month,
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
              Text("Intereses y gustos",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        ]),
      ),
    );
  }
}
