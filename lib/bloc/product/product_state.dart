part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductStateLoading extends ProductState {}

final class ProductStateComplete extends ProductState {}

final class ProductListLoading extends ProductState {}

final class ProductListComplete extends ProductState {
  ProductListComplete(this.items);

  final List<Product> items;
}

// final class ProductStateInitial extends ProductState {}

// final class ProductStateLoadingAdd extends ProductState {}

// final class ProductStateLoadingEdit extends ProductState {}

// final class ProductStateLoadingDelete extends ProductState {}

// final class ProductStateCompleteEdit extends ProductState {}

// final class ProductStateCompleteDelete extends ProductState {}

// final class ProductStateCompleteAdd extends ProductState {}

final class ProductStateError extends ProductState {
  ProductStateError(this.message);

  final String message;
}
