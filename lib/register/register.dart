import 'package:flutter/material.dart';

void main() => runApp(Register());

class Register extends StatelessWidget {
  Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _acceptTerms = false;
  String _selectedCountry = 'Seleccionar País';
  List<String> _countries = [
    'Seleccionar País',
    'México',
    'USA',
    'Canada'
  ]; // Lista de países

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hoverColor: Colors.blue),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu apellido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                if (!RegExp(
                        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                    .hasMatch(value)) {
                  return 'Por favor ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              items: _countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountry = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'País',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == 'Seleccionar País') {
                  return 'Por favor selecciona tu país';
                }
                return null;
              },
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.blue,
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  },
                ),
                Text('Aceptar Términos y Condiciones'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfull register!'),
                    ),
                  );
                }
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Cambia el color del botón a azul
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
