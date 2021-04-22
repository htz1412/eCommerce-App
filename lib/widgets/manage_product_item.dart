import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/product.dart';
import 'package:state_management_demo/provider/products.dart';
import 'package:state_management_demo/screens/edit_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;

  const ManageProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final snackBar = ScaffoldMessenger.of(context);
    return ListTile(
      // contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: product.id,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(
                    context,
                    listen: false,
                  ).deleteProduct(product.id);
                } catch (_) {
                  snackBar.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deletion Failed!',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
