import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:involio/src/pages/login/form_models/phone_entity.dart';

part 'auth_event.freezed.dart';

part 'auth_event.g.dart';

AuthEvent authEventFromJson(String str) => AuthEvent.fromJson(json.decode(str));

String authEventToJson(AuthEvent data) => json.encode(data.toJson());

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent({
    PhoneEntity? phone,
    String? accessToken,
    String? refreshToken,
    @Default(0) int expiresIn,
    String? error,
  }) = _AuthEvent;

  const factory AuthEvent.appStarted() = AppStarted;

  const factory AuthEvent.loggedIn({
    required PhoneEntity phone,
    required String accessToken,
    required String refreshToken,
    @Default(0) int expiresIn,
    String? error,
  }) = LoggedIn;

  const factory AuthEvent.loggedOut() = LoggedOut;

  const factory AuthEvent.userDeleted() = UserDeleted;

  factory AuthEvent.fromJson(Map<String, dynamic> json) =>
      _$AuthEventFromJson(json);
}
