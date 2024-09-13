import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:klontong_mobile/models/product.dart';
import 'package:klontong_mobile/services/api.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final List<Product> items = [];
  final int length;
  int page = 0;

  ProductBloc({
    this.length = 10,
  }) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ProductEventAddProduct>(onAddProduct);
    on<ProductEventEditProduct>(onEditProduct);
    on<ProductEventDeleteProduct>(onDeleteProduct);

    on<ProductEventRefreshList>(onRefresh);
    on<ProductEventLoadList>(onLoading);
    on<ProductEventFilterList>(onFilter);
  }

  void onFilter(
    ProductEventFilterList event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductStateLoading());

    page = 0;
    items.clear();

    /// TODO: implement server side filter
    final result = await ApiService().getProducts(search: event.search);

    items.addAll(result);

    emit(ProductListComplete(items));
  }

  void onRefresh(
    ProductEventRefreshList event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductListLoading());

      page = 0;
      items.clear();

      /// TODO: implement server side paginantion
      final result = await ApiService().getProducts(page: page, length: length);

      if (result.isEmpty) {
        emit(ProductListComplete(items));
        return;
      }

      items.addAll(result);

      emit(ProductListComplete(items));
    } catch (e) {
      emit(ProductStateError('Failed to refresh data'));
      rethrow;
    }
  }

  void onLoading(
    ProductEventLoadList event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductListLoading());
      // controller.requestLoading(needCallback: false);
      page++;

      /// TODO: implement server side paginantion
      final result = await ApiService().getProducts(page: page, length: length);

      if (result.isEmpty) {
        // controller.loadNoData();
        emit(ProductListComplete(items));
        return;
      }

      items.addAll(result);

      // controller.loadComplete();
      emit(ProductListComplete(result));
    } catch (e) {
      // controller.loadFailed();
      emit(ProductStateError('Failed load more data'));
      rethrow;
    }
  }

  void onAddProduct(
    ProductEventAddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductStateLoading());

    try {
      await ApiService().addProduct(event.product);

      emit(ProductStateComplete());
    } catch (e) {
      emit(ProductStateError('Add Product Error'));
      rethrow;
    }
  }

  void onEditProduct(
    ProductEventEditProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductStateLoading());

    try {
      await ApiService().updateProduct(event.id, event.product);

      emit(ProductStateComplete());
    } catch (e) {
      emit(ProductStateError('Edit Product Error'));
      rethrow;
    }
  }

  void onDeleteProduct(
    ProductEventDeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductStateLoading());

    try {
      await ApiService().deleteProduct(event.id);

      emit(ProductStateComplete());
    } catch (e) {
      emit(ProductStateError('Delete Product Error'));
      rethrow;
    }
  }
}
