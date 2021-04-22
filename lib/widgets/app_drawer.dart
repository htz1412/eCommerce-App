import 'package:flutter/material.dart';
import 'package:state_management_demo/screens/manage_products_screen.dart';
import 'package:state_management_demo/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Harsh Gohel'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_bag,
            ),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
