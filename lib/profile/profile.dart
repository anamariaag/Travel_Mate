import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/auth/bloc/auth_bloc.dart';
import 'package:travel_mate/profile/edit_profile.dart';
import 'package:travel_mate/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false)
        .loadUserData()
        .catchError((error) {
      print('Error loading user data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
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
          final userData = profileProvider.userData;
          final isLoading = profileProvider.isLoading;

          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: userData.profileImageUrl.isNotEmpty
                          ? NetworkImage(userData.profileImageUrl)
                          : AssetImage('assets/avatar.png') as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await profileProvider.takePicture();
                      },
                      child: Text(
                        'Edit Picture',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userData.email.split('@').first,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userData.email,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Full Name"),
                    subtitle:
                        Text("${userData.firstName} ${userData.lastName}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Location"),
                    subtitle: Text(userData.country),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text("Date of Birth"),
                    subtitle: Text(userData.dob),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => (EditProfilePage()))));
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignOutEvent());
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
