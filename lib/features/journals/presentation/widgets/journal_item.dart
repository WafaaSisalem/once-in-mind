import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/password_utils.dart';
import 'package:onceinmind/core/widgets/dialog_widget.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_cubit.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';

class JournalItem extends StatelessWidget {
  const JournalItem({super.key, required this.journal});

  final JournalModel journal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (journal.isLocked) {
          showDialog(
            context: context,
            builder: (context) => DialogWidget(
              dialogType: DialogType.password,
              onOkPressed: (value) async {
                if (value.isEmpty) {
                  passwordEmptyToast(context);
                } else {
                  final masterPassword = await context
                      .read<UserCubit>()
                      .masterPassword;

                  if (masterPassword == value) {
                    context.pop();
                    context.goNamed(AppRoutes.displayJournal, extra: journal);
                  } else {
                    wrongPasswordToast(context);
                  }
                }
              },
            ),
          );
        } else {
          context.goNamed(AppRoutes.displayJournal, extra: journal);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSubhead(context),
                          journal.isLocked
                              ? Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: AppAssets.svgGreyLock,
                                  ),
                                )
                              : buildJournalContent(context),
                          SizedBox(height: 10),
                          Spacer(),
                          buildJournalBottomPart(Theme.of(context)),
                        ],
                      ),
                    ),
                    if (journal.imagesUrls.isNotEmpty && !journal.isLocked) ...[
                      //journalImage
                      SizedBox(width: 10),
                      _buildImage(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildImage() {
    return Expanded(
      flex: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100,
        ), //TODO: //كيف اعملها بطريقة احسن انه لمن يكون في صورة طويلة تاخد طول العنصر عالشمال
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor, //
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),

          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: journal.signedUrls == null
                ? 'http://blocks.astratic.com/img/general-img-landscape.png'
                : journal.signedUrls![0],
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  _buildSubhead(BuildContext context) {
    return Text(
      DateFormat('hh:mm a').format(journal.date), //must be  '11:30 PM'
      style: Theme.of(
        context,
      ).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
    );
  }

  _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        DateFormat('MMMM d, y. EEE').format(journal.date),
        style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 15),
      ),
    );
  }

  Padding buildJournalContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Text(
        journal.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.7),
      ),
    );
  }

  Padding buildJournalBottomPart(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,

            backgroundColor: AppColors.white, // S
            child: AppAssets.statusToSvg(journal.status),
          ),
          SizedBox(width: 10),
          SizedBox(width: 12, height: 9, child: AppAssets.svgWeather),
          Text(' ${journal.weather}', style: myTextStyle(theme)),
          SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              journal.location == null ? '' : journal.location!.address,
              style: myTextStyle(theme),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle myTextStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.secondary,
      fontSize: 8,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    );
  }
}
