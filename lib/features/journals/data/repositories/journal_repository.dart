import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onceinmind/core/constants/app_collections.dart';
import 'package:onceinmind/core/constants/app_keys.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';

class JournalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JournalModel>> getAllJournals(String userId) async {
    final query = await _firestore
        .collection(AppCollections.user)
        .doc(userId)
        .collection(AppCollections.journal)
        .orderBy(AppKeys.date, descending: true)
        .get();

    return query.docs
        .map((doc) => JournalModel.fromMap(doc.data() as Map))
        .toList();
  }

  Future<void> addJournal(String userId, JournalModel journal) async {
    await _firestore
        .collection(AppCollections.user)
        .doc(userId)
        .collection(AppCollections.journal)
        .doc(journal.id)
        .set(journal.toMap());
  }

  Future<void> updateJournal(String userId, JournalModel journal) async {
    await _firestore
        .collection(AppCollections.user)
        .doc(userId)
        .collection(AppCollections.journal)
        .doc(journal.id)
        .update(journal.toMap());
  }

  Future<void> deleteJournal(String userId, String journalId) async {
    await _firestore
        .collection(AppCollections.user)
        .doc(userId)
        .collection(AppCollections.journal)
        .doc(journalId)
        .delete();
  }
}
