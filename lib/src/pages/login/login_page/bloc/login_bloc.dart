import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';

import 'package:involio/gen/involio_api.swagger.dart';
import 'package:involio/src/pages/login/form_models/models.dart';
import 'package:involio/src/pages/login/form_models/phone_entity.dart';
import 'package:involio/src/repositories/api/auth/auth_repository.dart';
import 'package:involio/src/repositories/local/secure_storage/secure_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final AuthRepository _authRepository;
  late final SecureStorageRepository _secureRepository;

  LoginBloc() : super(const LoginState()) {
    _authRepository = GetIt.I.get<AuthRepository>();
    _secureRepository = GetIt.I.get<SecureStorageRepository>();

    on<LoginLoadStoredNumber>(_onLoadStoredNumber);
    on<LoginPhoneChanged>(_onPhoneChanged);
    on<LoginSubmitted>(_onLoginSubmitted);

    loadStoredNumber();
  }

  void loadStoredNumber() {
    add(const LoginLoadStoredNumber());
  }

  Future<void> _onLoadStoredNumber(
    LoginLoadStoredNumber event,
    Emitter<LoginState> emit,
  ) async {
    PhoneEntity? phone = await _secureRepository.getPhone();

    if (phone != null) {
      final phoneField = PhoneNumber.dirty(phone);

      emit(state.copyWith(
        initialPhone: phone,
        readyToDisplay: true,
        loginFormStatus: Formz.validate([phoneField]),
      ));
    } else {
      emit(state.copyWith(
        readyToDisplay: true,
      ));
    }
  }

  void phoneChanged({
    required PhoneEntity phone,
  }) {
    add(LoginPhoneChanged(
      phone: phone,
    ));
  }

  void _onPhoneChanged(
    LoginPhoneChanged event,
    Emitter<LoginState> emit,
  ) {
    final phone = PhoneNumber.dirty(event.phone);
    emit(state.copyWith(
      initialPhone: null,
      phone: phone,
      loginFormStatus: Formz.validate([phone]),
    ));
  }

  void submitLogin() {
    add(const LoginSubmitted());
  }

  void _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.loginFormStatus.isValidated) {
      emit(state.copyWith(loginFormStatus: FormzStatus.submissionInProgress));
      try {
        SMSStartResponse otpSmsStartResponse =
            await _authRepository.getOtpForPhoneNumber(
          phone: '${state.phone.value.dialCode}${state.phone.value.number}',
        );

        if (otpSmsStartResponse.error == null) {
          print("persisting ${state.phone.value} to secure storage");
          await _secureRepository.persistPhone(state.phone.value);
          emit(state.copyWith(
            loginFormStatus: FormzStatus.submissionSuccess,
          ));
        } else {
          emit(state.copyWith(
            loginFormStatus: FormzStatus.submissionFailure,
          ));
        }
      } catch (e) {
        print(e);
        emit(state.copyWith(
          loginFormStatus: FormzStatus.submissionFailure,
        ));
      }
    }
  }
}
