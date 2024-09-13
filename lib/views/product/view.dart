import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:klontong_mobile/bloc/product/product_bloc.dart';
import 'package:klontong_mobile/components/dialogs/delete_dialog.dart';
import 'package:klontong_mobile/components/layouts/list_view.dart';
import 'package:klontong_mobile/components/search_bar.dart';
import 'package:klontong_mobile/models/product.dart';
import 'package:klontong_mobile/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController(initialRefresh: true);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          builder: (context, state) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: XSearchBar(
                  onSearch: (v) => context
                      .read<ProductBloc>()
                      .add(ProductEventFilterList(search: v)),
                ),
              ),
              Expanded(
                child: ProductListView(
                  refreshController: refreshController,
                  items: (state is ProductListComplete) ? state.items : [],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.goNamed(Routes.addProduct),
          tooltip: 'Add Product',
          child: const Icon(Icons.add),
        ),
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
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProductListTile(item: items[i]),
      ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () => context.goNamed(
              Routes.detailProduct,
              pathParameters: {'productId': item.id ?? ''},
              extra: item,
            ),
            icon: const Icon(Icons.edit),
          ),
          const Gap(5),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
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
        ],
      ),
    );
  }
}
