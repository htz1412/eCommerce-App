import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/cart.dart' show Cart;
import 'package:state_management_demo/provider/order.dart';
import 'package:state_management_demo/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmout.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 4),
                    OrderButton(cart),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  var _isOrderd = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : _isOrderd
              ? Icon(
                  Icons.done,
                  color: Colors.green,
                )
              : Text(
                  'Order Now',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
      onPressed: (widget.cart.totalAmout <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmout,
                );
                setState(() {
                  _isLoading = false;
                  _isOrderd = true;
                });
                widget.cart.clear();
              } catch (error) {
                print(error.toString());
              }
            },
    );
  }
}
