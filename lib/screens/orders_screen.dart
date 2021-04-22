import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/order.dart' show Order;
import 'package:state_management_demo/widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      backgroundColor: Colors.grey[200],
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false)
            .fetchAndSetOrders()
            .catchError((error) {
          print(error.toString());
        }),
        builder: ((ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error == null) {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            } else {
              return Center(
                child: Text('Error'),
              );
            }
          }
        }),
      ),
    );
  }
}
