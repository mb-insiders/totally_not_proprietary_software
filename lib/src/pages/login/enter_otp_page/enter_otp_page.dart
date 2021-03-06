import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:involio/src/router/router.gr.dart';
import 'package:involio/src/shared/blocs/auth_bloc/auth_bloc.dart';
import 'package:involio/src/shared/widgets/loading_indicator.dart';
import 'package:involio/src/theme/app_theme.dart';
import 'package:involio/src/theme/colors.dart';
import '../get_login_app_bar.dart';
import 'bloc/otp_bloc.dart';
import 'bloc/otp_state.dart';

class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({Key? key}) : super(key: key);

  @override
  _EnterOtpPageState createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpBloc>(
      create: (context) => OtpBloc(authBloc: context.read<AuthBloc>()),
      child: Scaffold(
        appBar: getLoginAppBar(),
        body: const PinPutTest(),
      ),
    );
  }
}

class PinPutTest extends StatefulWidget {
  const PinPutTest({Key? key}) : super(key: key);

  @override
  PinPutTestState createState() => PinPutTestState();
}

class PinPutTestState extends State<PinPutTest> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: AppColors.involioBackgroundSwatch[400],
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // focuses on the pin input and opens the keyboard when we enter this page
      _pinPutFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = 'xxxxxxxxxx';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state.resent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Resent code to ${state.phone?.completeNumber()}',
                  ),
                ),
              );
          }
          if (state.errorSubmitting) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Error submitting code')),
              );
            // this clears the code input
            _pinPutController.text = '';
          } else if (state.errorResending) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Error resending code')),
              );
          } else if (state.errorMissingPhoneNumber) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Missing phone number')),
              );
            //Navigator.restorablePushNamed(context, GetStartedPage.routeName);
            context.router.replaceAll([const GetStartedRoute()]);
          }
        },
        child: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state) {
            if (state.phone != null) {
              phoneNumber = state.phone!.completeNumber();
            } else {
              phoneNumber = '123-456-7890';
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.start,
                //Center Column contents horizontally,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'Verify your phone number',
                      style: AppFonts.headline2,
                    ),
                  ),
                  Text(
                    'Thank you for entering you your number, now we just need to verify. Please enter the code sent to $phoneNumber',
                    style: AppFonts.body,
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: 400,
                    child: PinPut(
                      fieldsAlignment: MainAxisAlignment.spaceBetween,
                      fieldsCount: 6,
                      onSubmit: (String pin) {
                        context.read<OtpBloc>().submitOtp(pin);
                        //_showSnackBar(pin, context),
                      },
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration,
                      selectedFieldDecoration: _pinPutDecoration.copyWith(
                        border: Border.all(
                          color: AppColors.involioBlue.withOpacity(.5),
                        ),
                      ),
                      followingFieldDecoration: _pinPutDecoration,
                      pinAnimationType: PinAnimationType.scale,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Didn't receive a text?",
                        style: AppFonts.headline6,
                      ),
                      TextButton(
                        child: Text(
                          'Resend',
                          style: AppFonts.bodyBig,
                        ),
                        onPressed: () => context.read<OtpBloc>().resendSms(),
                      )
                    ],
                  ),
                  //if (state.error != null) Text("error: ${state.error}"),
                  if (state.submittingInProgress) const LoadingIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
