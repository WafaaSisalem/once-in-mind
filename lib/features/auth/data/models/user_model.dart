import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  String masterPassword = '';

  UserModel({required this.id, this.masterPassword = ''});
  UserModel.fromMap(Map map)
    : id = map['id'],
      masterPassword = map['masterPassword'];

  toMap() {
    return {'id': id, 'masterPassword': masterPassword};
  }

  @override
  List<Object?> get props => [id, masterPassword];
}
