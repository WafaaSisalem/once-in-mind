import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class DisplayJournalPage extends StatefulWidget {
  const DisplayJournalPage({super.key, required this.journal});
  final JournalModel journal;

  @override
  State<DisplayJournalPage> createState() => _DisplayJournalPageState();
}

class _DisplayJournalPageState extends State<DisplayJournalPage> {
  late JournalModel _journal;

  @override
  void initState() {
    super.initState();
    _journal = widget.journal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 28,
            color: Colors.white, //
          ),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          InkWell(
            child: SizedBox(
              width: 18,
              height: 18,
              child: AppAssets.svgWhiteDelete,
            ),
            onTap: () {
              //show Delete Dialog
            },
          ),
          SizedBox(width: 15),
          InkWell(
            // splashColor: Colors.transparent,
            child: SizedBox(
              width: 18,
              height: 18,
              child: _journal.isLocked
                  ? AppAssets.svgWhiteUnlock
                  : AppAssets.svgWhiteLock,
            ),
            onTap: () {
              //lock logic
            },
          ),
          SizedBox(width: 15),
          InkWell(
            // splashColor: Colors.transparent,
            child: SizedBox(
              width: 18,
              height: 18,
              child: AppAssets.svgEditIcon,
            ),
            onTap: () async {
              // context.go(
              //   '/home/display-journal/edit-journal',
              //   extra: _journal,
              // );
              final updatedJournal = await context.push<JournalModel>(
                '/home/display-journal/edit-journal',
                extra: _journal,
              );

              if (updatedJournal != null) {
                setState(() {
                  _journal = updatedJournal;
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
              imageSlider(),
              SizedBox(height: 7),
            ],
            dateStack(context),
            SizedBox(height: 20),
            Expanded(
              child: WritingArea(
                enabled: false,

                controller: TextEditingController(text: _journal.content),
                hintText: 'What happened with you today?',
              ),
            ),
          ],
        ),
      ),
    );
  }

  imageSlider() {
    int currentImageIndex = 0;
    return Container(
      width: double.infinity,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: ImageSlideshow(
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
        onPageChanged: (value) => currentImageIndex = value,
        children: _journal.imagesUrls
            .map(
              (imageUrl) => InkWell(
                child: Hero(
                  tag: _journal.id,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        Container(color: Colors.black12),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                onTap: () {
                  //slider viewr
                },
              ),
            )
            .toList(),
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
}
