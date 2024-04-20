import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_mate/auth/user_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserAuthRepository _autRepo = UserAuthRepository();
  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerfication);
    on<AnonymousAuthEvent>(_authAnonymous);
    on<GoogleAuthEvent>(_authUser);
    on<SignOutEvent>(_signOut);
    on<SignInEvent>(_signIn);
    on<RegisterEvent>(_register);
  }

  FutureOr<void> _authVerfication(event, emit) {
    // revisar si existe usuario autenticado
    if (_autRepo.isAlreadyAuthenticated()) {
      emit(AuthSuccessState());
    } else {
      emit(UnAuthState());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    // Desloggear usuario
    await _autRepo.signOutGoogleUser();
    await _autRepo.signOutFirebaseUser();
    emit(SignOutSuccessState());
  }

  FutureOr<void> _authUser(event, emit) async {
    emit(AuthAwaitingState());
    try {
      // Loggear usuario
      await _autRepo.signInWithGoogle();
      emit(AuthSuccessState());
    } catch (e) {
      print("Error al autenticar: $e");
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _authAnonymous(event, emit) async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  FutureOr<void> _signIn(SignInEvent event, emit) async {
    emit(AuthAwaitingState());
    try {
      // Sign in with email and password
      await _autRepo.signInWithEmailAndPassword(event.email, event.password);
      emit(AuthSuccessState());
    } catch (e) {
      print("Error authenticating with email and password: $e");
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _register(RegisterEvent event, emit) async {
    emit(AuthAwaitingState());
    try {
      await _autRepo.registerWithEmailAndPassword(event.email, event.password);
      emit(RegisterSuccessState());
      emit(AuthSuccessState());
    } catch (e) {
      print("Error during registration: $e");
      emit(AuthErrorState());
    }
  }
}
