import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/password_utils.dart';
import 'package:onceinmind/core/utils/toast.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/core/widgets/dialog_widget.dart';
import 'package:onceinmind/features/auth/data/models/user_model.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_state.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/image_slider_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
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
    // Reset slider to index 0 when opening a new journal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ImageSliderCubit>().setCurrentIndex(0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DisplayJournalPage rebuilt');
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: CustomBackButton(
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          _appBarIcon(
            icon: AppAssets.svgWhiteDelete,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogWidget(
                    dialogType: DialogType.delete,
                    onOkPressed: (value) {
                      context.read<JournalsCubit>().deleteJournal(
                        _journal.id,
                        _journal.imagesUrls.map((e) => e.toString()).toList(),
                      );
                      context.pop();
                      context.pop();
                    },
                  );
                },
              );
            },
          ),
          SizedBox(width: 15),
          _appBarIcon(
            icon: _journal.isLocked
                ? AppAssets.svgWhiteUnlock
                : AppAssets.svgWhiteLock,
            onTap: () {
              onlockTap();
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

  onlockTap() async {
    final masterPassword = await context.read<UserCubit>().masterPassword;
    if (masterPassword.isEmpty) {
      if (mounted) {
        context.pushNamed(AppRoutes.masterPassword, extra: widget.journal);
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
              dialogType: DialogType.password,

              onOkPressed: (value) {
                if (value.isEmpty) {
                  passwordEmptyToast(context);
                } else if (masterPassword == value) {
                  // Toggle lock state and update via JournalsCubit
                  final updatedJournal = _journal.copyWith(
                    isLocked: !_journal.isLocked,
                  );
                  context.read<JournalsCubit>().updateJournal(updatedJournal);
                  setState(() {
                    _journal = updatedJournal;
                  });

                  // Close the password dialog
                  context.pop();

                  showMyToast(
                    message: updatedJournal.isLocked
                        ? 'Journal locked'
                        : 'Journal unlocked',
                    context: context,
                  );
                } else {
                  wrongPasswordToast(context);
                }
              },
            );
          },
        );
      }
    }
  }
}
