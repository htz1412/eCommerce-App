import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/cart.dart';
import 'package:state_management_demo/provider/product.dart';
import 'package:state_management_demo/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final Function toggleFavourite;

  ProductItem(this.toggleFavourite);

  @override
  Widget build(BuildContext context) {
    final snackBar = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Consumer<Product>(
                builder: (ctx, product, child) => Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () async {
                try {
                  await toggleFavourite(product);
                } catch (error) {
                  snackBar.hideCurrentSnackBar();
                  snackBar.showSnackBar(
                    SnackBar(
                      content: Text('Something went wrong!'),
                    ),
                  );
                }
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addProduct(
                  product.id,
                  product.title,
                  product.price,
                );
                snackBar.hideCurrentSnackBar();
                snackBar.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Item has been added to cart!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
