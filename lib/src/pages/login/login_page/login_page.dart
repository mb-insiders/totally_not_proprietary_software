import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:insidersapp/src/pages/login/login_page/login_form.dart';
import 'package:insidersapp/src/repositories/auth/auth_repository.dart';
import 'package:insidersapp/src/repositories/secure_storage/secure_repository.dart';
import 'package:insidersapp/src/router/router.gr.dart';
import 'package:insidersapp/src/shared/widgets/appbar_widgets/logo_only_title_widget.dart';
import 'package:insidersapp/src/theme/app_theme.dart';
import 'package:insidersapp/src/theme/colors.dart';

import '../get_login_app_bar.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthRepository>(context),
          secureRepository:
              RepositoryProvider.of<SecureStorageRepository>(context),
        );
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            previous.loginFormStatus != current.loginFormStatus,
        builder: (context, LoginState state) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.loginFormStatus.isSubmissionSuccess) {
                // Navigator.restorablePushNamed(context, EnterOtpPage.routeName);
                context.router.push(const EnterOtpRoute());
              }
            },
            child: Scaffold(
              appBar: getLoginAppBar(),
              body: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: AppThemes.edgePadding, right: AppThemes.edgePadding),
                  child: LoginForm(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: state.loginFormStatus.isValidated
                    ? () {
                        context.read<LoginBloc>().submitLogin();
                      }
                    : null,
                tooltip: 'Log In',
                child: const Icon(Icons.keyboard_arrow_right),
                backgroundColor: state.loginFormStatus.isValidated
                    ? AppColors.involioBlue
                    : AppColors.involioGreyBlue,
                foregroundColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
