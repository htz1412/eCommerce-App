import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/products.dart';
import 'package:state_management_demo/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFavouritesOnly;

  const ProductsGrid(this.showFavouritesOnly);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final items =
        showFavouritesOnly ? productData.favouriteItems : productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: items[index],
        child: ProductItem(productData.toggleFavourite,productData.userId),
      ),
      itemCount: items.length,
    );
  }
}
