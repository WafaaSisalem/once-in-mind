import 'package:equatable/equatable.dart';
import 'package:onceinmind/core/constants/app_keys.dart';

class UserModel extends Equatable {
  final String id;
  final String masterPassword;

  const UserModel({required this.id, this.masterPassword = ''});
  UserModel.fromMap(Map map)
    : id = map[AppKeys.id],
      masterPassword = map[AppKeys.masterPass];

  toMap() {
    return {AppKeys.id: id, AppKeys.masterPass: masterPassword};
  }

  @override
  List<Object?> get props => [id, masterPassword];
}
