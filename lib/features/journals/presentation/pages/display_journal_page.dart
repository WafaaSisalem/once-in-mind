import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_stack_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/inline_slider_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class DisplayJournalPage extends StatefulWidget {
  const DisplayJournalPage({super.key, required this.journal});
  final JournalModel journal;

  @override
  State<DisplayJournalPage> createState() => _DisplayJournalPageState();
}

class _DisplayJournalPageState extends State<DisplayJournalPage> {
  late JournalModel _journal;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _journal = widget
        .journal; // لانه ممكن اليوزر يروح عصفحة تعديل الجورنال وهذا التعديل رح ينعكس عالصفحة عندي
    _controller = TextEditingController(text: _journal.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: CustomBackButton(),
        actions: [
          _appBarIcon(
            icon: AppAssets.svgWhiteDelete,
            onTap: () {
              //show Delete Dialog
            },
          ),
          SizedBox(width: 15),
          _appBarIcon(
            icon: _journal.isLocked
                ? AppAssets.svgWhiteUnlock
                : AppAssets.svgWhiteLock,
            onTap: () {
              //lock logic
            },
          ),
          SizedBox(width: 15),
          _appBarIcon(
            icon: AppAssets.svgEditIcon,
            onTap: () async {
              final updatedJournal = await context.pushNamed<JournalModel>(
                AppRoutes.editJournal,
                extra: _journal,
              );

              if (updatedJournal != null) {
                setState(() {
                  _journal = updatedJournal;
                  _controller.text = _journal.content;
                });
              }
            },
          ),
          SizedBox(width: 30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          children: [
            if (_journal.signedUrls?.isNotEmpty ?? false)
              InlineSliderWidget(journal: _journal),

            DateStackWidget(journal: _journal),
            SizedBox(height: 20),
            Expanded(
              child: WritingArea(readOnly: true, controller: _controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarIcon({required Widget icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(width: 18, height: 18, child: icon),
    );
  }
}
