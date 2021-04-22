import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:state_management_demo/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    this.id,
    this.amount,
    this.dateTime,
    this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/orders.json',
    );

    try {
      var response = await http.get(url);
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;

      if (extractedOrders == null) {
        return;
      }

      final List<OrderItem> fetchedOrders = [];

      extractedOrders.forEach((orderId, orderData) {
        fetchedOrders.insert(
            0,
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item['id'],
                        title: item['title'],
                        price: item['price'],
                        quantity: item['quantity'],
                      ))
                  .toList(),
            ));
      });

      _orders = fetchedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/orders.json',
    );
    final timeStamp = DateTime.now();

    try {
      var response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((item) => {
                    'id': item.id,
                    'title': item.title,
                    'price': item.price,
                    'quantity': item.quantity,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: products,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
