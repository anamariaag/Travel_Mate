import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // true -> go home page
  // false -> go login page
  bool isAlreadyAuthenticated() {
    // check if the user is authenticated
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    // Google user signout
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    // Firebase user signout
    await _auth.signOut();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle sign in errors
      print("Failed to sign in: $e");
      throw e; // Propagate the error back to the caller for handling
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      print(">> User email: ${googleUser.email}");
      print(">> User email: ${googleUser.displayName}");
      print(">> User email: ${googleUser.photoUrl}");

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Verificar si el usuario ya tiene un documento en Firestore
      final userId = _auth.currentUser!.uid;
      final userDocSnapshot =
          await _firestore.collection('users').doc(userId).get();

      // Si no existe un documento para este usuario, crear uno
      if (!userDocSnapshot.exists) {
        final firstName = googleUser.displayName!.split(' ')[0];
        final lastName = googleUser.displayName!.split(' ')[1];
        final email = googleUser.email;

        await createUserDocument(
            userId, email, firstName, lastName, 'No data', 'No data', '');
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      throw e;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error during registration: $e");
      throw e;
    }
  }

  Future<void> createUserDocument(
      String userId,
      String email,
      String firstName,
      String lastName,
      String country,
      String dob,
      String profileImageUrl) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'dob': dob,
        'profileImageUrl': profileImageUrl
      });
    } catch (e) {
      print("Error creating user document: $e");
      throw e;
    }
  }
}
