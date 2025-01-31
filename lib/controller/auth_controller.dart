import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events for AuthBloc
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;

  SignupEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent {}

// States for AuthBloc
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    // Login Event
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated());
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password. Please try again.';
        } else {
          errorMessage = 'An error occurred. Please try again later.';
        }
        emit(AuthError(errorMessage));
      } catch (e) {
        emit(AuthError('An unexpected error occurred. Please try again.'));
      }
    });

    // Signup Event
    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated());
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use. Please log in.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak. Please choose a stronger one.';
        } else {
          errorMessage = 'An error occurred. Please try again later.';
        }
        emit(AuthError(errorMessage));
      } catch (e) {
        emit(AuthError('An unexpected error occurred. Please try again.'));
      }
    });

    // Logout Event
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError('Failed to log out. Please try again.'));
      }
    });
  }
}