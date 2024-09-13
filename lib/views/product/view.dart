import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_mobile/bloc/product/product_bloc.dart';
import 'package:klontong_mobile/components/dialogs/delete_dialog.dart';
import 'package:klontong_mobile/components/layouts/list_view.dart';
import 'package:klontong_mobile/models/product.dart';
import 'package:klontong_mobile/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController(initialRefresh: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('List Product'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) => switch (state) {
          ProductStateComplete _ => Future.delayed(
              const Duration(seconds: 1),
              () {
                try {
                  refreshController.requestRefresh();
                } catch (e) {
                  context.read<ProductBloc>().add(ProductEventRefreshList());
                }
              },
            ),
          ProductListComplete _ => refreshController.twoLevelComplete(),
          ProductStateError _ => () {
              refreshController.loadFailed();
              refreshController.refreshFailed();
            },
          _ => null,
        },
        builder: (context, state) => ProductListView(
          refreshController: refreshController,
          items: (state is ProductListComplete) ? state.items : [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(Routes.addProduct),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({
    super.key,
    required this.refreshController,
    required this.items,
  });

  final RefreshController refreshController;
  final List items;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductBloc>();

    return XListView(
      refreshController: refreshController,
      onRefresh: () => bloc.add(ProductEventRefreshList()),
      onLoading: () => bloc.add(ProductEventLoadList()),
      itemsCount: items.length,
      itemBuilder: (context, i) => ProductListTile(item: items[i]),
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.item,
  });

  final Product item;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductBloc>();

    return ListTile(
      onTap: () => context.goNamed(
        Routes.detailProduct,
        pathParameters: {'productId': item.id ?? ''},
        extra: item,
      ),
      leading: Image.network(
        height: 50,
        width: 50,
        item.image ?? '',
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.image,
          size: 50,
        ),
      ),
      title: Text(item.name ?? ''),
      subtitle: Text('Rp. ${item.harga}'),
      trailing: IconButton(
        onPressed: () => showDialog<bool>(
          context: context,
          builder: (context) => const DeleteDialog(),
        ).then(
          (value) => (value ?? false)
              ? bloc.add(ProductEventDeleteProduct(item.id ?? ''))
              : null,
        ),
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
