import 'package:onceinmind/features/journals/data/models/journal_model.dart';

abstract class JournalsState {}

class JournalsInitial extends JournalsState {}

class JournalsLoading extends JournalsState {}

class JournalsLoaded extends JournalsState {
  final List<JournalModel> journals;
  JournalsLoaded(this.journals);
}

class JournalsError extends JournalsState {
  final String message;
  JournalsError(this.message);
}
