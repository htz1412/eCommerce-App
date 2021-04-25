import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_management_demo/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  bool _isLogout = false;

  bool get isLogout{
    return _isLogout;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    return authanticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authanticate(email, password, 'signInWithPassword');
  }

  Future<void> authanticate(String email, password, String urlSegment) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDCX2bkWSXkKxAOwodbTQOjMSuEnIhDZKA',
    );

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }

      _token = extractedData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(extractedData['expiresIn']),
        ),
      );
      _userId = extractedData['localId'];

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final uData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', uData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final uData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(uData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _userId = uData['userId'];
    _token = uData['token'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _isLogout = true;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpire), logout);
  }
}
