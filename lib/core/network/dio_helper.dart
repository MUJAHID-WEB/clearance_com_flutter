import 'dart:io';

import 'package:dio/dio.dart';
import 'package:clearance/core/cache/cache.dart';

import '../constants/networkConstants.dart';
import '../main_functions/main_funcs.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: clearanceUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    final response= await dio!.get(
      url,
      queryParameters: query,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'get',
         query,
         null
    );
    return response;
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    logRequestedUrl('data: ' + data.toString() + '\n');
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    final response=await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'post',
        query,
        data
    );
    return response;
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    final response= await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'put',
         query,
         data
    );
    return response;
  }
}

class MainDioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: clearanceUrl,
          receiveDataWhenStatusError: true,
          // connectTimeout: 30 * 1000, // 30 seconds
          // receiveTimeout: 30 * 1000),
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
      ),    
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    String? cachedLocal = getCachedLocal();

    if (cachedLocal == null) {
      lang = 'en';
    } else if (cachedLocal == 'ar') {
      lang = 'ae';
    } else {
      lang = 'en';
    }
    logRequestedUrl('get method');
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    logRequestedUrl('token: ' + token.toString() + '\n');
    dio!.options.headers = {
      'lang': lang,
      'User-Agent':'device OS:'+(Platform.isAndroid ? 'Android' : 'IOS')+' , application version: 1.2.1',
      'Authorization': token != null ? "Bearer " + token : null,
      'Accept': 'application/json',
    };
    final response= await dio!.get(
      url,
      queryParameters: query,);
    saveRequestsData(
      url,
      response.data,
        dio!.options.headers,
      response.statusCode,
        'get',
      query,
      null
    );
    return response;
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('post method');
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    logRequestedUrl('data: ' + data.toString() + '\n');
    logRequestedUrl('token: ' + token.toString() + '\n');
    dio!.options.headers = {
      'lang': lang,
      'User-Agent':'device OS:'+(Platform.isAndroid ? 'Android' : 'IOS')+' , application version: 1.2.1 , language:'+lang + ' , back end version: v7',
      'Authorization': token != null ? "Bearer " + token : token,
      'Accept': 'application/json',
    };

    final response= await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'post',
        query,
        data
    );
    return response;
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('putData method');
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    logRequestedUrl('data: ' + data.toString() + '\n');

    dio!.options.headers = {
      'lang': lang,
      'User-Agent':'device OS:'+(Platform.isAndroid ? 'Android' : 'IOS')+' , application version: 1.2.1',
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    final response=await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'put',
        query,
        data
    );
    return response;
  }

  static Future<Response> postDataWithFormData({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('postDataWithFormData method');
    logRequestedUrl('url: ' + url + '\n');
    logRequestedUrl('queryParameters: ' + query.toString() + '\n');
    logRequestedUrl('data: ' + data.toString() + '\n');
    // logRequestedUrl('token: '+token.toString()+'\n');
    dio!.options.headers = {
      'lang': lang,
      'User-Agent':'device OS:'+(Platform.isAndroid ? 'Android' : 'IOS')+' , application version: 1.2.1',
      'Authorization': token != null ? "Bearer " + token : null,
      'Accept': 'application/json',
    };

    final response=await  dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
    saveRequestsData(
        url,
        response.data,
        dio!.options.headers,
        response.statusCode,
        'post',
        query,
        null
    );
    return response;
  }
}
