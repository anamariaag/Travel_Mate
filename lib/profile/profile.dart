import 'package:flutter/material.dart';
import 'package:travel_mate/profile/edit_profile.dart';

class Profile extends StatelessWidget {
  Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Username",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "user@example.com",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              "Personal Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Full Name"),
              subtitle: Text("Sample User"),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Location"),
              subtitle: Text("City, Country"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Date of Birth"),
              subtitle: Text("DD/MM/YYYY"),
            ),
            SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
