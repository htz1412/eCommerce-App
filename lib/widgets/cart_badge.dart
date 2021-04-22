import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/provider/cart.dart';
import 'package:state_management_demo/screens/cart_screen.dart';

class CartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          splashRadius: 24,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Theme.of(context).accentColor,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                child: Consumer<Cart>(
                  builder: (_, cart, child) => Text(
                    cart.itemCount.toString(),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
