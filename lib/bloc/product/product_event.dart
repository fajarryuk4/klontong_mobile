part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductEventRefreshList extends ProductEvent {}

class ProductEventLoadList extends ProductEvent {}

class ProductEventFilterList extends ProductEvent {
  ProductEventFilterList({required this.search});

  final String search;
}

class ProductEventAddProduct extends ProductEvent {
  ProductEventAddProduct({required this.product});

  final Product product;
}

class ProductEventEditProduct extends ProductEvent {
  ProductEventEditProduct({required this.id, required this.product});

  final String id;
  final Product product;
}

class ProductEventDeleteProduct extends ProductEvent {
  ProductEventDeleteProduct(this.id);

  final String id;
}
