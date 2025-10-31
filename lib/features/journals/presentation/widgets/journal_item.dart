import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/constants/app_strings.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';

class JournalItem extends StatelessWidget {
  const JournalItem({super.key, required this.journal});

  final JournalModel journal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRoutes.displayJournal, extra: journal);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListTile(
          title: Text(
            journal.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            DateFormat(AppStrings.dateFormat).format(journal.date),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<JournalsCubit>().deleteJournal(journal.id);
            },
          ),
        ),
      ),
    );
  }
}
