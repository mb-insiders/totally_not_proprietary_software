import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insidersapp/src/pages/login/form_models/phone_entity.dart';
import 'package:jwt_decode/jwt_decode.dart';

class SecureStorageRepository {
  static SecureStorageRepository? _instance;

  factory SecureStorageRepository() =>
      _instance ??= SecureStorageRepository._(const FlutterSecureStorage());

  SecureStorageRepository._(this._storage);

  final FlutterSecureStorage _storage;
  static const _phoneKey = 'PHONE';
  static const _phoneCountryCodeKey = 'PHONE_COUNTRY_CODE';
  static const _phoneCountryISOCodeKey = 'PHONE_COUNTRY_ISO_CODE';
  static const _tokenKey = 'TOKEN';

  Future<void> persistPhoneAndToken({
    required PhoneEntity phone,
    required String token,
  }) async {
    await persistPhone(phone);
    await persistToken(token);
  }

  Future<void> persistPhone(
    PhoneEntity phone,
  ) async {
    await persistPhoneCountryISOCode(phone.isoCode);
    await persistPhoneCountryCode(phone.dialCode);
    await persistPhoneNumber(phone.number);
  }

  Future<void> persistPhoneInfoAndToken({
    required String phoneCountryISOCode,
    required String phoneCountryCode,
    required String phoneNumber,
    required String token,
  }) async {
    await persistPhoneCountryISOCode(phoneCountryISOCode);
    await persistPhoneCountryCode(phoneCountryCode);
    await persistPhoneNumber(phoneNumber);
    await persistToken(token);
  }

  Future<void> persistPhoneNumber(String? phoneNumber) async {
    await _storage.write(key: _phoneKey, value: phoneNumber);
  }

  Future<void> persistPhoneCountryCode(String? phoneCountryCode) async {
    await _storage.write(key: _phoneCountryCodeKey, value: phoneCountryCode);
  }

  Future<void> persistPhoneCountryISOCode(String? phoneCountryISOCode) async {
    await _storage.write(
        key: _phoneCountryISOCodeKey, value: phoneCountryISOCode);
  }

  Future<void> persistToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: _tokenKey);
    return value != null;
  }

  Future<bool> hasPhone() async {
    var value = await _storage.read(key: _phoneKey);
    return value != null;
  }

  Future<bool> hasPhoneCountryCode() async {
    var value = await _storage.read(key: _phoneCountryCodeKey);
    return value != null;
  }

  Future<bool> hasPhoneCountryISOCode() async {
    var value = await _storage.read(key: _phoneCountryISOCodeKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return await _storage.delete(key: _tokenKey);
  }

  Future<void> deletePhone() async {
    await _storage.delete(key: _phoneKey);
    await _storage.delete(key: _phoneCountryCodeKey);
    await _storage.delete(key: _phoneCountryISOCodeKey);
  }

  Future<PhoneEntity?> getPhone() async {
    String? phoneNumberStr = await getPhoneNumber();
    String? phoneCountryCodeStr = await getPhoneCountryCode();
    String? phoneCountryISOCodeStr = await getPhoneCountryISOCode();
    if (phoneCountryISOCodeStr != null &&
        phoneCountryISOCodeStr.isNotEmpty &&
        phoneCountryCodeStr != null &&
        phoneCountryCodeStr.isNotEmpty &&
        phoneNumberStr != null &&
        phoneNumberStr.isNotEmpty) {
      return PhoneEntity(
        isoCode: phoneCountryISOCodeStr,
        dialCode: phoneCountryCodeStr,
        number: phoneNumberStr,
      );
    }
    return null;
  }

  Future<String?> getPhoneNumber() async {
    return await _storage.read(key: _phoneKey);
  }

  Future<String?> getPhoneCountryCode() async {
    return await _storage.read(key: _phoneCountryCodeKey);
  }

  Future<String?> getPhoneCountryISOCode() async {
    return await _storage.read(key: _phoneCountryISOCodeKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// todo: make sure that the token uses utc time
  Future<bool> isTokenExpired() async {
    String? token = await getToken();
    if (token != null) {
      //Map<String, dynamic> payload = Jwt.parseJwt(token);
      DateTime? expirationDate = Jwt.getExpiryDate(token);
      if (expirationDate != null) {
        return DateTime.now().toUtc().isAfter(expirationDate);
      } else {
        return false;
      }
    }
    return true;
  }

  /// todo: make sure that the token uses utc time
  Future<Duration?> getTokenRemainingTime() async {
    String? token = await getToken();
    if (token != null) {
      //Map<String, dynamic> payload = Jwt.parseJwt(token);
      DateTime? expirationDate = Jwt.getExpiryDate(token);
      if (expirationDate != null) {
        return expirationDate.difference(DateTime.now().toUtc());
      }
    }
    return null;
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
