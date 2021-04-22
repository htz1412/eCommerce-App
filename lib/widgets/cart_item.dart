import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Confirm Delete!'),
              content: Text(
                'Are you sure you want delete this item?',
              ),
              actions: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
    );
  }
}
