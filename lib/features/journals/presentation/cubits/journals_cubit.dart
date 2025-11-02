import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/data/repositories/journal_repository.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';

class JournalsCubit extends Cubit<JournalsState> {
  final JournalRepository _journalRepository;
  final AuthRepository _authRepository;
  JournalsCubit(this._journalRepository, this._authRepository)
    : super(JournalsInitial());
  get userId => _authRepository.currentUser?.uid;
  Future<void> fetchJournals() async {
    if (state is JournalsLoading || state is JournalsLoaded) return;

    emit(JournalsLoading());
    try {
      final List<JournalModel> journals = await _journalRepository
          .getAllJournals(userId);

      emit(JournalsLoaded(journals));
    } catch (e) {
      emit(JournalsError(e.toString()));
    }
  }

  Future<void> addJournal(JournalModel journal) async {
    try {
      await _journalRepository.addJournal(userId, journal);
      if (state is JournalsLoaded) {
        final currentJournals = (state as JournalsLoaded).journals;
        emit(JournalsLoaded([journal, ...currentJournals]));
      } else {
        await fetchJournals();
      }
    } catch (e) {
      emit(JournalsError('Failed to add journal'));
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
