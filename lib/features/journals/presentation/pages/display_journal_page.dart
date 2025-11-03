import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/config/router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
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
            if (_journal.imagesUrls.isNotEmpty) ...[
              InlineSliderWidget(journal: _journal),
              SizedBox(height: 7),
            ],
            dateStack(context),
            SizedBox(height: 20),
            Expanded(
              child: WritingArea(readOnly: true, controller: _controller),
            ),
          ],
        ),
      ),
    );
  }

  Stack dateStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 17,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              datecontainer(
                context: context,
                width: 30,
                text: _journal.date.day.toString(),
                textStyle: Theme.of(
                  context,
                ).textTheme.displayLarge!.copyWith(fontSize: 15),
              ),
              datecontainer(
                context: context,
                text: DateFormat('MMMM d, y').format(_journal.date),
                width: 103,
                textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              datecontainer(
                context: context,
                width: 103,
                textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                text: DateFormat('EEEE. hh:mm a').format(_journal.date),
              ),
              statusContainer(),
            ],
          ),
        ),
      ],
    );
  }

  Container statusContainer() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white, //
      ),
      child: Center(child: AppAssets.svgSmile), //not real status
    );
  }

  Container datecontainer({
    required BuildContext context,
    required double width,
    required String text,
    required TextStyle textStyle,
  }) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white, //
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
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
