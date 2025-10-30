import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/data/repositories/user_repository.dart';
import 'package:onceinmind/features/auth/data/models/user_model.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  saveUserData(UserModel userModel) async {
    emit(UserLoading());
    try {
      await _userRepository.saveUserData(userModel);
      emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError('Failed to save user data.'));
    }
  }

  void getUserData(String id) async {
    emit(UserLoading());
    try {
      final userModel = await _userRepository.getUserData(id);
      emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError('Failed to fetch user data.'));
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
