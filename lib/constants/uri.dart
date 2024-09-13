import 'package:flutter_dotenv/flutter_dotenv.dart';

String sentryUrl = dotenv.get('SENTRY_URL', fallback: '');

const int receiveTimeout = 30000;
const int connectionTimeout = 30000;

String baseURL = dotenv.get('BASE_URL');

const product = '/product';
