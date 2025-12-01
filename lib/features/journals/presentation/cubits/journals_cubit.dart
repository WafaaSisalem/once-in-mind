import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/journals/data/models/journal_attachment.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/data/repositories/journal_repository.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';
import 'package:onceinmind/services/supabase_storage_service.dart';

class JournalsCubit extends Cubit<JournalsState> {
  final JournalRepository _journalRepository;
  final AuthRepository _authRepository;
  final SupabaseStorageService _storageService = SupabaseStorageService();
  JournalsCubit(this._journalRepository, this._authRepository)
    : super(JournalsInitial());
  get userId => _authRepository.currentUser?.uid;

  JournalModel? getJournalById(String journalId) {
    if (state is JournalsLoaded) {
      final currentJournals = (state as JournalsLoaded).journals;
      try {
        return currentJournals.firstWhere((journal) => journal.id == journalId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> fetchJournals() async {
    if (state is JournalsLoaded || state is JournalsLoading) return;
    emit(JournalsLoading());

    try {
      final List<JournalModel> journals = await _journalRepository
          .getAllJournals(userId);
      for (var journal in journals) {
        if (journal.imagesUrls.isNotEmpty) {
          //signedurls always null,
          // because were getting the journals from db where
          // we dont store signed urls
          //TODO optimize by fetching signed urls
          if (journal.signedUrls != null &&
              journal.signedUrls!.length == journal.imagesUrls.length) {
            continue; //signedUrls already fetched
          }
          final signedUrls = await _storageService.getSignedUrlsFromPaths(
            journal.imagesUrls, //imagePath not url
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
    required String weather,
    required List<JournalAttachment> attachments,
    required LocationModel? location,
    isLocked = false,
  }) async {
    try {
      emit(JournalsLoading());

      List<String> imagePaths = [];

      final localFiles = attachments
          .where((attachment) => attachment.isLocal && attachment.file != null)
          .map((attachment) => attachment.file!)
          .toList();

      if (localFiles.isNotEmpty) {
        imagePaths = await _storageService.uploadImageAndGetPaths(
          localFiles,
          userId,
        );
      }
      final journal = JournalModel(
        id: DateTime.now().toString(),
        content: content,
        date: date,
        imagesUrls: imagePaths,
        isLocked: isLocked,
        location: location,
        status: status.name,
        weather: weather,
      );

      await _journalRepository.addJournal(userId, journal);
      emit(JournalsInitial());
      await fetchJournals();
    } catch (e) {
      emit(JournalsError('Failed to save journal: $e'));
    }
  }

  Future<JournalModel> updateJournalWithAttachments({
    required JournalModel journal,
    required List<JournalAttachment> attachments,
    required List<String> originalRemotePaths,
  }) async {
    try {
      final keptRemotePaths = attachments
          .where((attachment) => attachment.isRemote)
          .map((attachment) => attachment.storagePath!)
          .toList();

      final removedRemotePaths = originalRemotePaths
          .where((path) => !keptRemotePaths.contains(path))
          .toList();

      if (removedRemotePaths.isNotEmpty) {
        await _storageService.deleteImages(removedRemotePaths);
      }

      final localFiles = attachments
          .where((attachment) => attachment.isLocal && attachment.file != null)
          .map((attachment) => attachment.file!)
          .toList();

      final uploadedPaths = localFiles.isNotEmpty
          ? await _storageService.uploadImageAndGetPaths(localFiles, userId)
          : <String>[];

      final combinedPaths = [...keptRemotePaths, ...uploadedPaths];

      final updatedJournal = journal.copyWith(imagesUrls: combinedPaths);

      await _journalRepository.updateJournal(userId, updatedJournal);

      if (combinedPaths.isNotEmpty) {
        updatedJournal.signedUrls = await _storageService
            .getSignedUrlsFromPaths(combinedPaths);
      } else {
        updatedJournal.signedUrls = [];
      }

      if (state is JournalsLoaded) {
        final currentJournals = (state as JournalsLoaded).journals;

        final updatedList = currentJournals
            .map((j) => j.id == updatedJournal.id ? updatedJournal : j)
            .toList();
        //order by date
        updatedList.sort((a, b) => b.date.compareTo(a.date));

        emit(JournalsLoaded(updatedList));
      }

      return updatedJournal;
    } catch (e) {
      emit(JournalsError('Failed to update journal'));
      rethrow;
    }
  }

  Future<void> deleteJournal(String journalId, List<String> paths) async {
    try {
      await _journalRepository.deleteJournal(userId, journalId);
      _storageService.deleteImages(paths);
      if (state is JournalsLoaded) {
        final currentJournals = (state as JournalsLoaded).journals;
        emit(
          JournalsLoaded(
            currentJournals.where((j) => j.id != journalId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(JournalsError('Failed to delete journal'));
    }
  }

  List<JournalModel> getJournalsByLocation(LocationModel? loc) {
    if (state is JournalsLoaded) {
      final currentJournals = (state as JournalsLoaded).journals;
      final journalsByLocation = currentJournals
          .where(
            (journal) =>
                journal.location != null &&
                journal.location!.address == loc!.address,
          )
          .toList();
      return journalsByLocation;
    }
    return [];
  }

  List<JournalModel> search(String value) {
    if (state is JournalsLoaded) {
      final currentJournals = (state as JournalsLoaded).journals;

      List<JournalModel> searchResult = currentJournals.where((journal) {
        String content = journal.content.toLowerCase();
        String input = value.toLowerCase();
        if (input == '' || journal.isLocked) {
          return false;
        }

        return content.contains(input);
      }).toList();
      return searchResult;
    }
    return [];
  }

  updateJournal(JournalModel journal) async {
    if (state is JournalsLoaded) {
      await _journalRepository.updateJournal(userId, journal);
      final currentJournals = (state as JournalsLoaded).journals;
      final updatedJournals = currentJournals.map((j) {
        if (j.id == journal.id) {
          return journal;
        }
        return j;
      }).toList();
      emit(JournalsLoaded(updatedJournals));
    }
  }

  void resetState() {
    emit(JournalsInitial());
  }
}
