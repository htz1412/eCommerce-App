import 'package:flutter/material.dart';
import 'package:state_management_demo/provider/order.dart' as o;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final o.OrderItem ordersDetail;

  OrderItem(this.ordersDetail);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.ordersDetail.amount.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('d/M/y hh:mm:ss')
                    .format(widget.ordersDetail.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                splashRadius: 24,
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              constraints: BoxConstraints(
                minHeight: _isExpanded ? 40 : 0,
                maxHeight: _isExpanded ? 100 : 0,
              ),
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              height: widget.ordersDetail.products.length * 24.0 + 16.0,
              child: ListView(
                children: widget.ordersDetail.products
                    .map(
                      (cartItem) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cartItem.title),
                            Text(
                                '${cartItem.quantity}x     \$${cartItem.price}'),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
