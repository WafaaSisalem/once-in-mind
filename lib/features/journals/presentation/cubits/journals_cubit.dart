import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/data/repositories/journal_repository.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/services/media/supabase_storage_service.dart';

class JournalsCubit extends Cubit<JournalsState> {
  final JournalRepository _journalRepository;
  final AuthRepository _authRepository;
  final SupabaseStorageService _storageService = SupabaseStorageService();
  JournalsCubit(this._journalRepository, this._authRepository)
    : super(JournalsInitial());
  get userId => _authRepository.currentUser?.uid;

  Future<void> fetchJournals() async {
    if (state is JournalsLoaded || state is JournalsLoading) return;
    emit(JournalsLoading());

    try {
      final List<JournalModel> journals = await _journalRepository
          .getAllJournals(userId);

      for (var journal in journals) {
        if (journal.imagesUrls.isNotEmpty) {
          final signedUrls = await _storageService.getSignedUrlsFromPaths(
            journal.imagesUrls,
          );

          journal.signedUrls = signedUrls;
        }
      }

      emit(JournalsLoaded(journals));
    } catch (e) {
      emit(JournalsError(e.toString()));
    }
  }

  Future<void> saveJournal({
    required String content,
    required DateTime date,
    required Status status,
    required List<File> files,
  }) async {
    try {
      emit(JournalsLoading());

      List<String> imagePaths = [];

      if (files.isNotEmpty) {
        imagePaths = await _storageService.uploadImageAndGetPaths(
          files,
          userId,
        );
      }

      final journal = JournalModel(
        id: DateTime.now().toString(),
        content: content,
        date: date,
        imagesUrls: imagePaths,
        isLocked: false,
        location: null,
        status: status.name,
      );

      await _journalRepository.addJournal(userId, journal);

      emit(JournalsInitial());
      await fetchJournals();
    } catch (e) {
      emit(JournalsError('Failed to save journal: $e'));
    }
  }

  Future<void> updateJournal(JournalModel journal) async {
    try {
      await _journalRepository.updateJournal(userId, journal);

      if (state is JournalsLoaded) {
        final currentJournals = (state as JournalsLoaded).journals;

        final updatedList = currentJournals
            .map((j) => j.id == journal.id ? journal : j)
            .toList();

        emit(JournalsLoaded(updatedList));
      } else {
        await fetchJournals();
      }
    } catch (e) {
      emit(JournalsError('Failed to update journal'));
    }
  }

  Future<void> deleteJournal(String journalId) async {
    try {
      await _journalRepository.deleteJournal(userId, journalId);
      if (state is JournalsLoaded) {
        final currentJournals = (state as JournalsLoaded).journals;
        emit(
          JournalsLoaded(
            currentJournals.where((j) => j.id != journalId).toList(),
          ),
        );
      } else {
        await fetchJournals();
      }
    } catch (e) {
      emit(JournalsError('Failed to delete journal'));
    }
  }

  void resetState() {
    emit(JournalsInitial());
  }
}
