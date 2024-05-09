import 'package:flutter/material.dart';
import 'package:travel_mate/profile/profile_provider.dart';
import 'package:travel_mate/profile/user_data.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;

  String _selectedCountry = 'Select Country';
  List<String> _countries = ['Select Country', 'México', 'USA', 'Canada'];

  @override
  void initState() {
    super.initState();

    UserData userData =
        Provider.of<ProfileProvider>(context, listen: false).userData;

    _firstNameController = TextEditingController(text: userData.firstName);
    _lastNameController = TextEditingController(text: userData.lastName);
    _dobController = TextEditingController(text: userData.dob);

    if (_countries.contains(userData.country)) {
      _selectedCountry = userData.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color:
                  Colors.white), // Color específico para el botón de retroceso
          onPressed: () {
            Navigator.pop(
                context); // Esta acción permite regresar a la pantalla anterior
          },
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  items: _countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dobController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await profileProvider.updateUserData(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          country: _selectedCountry,
                          dob: _dobController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Profile updated successfully')),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Failed to update profile: $error')),
                        );
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
