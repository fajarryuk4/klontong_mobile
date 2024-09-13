import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/product.dart';
import '../services/navigation.dart';
import '../views/error/view.dart';
import '../views/product/form.dart';
import '../views/product/view.dart';

export 'package:go_router/go_router.dart';

part 'route_name.dart';

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  errorBuilder: (context, state) => const ErrorPage(),
  observers: [
    SentryNavigatorObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      name: Routes.products,
      builder: (context, state) => const ProductsPage(),
      routes: [
        GoRoute(
          path: 'add-product',
          name: Routes.addProduct,
          builder: (context, state) => const ProductFormPage(),
        ),
        GoRoute(
          path: ':productId',
          name: Routes.detailProduct,
          builder: (context, state) => ProductFormPage(
            id: state.pathParameters['productId'].toString(),
            product: state.extra as Product,
          ),
        ),
      ],
    ),
  ],
);
