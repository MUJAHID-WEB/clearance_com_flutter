import 'package:clearance/core/constants/networkConstants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/startup_settings.dart';
import '../main_functions/main_funcs.dart';
import 'dart:convert' as convert;

class CacheHelper {
  /// add Cache init in main {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    logg('cacheGetting: ' + key.toString());
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    logg('cacheSaving: ' + key.toString());
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> saveListData({
    required String key,
    required List<String> value,
  }) async {
    logg('cacheSaving: ' + key.toString());

    return await sharedPreferences!.setStringList(key, value);
  }

  static List<String>? getListData({
    required String key,
  }) {
    logg('cacheGetting: ' + key.toString());

    return sharedPreferences!.getStringList(key);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<void> clearAllData() async {
    await sharedPreferences!.clear();
  }
}
//////  cache functions

Future<void> saveCacheSelectedHomeCategoryId(
    String selectedHomeCategoryId) async {
  CacheHelper.saveData(
      key: 'selectedHomeCategoryId', value: selectedHomeCategoryId);
}

String? getCachedSelectedHomeCategoryId() {
  return CacheHelper.getData(key: 'selectedHomeCategoryId');
}

// first app run
bool? getCachedFirstApplicationRun() {
  return CacheHelper.getData(key: 'isFirstApplicationRun');
}

Future<bool>? saveCachedFirstApplicationRun(bool value) async {
  return CacheHelper.putBoolean(key: 'isFirstApplicationRun', value: value);
}

//token
Future<void> saveCacheToken(String? token) async {
  CacheHelper.saveData(key: 'token', value: token);
}

String? getCachedToken() {
  return CacheHelper.getData(key: 'token');
}

Future<void> saveCacheIdToken(String? token) async {
  CacheHelper.saveData(key: 'id_token', value: token);
}

String? getCachedIdToken() {
  return CacheHelper.getData(key: 'id_token');
}

removeIdToken() {
  CacheHelper.removeData(key: 'id_token');
}

Future<void> saveCachePhoneCode(String? phoneCode) async {
  CacheHelper.saveData(key: 'phone_code', value: phoneCode);
}

String? getCachedPhoneCode() {
  return CacheHelper.getData(key: 'phone_code');
}

Future<void> saveCachePhoneDialCode(String? dialCode) async {
  CacheHelper.saveData(key: 'dial_code', value: dialCode);
}

String? getCachedPhoneDialCode() {
  return CacheHelper.getData(key: 'dial_code');
}

Future<void> saveCachePhoneNumber(String? phoneNumber) async {
  CacheHelper.saveData(key: 'phone_number', value: phoneNumber);
}

String? getCachedPhoneNumber() {
  return CacheHelper.getData(key: 'phone_number');
}

removeToken() {
  CacheHelper.removeData(key: 'token');
}

//token
Future<void> saveCachePaymentId(String? selectedPaymentId) async {
  CacheHelper.saveData(key: 'selectedPaymentId', value: selectedPaymentId);
}

String? getCachedPaymentId() {
  return CacheHelper.getData(key: 'selectedPaymentId');
}

removePaymentId() {
  CacheHelper.removeData(key: 'selectedPaymentId');
}

//default address
Future<void> saveCacheDefaultAddress(String? address) async {
  CacheHelper.saveData(key: 'address', value: address);
}

String? getCachedDefaultAddress() {
  return CacheHelper.getData(key: 'address');
}

removeDefaultCachedAddress() {
  CacheHelper.removeData(key: 'address');
}

//localize
Future<void> saveCacheLocal(String? localCode) async {
  CacheHelper.saveData(key: 'Local', value: localCode);
}

String? getCachedLocal() {
  return CacheHelper.getData(key: 'Local');
}

removeLocal() {
  CacheHelper.removeData(key: 'Local');
}

//name
Future<void> saveCacheName(String? name) async {
  CacheHelper.saveData(key: 'name', value: name);
}

String? getCachedName() {
  return CacheHelper.getData(key: 'name');
}

//email
Future<void> saveCacheEmail(String? email) async {
  CacheHelper.saveData(key: 'email', value: email);
}

String? getCachedEmail() {
  return CacheHelper.getData(key: 'email');
}

//home data
Future<void> saveCacheHomeData(String? homeData) async {
  CacheHelper.saveData(key: 'home_data', value: homeData);
}

String? getCachedHomeData() {
  return CacheHelper.getData(key: 'home_data');
}

// user info
Future<void> saveCacheUserInfo(String? homeData) async {
  CacheHelper.saveData(key: 'user_info', value: homeData);
}

String? getCachedUserInfo() {
  return CacheHelper.getData(key: 'user_info');
}

//demo list cache
Future<void> saveBuyingCachedValues(List<String> buyingAddressValues) async {
  await CacheHelper.saveListData(
      key: 'buyingAddressValues', value: buyingAddressValues);
}

List<String>? getBuyingCachedListValues() {
  return CacheHelper.getListData(key: 'buyingAddressValues');
}

Future<void> clearAllCache() async {
  CacheHelper.clearAllData();
}

Future<void> clearAllCacheWithoutTheme() async {
  String startingSettings = await CacheHelper.getData(key: 'StartingSettings');
  String local = await CacheHelper.getData(key: 'Local');
  CacheHelper.clearAllData();
  CacheHelper.init();
  CacheHelper.saveData(key: 'StartingSettings', value: startingSettings);
  CacheHelper.saveData(key: 'Local', value: local);
}

void saveRequestsData(
    String url,
    Map<String, dynamic> response,
    Map<String, dynamic> headers,
    int? statusCode,
    String request,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body) {
  Map<String, dynamic> requestAndResponse = {
    'url': clearanceUrl + url,
    'request': request,
    'response': response,
    'headers': headers,
    'query': query,
    'body': body,
    'statusCode': statusCode
  };
  List<Map<String, dynamic>> previousRequests = getRequestsData();
  if (previousRequests.length == countOfRequestToSave) {
    previousRequests.removeAt(0);
  }
  previousRequests.add(requestAndResponse);
  CacheHelper.saveData(
      key: 'requests_json',
      value: convert.jsonEncode({'requests_data': previousRequests}));
}
clearAllRequests(){
  CacheHelper.saveData(
      key: 'requests_json',
      value: convert.jsonEncode({'requests_data': []}));
}
removeRequestFromCache(Map<String,dynamic> request) {
  String? requestsJson = CacheHelper.getData(key: 'requests_json');
  if (requestsJson == null) {
    return ;
  }
  Map<String, dynamic> data = convert.jsonDecode(requestsJson);
  var list= List<Map<String, dynamic>>.from(data['requests_data']!.map((x) => x));
  list.remove(request);
  CacheHelper.saveData(
      key: 'requests_json',
      value: convert.jsonEncode({'requests_data': list}));
}

List<Map<String, dynamic>> getRequestsData() {
  String? requestsJson = CacheHelper.getData(key: 'requests_json');
  if (requestsJson == null) {
    return [];
  }
  Map<String, dynamic> data = convert.jsonDecode(requestsJson);
  return List<Map<String, dynamic>>.from(data['requests_data']!.map((x) => x));
}

///////////// end demo functions
