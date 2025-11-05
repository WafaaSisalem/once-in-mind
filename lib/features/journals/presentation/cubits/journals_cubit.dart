import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
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

  // EventList<Event> get calendarEvents {
  //   if (state is! JournalsLoaded) return EventList<Event>(events: {});
  //   final journals = (state as JournalsLoaded).journals;
  //   return EventList<Event>(
  //     events: {
  //       for (final journal in journals)
  //         journal.date: [Event(date: journal.date, title: journal.id)],
  //     },
  //   );
  // }

  // List<JournalModel> getJournalsByDate(DateTime date) {
  //   if (state is JournalsLoaded) {
  //     final journals = (state as JournalsLoaded).journals;
  //     return journals.where((journal) {
  //       return isSameDate(journal.date, date);
  //     }).toList();
  //   }
  //   return [];
  // }

  // bool isSameDate(DateTime a, DateTime b) {
  //   return a.year == b.year && a.month == b.month && a.day == b.day;
  // }

  Future<void> fetchJournals() async {
    if (state is JournalsLoaded || state is JournalsLoading) return;
    emit(JournalsLoading());
    try {
      final List<JournalModel> journals = await _journalRepository
          .getAllJournals(userId);
      print('gettings jouranl');
      emit(JournalsLoaded(journals));
    } catch (e) {
      emit(JournalsError(e.toString()));
    }
  }

  Future<void> addJournal(JournalModel journal) async {
    try {
      await _journalRepository.addJournal(userId, journal);
      emit(
        JournalsInitial(),
      ); //حسب لوجيك الفيتش ما رح تعمل فيتش الا اذا ايرور او انيشيال
      await fetchJournals();
      // ما ضفت عالجورنال الي عنا  لوكالي، لانه ممكن احيانا نختار تاريخ غير ففضلت ياخد البيانات مرتبة بتاريخها من ال الفيرستور
      // if (state is JournalsLoaded) {
      //   final currentJournals = (state as JournalsLoaded).journals;
      //   emit(JournalsLoaded([journal, ...currentJournals]));
      // } else {
      //   await fetchJournals();
      // }
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
