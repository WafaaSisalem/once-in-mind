import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onceinmind/core/constants/app_collections.dart';
import 'package:onceinmind/features/auth/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(UserModel userModel) async {
    await _firestore
        .collection(AppCollections.user)
        .doc(userModel.id)
        .set(userModel.toMap());
  }

  Future<UserModel> getUserData(String userId) async {
    DocumentSnapshot doc = await _firestore
        .collection(AppCollections.user)
        .doc(userId)
        .get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  updateUserData(UserModel userModel) async {
    await _firestore
        .collection(AppCollections.user)
        .doc(userModel.id)
        .update(userModel.toMap());
  }
}
