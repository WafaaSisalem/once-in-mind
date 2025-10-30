import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';

class JournalsPage extends StatelessWidget {
  const JournalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      builder: (context, state) {
        if (state is JournalsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is JournalsLoaded) {
          if (state.journals.isEmpty) {
            return const Center(
              child: Text('No journals yet.', style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.journals.length,
            itemBuilder: (context, index) {
              final journal = state.journals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    journal.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    journal.date.toString(),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<JournalsCubit>().deleteJournal(journal.id);
                    },
                  ),
                ),
              );
            },
          );
        }

        if (state is JournalsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        return const Center(child: Text('No data.'));
      },
    );
    // return BlocBuilder<JournalsCubit, JournalsState>(
    //   builder: (context, state) => Center(
    //     child: state is JournalsLoading
    //         ? const CircularProgressIndicator()
    //         : state is JournalsLoaded
    //         ? Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: state.journals
    //                 .map((journal) => Text(journal.content))
    //                 .toList(),
    //           )
    //         : Text(state is JournalsError ? state.message : ''),
    //   ),
    // );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Calendar Page'));
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Map Page'));
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Gallery Page'));
  }
}
