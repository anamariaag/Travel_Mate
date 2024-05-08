import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/auth/bloc/auth_bloc.dart';
import 'package:travel_mate/firebase_options.dart';
import 'package:travel_mate/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/itinerary/bloc/itinerary_bloc.dart';
import 'package:travel_mate/itinerary/itinerary_repository.dart';
import 'package:travel_mate/login/login.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/itinerary/provider/new_itineray_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
        BlocProvider(create: (_) => ItineraryBloc(ItineraryRepository())),
        ChangeNotifierProvider(
          create: (context) => NewItineraryProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Mate',
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            print("Error al autenticar");
          } else if (state is RegisterSuccessState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return Login();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
