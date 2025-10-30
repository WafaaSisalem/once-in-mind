import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository)
    : super(
        _authRepository.currentUser != null
            ? AuthSignedIn(_authRepository.currentUser!)
            : AuthSignedOut(),
      );

  Future<void> signIn(String email, String password) async {
    await _authenticate(email, password, isSignUp: false);
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, isSignUp: true);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthSignedOut());
  }

  Future<void> _authenticate(
    String email,
    String password, {
    required bool isSignUp,
  }) async {
    emit(AuthLoading());
    try {
      if (email.isEmpty || password.isEmpty) {
        emit(AuthError('Please fill all fields.'));
        return;
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        emit(AuthError('Please enter a valid email.'));
        return;
      }
      if (password.length < 6) {
        emit(AuthError('Password should be more than 6 characters.'));
        return;
      }

      final user = isSignUp
          ? await _authRepository.signUpWithEmail(email, password)
          : await _authRepository.signInWithEmail(email, password);

      if (user != null) {
        emit(AuthSignedIn(user));
      } else {
        emit(AuthError('Authentication failed.'));
      }
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'invalid-email' => 'Email is not valid or badly formatted.',
        'user-disabled' =>
          'This user has been disabled. Please contact support.',
        'email-already-in-use' => 'An account already exists for that email.',
        'operation-not-allowed' =>
          'Operation not allowed. Please contact support.',
        'weak-password' => 'Please enter a stronger password.',
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        _ => 'Incorrect email or password. Please try again.',
      };

      emit(AuthError(message));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }
}
