import 'package:flutter/material.dart';

void main() => runApp(ItineraryDetails());

class ItineraryDetails extends StatelessWidget {
  ItineraryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Itinerary Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ItineraryDetailsScreen(),
    );
  }
}

class ItineraryDetailsScreen extends StatefulWidget {
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
              'Fecha de Inicio: 10/03/2024',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Fecha de Fin: 20/03/2024',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
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
          child: SingleChildScrollView(
            // Widget desplazable
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Flexible(child: Text('10:00 AM')),
                      Expanded(child: Text('Breakfast')),
                      Expanded(child: Text('Lugar 1')),
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
                  leading: Icon(Icons.place),
                ),
                ListTile(
                  title: Text('Lugar 2'),
                  subtitle: Text('Descripción del lugar 2'),
                  leading: Icon(Icons.place),
                ),
                ListTile(
                  title: Text('Lugar 3'),
                  subtitle: Text('Descripción del lugar 3'),
                  leading: Icon(Icons.place),
                ),
              ],
            ),
          ),
        ),
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
