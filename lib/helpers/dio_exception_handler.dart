import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klontong_mobile/services/navigation.dart';

class DioExceptionHandler {
  static final DioExceptionHandler _instance = DioExceptionHandler._();
  static DioExceptionHandler get instance => _instance;
  DioExceptionHandler._();

  Map<String, dynamic> maps = <String, dynamic>{};

  void init() async {
    const path = 'assets/json/error_message.json';
    final source = await rootBundle.loadString(path);
    maps = Map<String, dynamic>.from(jsonDecode(source));
  }

  void onDioException(DioException error) {
    final exceptionMessage = {
      DioExceptionType.connectionError: maps['connection_error'],
      DioExceptionType.connectionTimeout: maps['connection_timeout'],
      DioExceptionType.receiveTimeout: maps['receive_timeout'],
      DioExceptionType.sendTimeout: maps['send_timeout'],
      DioExceptionType.cancel: maps['cancel'],
      DioExceptionType.unknown: maps['unknown'],
    };

    Map? message = exceptionMessage[error.type];
    message ??= maps[error.response?.statusCode.toString()];

    showErrorDialog(message?['title'], message?['message']);
  }

  void showErrorDialog(String? title, String? message) {
    final context = NavigationService.navigatorKey.currentState!.context;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
          Column(
            children: [
              if (title != null) Text(title),
              if (message != null) Text(message),
            ],
          ),
        ],
      ),
    ));
  }
}
