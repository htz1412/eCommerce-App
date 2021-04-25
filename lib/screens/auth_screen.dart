import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_demo/models/http_exception.dart';
import 'package:state_management_demo/provider/auth.dart';

enum AuthMode {
  SignUp,
  Login,
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 94, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'MyShop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'Anton',
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //animation variables
  // AnimationController _animationController;
  // Animation<Size> _sizeAnimation;

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(
  //       milliseconds: 300,
  //     ),
  //   );
  //   _sizeAnimation = Tween<Size>(
  //     begin: Size(50, double.infinity),
  //     end: Size(200, double.infinity),
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _animationController,
  //       curve: Curves.ease,
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // _animationController.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    _emailController.clear();
    _passwordController.clear();
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      // _animationController.forward();
    } else {
      setState(() {
        _confirmPasswordController.clear();
        _authMode = AuthMode.Login;
      });
      // _animationController.reverse();
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('An error occured!'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            )
          ],
        );
      },
    );
  }

  void _saveForm() async {
    var isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.SignUp) {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'],
          _authData['password'],
        );
        _confirmPasswordController.clear();
      } else {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      }
      _emailController.clear();
      _passwordController.clear();
    } on HttpException catch (error) {
      var errorMessage;

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already exists.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'You have enterd invalid email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'You have entered invalid password.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This email is not found.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Your password is too weak.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authanticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      color: Colors.white,
      child: Container(
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!value.contains('@')) {
                      return 'Invalid input';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  keyboardType: TextInputType.text,
                  textInputAction: _authMode == AuthMode.SignUp
                      ? TextInputAction.next
                      : TextInputAction.done,
                  controller: _passwordController,
                  obscureText: true,
                  validator: _authMode == AuthMode.SignUp
                      ? (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length <= 6) {
                            return 'Please enter a strong password.';
                          }
                          return null;
                        }
                      : null,
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                  onFieldSubmitted:
                      _authMode == AuthMode.Login ? (_) => _saveForm() : null,
                ),

                AnimatedContainer(
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                  ),
                  child: _authMode == AuthMode.SignUp
                      ? TextFormField(
                          controller: _confirmPasswordController,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          validator: _authMode == AuthMode.SignUp
                              ? (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a confirm password.';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                          onFieldSubmitted: _authMode == AuthMode.SignUp
                              ? (_) => _saveForm()
                              : null,
                        )
                      : null,
                ),
                SizedBox(
                  height: 30,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: double.maxFinite, height: 50),
                        child: ElevatedButton(
                          onPressed: () => _saveForm(),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // padding: EdgeInsets.symmetric(horizontal: 30),
                          ),
                          child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: double.maxFinite, height: 50),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _switchAuthMode(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.grey[200],
                      onPrimary: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: BorderSide(color: Colors.purple, width: 1.5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Text(
                      _authMode == AuthMode.Login
                          ? 'Create an account'
                          : 'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isLoading ? Colors.grey[500] : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
                // TextButton(
                //   style: TextButton.styleFrom(
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                //   child: Text(
                //     _authMode == AuthMode.Login
                //         ? 'Sign Up instead'
                //         : 'Login instead',
                //     style: TextStyle(fontSize: 16),
                //   ),
                //   onPressed: () => _switchAuthMode(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
