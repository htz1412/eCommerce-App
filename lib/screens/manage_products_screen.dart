import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/products.dart';
import 'package:state_management_demo/screens/edit_product_screen.dart';
import 'package:state_management_demo/widgets/app_drawer.dart';
import 'package:state_management_demo/widgets/manage_product_item.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.error == null) {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, products, _) => ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ManageProductItem(
                            products.items[index],
                          ),
                          Divider(),
                        ],
                      );
                    },
                    itemCount: products.items.length,
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Error'),
              );
            }
          }
        },
      ),
    );
  }
}
