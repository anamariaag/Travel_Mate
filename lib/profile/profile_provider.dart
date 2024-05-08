import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_mate/profile/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  File? _selectedPicture;

  late UserData _userData = UserData(
      email: '',
      firstName: '',
      lastName: '',
      country: '',
      dob: '',
      profileImageUrl: '');

  bool _isLoading = true;

  UserData get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    print("entre");
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        _userData = UserData(
            email: userSnapshot['email'],
            firstName: userSnapshot['firstName'],
            lastName: userSnapshot['lastName'],
            country: userSnapshot['country'],
            dob: userSnapshot['dob'],
            profileImageUrl: userSnapshot['profileImageUrl']);

        print(_userData);
      } else {
        throw Exception('User data not found in Firestore');
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error loading user data: $error');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData({
    required String firstName,
    required String lastName,
    required String country,
    required String dob,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'dob': dob,
      });

      _userData = UserData(
          email: _userData.email,
          firstName: firstName,
          lastName: lastName,
          country: country,
          dob: dob,
          profileImageUrl: _userData.profileImageUrl);

      notifyListeners();
    } catch (error) {
      print('Error updating user data: $error');
      throw error;
    }
  }

  Future<void> _updateProfileImage(String imageUrl) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });

      _userData = UserData(
          email: _userData.email,
          firstName: _userData.firstName,
          lastName: _userData.lastName,
          country: _userData.country,
          dob: _userData.dob,
          profileImageUrl: imageUrl);
      notifyListeners();
    } catch (error) {
      print('Error updating profile image: $error');
      throw error;
    }
  }

  Future<String> _uploadPictureToStorage() async {
    try {
      if (_selectedPicture == null) return "";
      var stamp = DateTime.now();
      UploadTask task = FirebaseStorage.instance
          .ref("profile/image_${stamp}.png")
          .putFile(_selectedPicture!);
      TaskSnapshot snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading file to storage: ${e.toString()}");
      throw e;
    }
  }

  Future<void> takePicture() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _editPicture();
    } catch (error) {
      print('Error taking picture: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        _selectedPicture = File(pickedFile.path);
      } else {
        print("No image selected");
        _selectedPicture = null;
      }
    } catch (error) {
      print('Error getting image: $error');
      throw error;
    }
  }

  Future<void> _editPicture() async {
    try {
      await _getImage();

      String imageUrl = await _uploadPictureToStorage();

      if (imageUrl != '') {
        await _updateProfileImage(imageUrl);
      }
    } catch (error) {
      print('Error editing picture: $error');
      throw error;
    }
  }
}
