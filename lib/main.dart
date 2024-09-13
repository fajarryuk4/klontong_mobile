import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:klontong_mobile/routes/router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'bloc/product/product_bloc.dart';
import 'constants/uri.dart';
import 'helpers/dio_exception_handler.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    DioExceptionHandler.instance.init();
    await dotenv.load();

    await SentryFlutter.init(
      (options) => options.dsn = kDebugMode ? '' : sentryUrl,
    );

    runApp(const MyApp());
  }, (error, stack) async {
    if (error is DioException) {
      DioExceptionHandler.instance.onDioException(error);
    }

    if (kDebugMode) {
      if (error is NetworkImageLoadException) return;

      debugPrintStack(stackTrace: stack, label: error.toString());
      return;
    }

    await Sentry.captureException(error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp.router(
        title: 'Klontong App',
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide(
                color: Theme.of(context).colorScheme.primary,
              )),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
