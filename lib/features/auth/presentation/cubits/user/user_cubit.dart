import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/auth/data/repositories/user_repository.dart';
import 'package:onceinmind/features/auth/data/models/user_model.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  UserCubit(this._userRepository, this._authRepository) : super(UserInitial());
  get masterPassword async {
    final user = _authRepository.currentUser;
    final UserModel usermodel = await getUserData(user!.uid);
    return usermodel.masterPassword;
  }

  saveUserData(UserModel userModel) async {
    emit(UserLoading());
    try {
      await _userRepository.saveUserData(userModel);
      emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError('Failed to save user data.'));
    }
  }

  Future<UserModel> getUserData(String id) async {
    UserModel? userModel;
    emit(UserLoading());
    try {
      userModel = await _userRepository.getUserData(id);
      emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError('Failed to fetch user data.'));
    }
    if (userModel != null) {
      return userModel;
    } else {
      throw Exception('User data not found.');
    }
  }

  void updateUserData(UserModel userModel) async {
    emit(UserLoading());
    try {
      await _userRepository.updateUserData(userModel);
      emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError('Failed to update user data.'));
    }
  }
}
