import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';

class DateStackWidget extends StatelessWidget {
  final JournalModel journal;
  const DateStackWidget({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                theme: theme,
                width: 30,
                text: journal.date.day.toString(),
              ),
              datecontainer(
                theme: theme,
                text: DateFormat('MMMM d, y').format(journal.date),
                width: 103,
              ),
              datecontainer(
                theme: theme,
                width: 103,
                text: DateFormat('EEEE. hh:mm a').format(journal.date),
              ),
              statusContainer(journal.status),
            ],
          ),
        ),
      ],
    );
  }

  Container statusContainer(String status) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white, //
      ),
      child: Center(child: AppAssets.statusToSvg(status)),
    );
  }

  Container datecontainer({
    required ThemeData theme,
    required double width,
    required String text,
  }) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white, //
      ),
      child: Center(
        child: Text(
          text,
          style: width == 30
              ? theme.textTheme.displayLarge!.copyWith(fontSize: 15)
              : theme.textTheme.displayLarge!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
