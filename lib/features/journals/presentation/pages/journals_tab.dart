import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/loading_widget.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/journal_item.dart';

class JournalsTab extends StatelessWidget {
  const JournalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      bloc: context.read<JournalsCubit>()..fetchJournals(),
      builder: (context, state) {
        if (state is JournalsLoaded) {
          if (state.journals.isEmpty) {
            return Center(child: FallbackWidget.noJouranl());
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            padding: const EdgeInsets.all(16),
            itemCount: state.journals.length,
            itemBuilder: (context, index) {
              final journal = state.journals[index];
              return JournalItem(journal: journal);
            },
          );
        }

        if (state is JournalsError) {
          return Center(
            child: FallbackWidget(
              text: 'Could not load the jouranls',
              image: AppAssets.svgNoJournal,
            ),
          );
        }

        return const LoadingWidget();
      },
    );
  }
}
