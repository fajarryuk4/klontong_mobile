import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:klontong_mobile/bloc/product/product_bloc.dart';
import 'package:klontong_mobile/components/dialogs/loading_dialog.dart';
import 'package:klontong_mobile/components/inputs/dropdown_form.dart';
import 'package:klontong_mobile/components/inputs/number_input.dart';
import 'package:klontong_mobile/components/inputs/text_form.dart';
import 'package:klontong_mobile/models/category.dart';
import 'package:klontong_mobile/routes/router.dart';

import '../../models/product.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key, this.id, this.product});

  final String? id;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product ?? Product();

    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductStateLoading) {
          LoadingScreen.show();
          return;
        }

        LoadingScreen.hide();

        return switch (state) {
          ProductStateError _ => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            ),
          ProductStateComplete _ => context.pop(),
          _ => null,
        };
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Product Form'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.contact_support),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: ProductForm(
              id: id ?? '',
              product: product,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductForm extends StatelessWidget {
  const ProductForm({
    super.key,
    required this.id,
    required this.product,
  });

  final String id;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    final formKey = GlobalKey<FormState>();
    final selectedCategory = (id.isNotEmpty)
        ? Category(id: product.categoryId, name: product.categoryName)
        : null;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const Gap(16),
          XTextForm(
            initialValue: product.sku,
            label: 'SKU',
            isRequired: true,
            onSaved: (v) => product.sku = v,
          ),
          XTextForm(
            initialValue: product.name,
            label: 'Name',
            isRequired: true,
            onSaved: (v) => product.name = v,
          ),
          XNumberForm(
            initialValue: '${product.harga ?? ''}',
            label: 'Price',
            isRequired: true,
            onSaved: (v) => product.harga = int.parse(v ?? '0'),
          ),
          XDropdownForm<Category>(
            initialValue: selectedCategory,
            label: 'Category',
            isRequired: true,
            initCompareItem: (item, selected) => item.id == selected.id,
            displayText: (o) => '${o.name}',
            items: [
              Category(id: 14, name: 'Cemilan'),
              Category(id: 13, name: 'Sembako'),
              Category(id: 12, name: 'Minuman'),
            ],
            onSaved: (v) {
              product.categoryId = v?.id;
              product.categoryName = v?.name;
            },
          ),
          XTextForm(
            initialValue: product.description,
            label: 'Description',
            onSaved: (v) => product.description = v,
          ),
          XNumberForm(
            initialValue: '${product.weight ?? ''}',
            label: 'Weight',
            onSaved: (v) => product.weight =
                (v ?? '').isNotEmpty ? int.parse(v ?? '0') : null,
          ),
          XNumberForm(
            initialValue: '${product.width ?? ''}',
            label: 'Width',
            onSaved: (v) => product.width =
                (v ?? '').isNotEmpty ? int.parse(v ?? '0') : null,
          ),
          XNumberForm(
            initialValue: '${product.length ?? ''}',
            label: 'Length',
            onSaved: (v) => product.length =
                (v ?? '').isNotEmpty ? int.parse(v ?? '0') : null,
          ),
          XNumberForm(
            initialValue: '${product.height ?? ''}',
            label: 'Height',
            onSaved: (v) => product.height =
                (v ?? '').isNotEmpty ? int.parse(v ?? '0') : null,
          ),
          XTextForm(
            initialValue: product.image,
            label: 'Image URL',
            onSaved: (v) => product.image = v,
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;

                formKey.currentState?.save();

                final event = (id.isNotEmpty)
                    ? ProductEventEditProduct(id: id, product: product)
                    : ProductEventAddProduct(product: product);

                bloc.add(event);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
