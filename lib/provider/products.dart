import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:state_management_demo/models/http_exception.dart';
import 'package:state_management_demo/provider/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    // id: 'p4',
    // title: 'A Pan',
    // description: 'Prepare any meal you want.',
    // price: 49.99,
    // imageUrl:
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> toggleFavourite(Product product) async {
    var oldFavouriteValue = product.isFavourite;
    product.isFavourite = !product.isFavourite;
    notifyListeners();

    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/products/${product.id}.json',
    );
    var response = await http.patch(
      url,
      body: json.encode({
        'isFavourite': product.isFavourite,
      }),
    );
    if (response.statusCode >= 400) {
      product.isFavourite = oldFavouriteValue;
      notifyListeners();
      throw Exception('error here');
    }
    oldFavouriteValue = null;
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/products.json',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Product> fetchedProducts = [];
      extractedData.forEach((productId, productData) {
        fetchedProducts.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavourite: productData['isFavourite'],
        ));
      });

      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/products.json',
    );

    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'isFavourite': newProduct.isFavourite,
        }),
      );
      final addNewProduct = Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      );
      _items.add(addNewProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final index = _items.indexWhere((product) => product.id == productId);
    if (index >= 0) {
      final url = Uri.parse(
        'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/products/$productId.json',
      );

      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      _items[index] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
      'https://flutter-shop-app-26221-default-rtdb.firebaseio.com/products/$productId.json',
    );
    final existingProductIndex = _items.indexWhere(
      (product) => product.id == productId,
    );
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProduct = null;
  }
}
