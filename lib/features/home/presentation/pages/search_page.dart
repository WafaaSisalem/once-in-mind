import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/journal_item.dart';

import '../../../../core/config/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<JournalModel>? searchResult;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppbarWidget(
            titlePlace: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 28,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Expanded(
                  child: TextField(
                    cursorColor: AppColors.hintColor,
                    onChanged: (value) {
                      searchResult = context.read<JournalsCubit>().search(
                        value,
                      );
                      setState(() {});
                    },
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintStyle: Theme.of(context).textTheme.displaySmall!
                          .copyWith(color: AppColors.hintColor),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search your memories...',
                    ),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.white,
                    ), //
                  ),
                ),
              ],
            ),
            actions: [],
          ),
          body: searchResult == null
              ? Center(
                  child: FallbackWidget(
                    text: 'Search your memories...',
                    image: AppAssets.svgNoJournal,
                  ),
                )
              : searchResult!.isEmpty
              ? Center(child: FallbackWidget.noSearchResult())
              : ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  padding: const EdgeInsets.all(16),
                  itemCount: searchResult!.length,
                  itemBuilder: (context, index) =>
                      JournalItem(journal: searchResult![index]),
                ),
        );
      },
    );
  }
}
