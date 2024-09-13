import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../constants/uri.dart';
import '../models/product.dart';

export 'package:dio/dio.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService({String? baseUrl}) {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: baseUrl ?? baseURL,
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      connectTimeout: const Duration(milliseconds: connectionTimeout),
      responseType: ResponseType.json,
    );

    if (kReleaseMode) {
      dio.addSentry();
    } else {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: false,
        compact: true,
      ));
    }

    return _ApiService(dio, baseUrl: baseUrl);
  }

  /// Product
  @POST(product)
  Future<Product> addProduct(@Body() Product product);

  @GET(product)
  Future<List<Product>> getProducts({
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('length') int? length,
  });

  @GET('$product/{id}')
  Future<Product> getProduct(@Path('id') String id);

  @PUT('$product/{id}')
  Future updateProduct(
    @Path('id') String id,
    @Body() Product product,
  );

  @DELETE('$product/{id}')
  Future deleteProduct(@Path('id') String id);
}
