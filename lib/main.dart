import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/app_colors.dart';
import 'package:travel_mate/auth/bloc/auth_bloc.dart';
import 'package:travel_mate/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/itinerary/bloc/itinerary_bloc.dart';
import 'package:travel_mate/itinerary/itinerary_repository.dart';
import 'package:travel_mate/itinerary/my_itineraries.dart';
import 'package:travel_mate/login/login.dart';
import 'package:travel_mate/profile/profile_provider.dart';

ThemeData buildAppTheme() {
  return ThemeData(
      // Define the base color scheme
      colorScheme: ColorScheme(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.surfaceColor,
        error: AppColors.errorColor,
        onPrimary: AppColors.onPrimaryColor,
        onSecondary: AppColors.onSecondaryColor,
        onSurface: AppColors.onSurfaceColor,
        onError: AppColors.onErrorColor,
        brightness: Brightness.light,
      ),
      // Configure specific components with custom colors
      appBarTheme: AppBarTheme(
        color: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.onPrimaryColor),
      )
      // Additional theme customization can be added here
      );
}

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
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
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
      theme: buildAppTheme(),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            print("Error al autenticar");
          } else if (state is RegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error while registering'),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is RegisterSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully registered please login'),
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return MyItineraries();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState ||
              state is RegisterErrorState ||
              state is RegisterSuccessState) {
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
