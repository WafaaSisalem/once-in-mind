import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/toast.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/auth/data/models/user_model.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_state.dart';
import 'package:onceinmind/features/auth/presentation/widgets/form_text_field.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';

class MasterPassScreen extends StatelessWidget {
  MasterPassScreen({super.key, required this.journal});

  static const String routeName = 'MasterPassScreen';
  JournalModel journal;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newMasterPassController = TextEditingController();
  TextEditingController reEnterPassController = TextEditingController();

  save(context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(
              onPressed: () {
                context.pop();
              },
            ),
            SizedBox(width: 70),
            Text('Master Password'),
          ],
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  myForm(context),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final UserCubit userCubit = context.read<UserCubit>();
                      User user = context.read<AuthCubit>().getCurrentUser();
                      String masterPass = newMasterPassController.text;

                      String reEnterPass = reEnterPassController.text;
                      if (masterPass.isEmpty) {
                        showMyToast(
                          position: StyledToastPosition.top,

                          message: 'Enter a master password!',
                          context: context,
                        );
                      } else if (reEnterPass.isEmpty) {
                        showMyToast(
                          position: StyledToastPosition.top,
                          message: 'You have to re-enter the password!',
                          context: context,
                        );
                      } else if (reEnterPass != masterPass) {
                        showMyToast(
                          position: StyledToastPosition.top,

                          message: 'The new passwords do not match!',
                          context: context,
                        );
                      } else {
                        userCubit.updateUserData(
                          UserModel(id: user.uid, masterPassword: masterPass),
                        );

                        context.read<JournalsCubit>().updateJournal(
                          journal.copyWith(isLocked: true),
                        );

                        context.pop();
                      }
                    },

                    child: Text('Change Password'),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form myForm(context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          CustomTextFieldWidget(
            controller: newMasterPassController,
            hint: 'New Master Password',
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          CustomTextFieldWidget(
            controller: reEnterPassController,
            isPassword: true,
            hint: 'Re-enter Master Password',

            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
