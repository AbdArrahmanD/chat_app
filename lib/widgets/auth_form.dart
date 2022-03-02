import 'dart:io';

import 'package:chat_app/widgets/pickers/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitFun;
  const AuthForm(
    this.submitFun,
    this.isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';
  bool isLogin = true;
  File? userImageFile;
  void pickedImage(File pickedImage) {
    userImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PickImage(pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'please Enter a vaild Email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => setState(() {
                    email = val!;
                  }),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'email address',
                      labelStyle: TextStyle(fontSize: 20)),
                ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'user name must be more than 4 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => setState(() {
                      userName = val!;
                    }),
                    decoration: const InputDecoration(
                        labelText: 'user name',
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'password must be more than 6 characters';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => setState(() {
                    password = val!;
                  }),
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'password',
                      labelStyle: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 12),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    onPressed: () {
                      submit();
                      print('isLoading : ${widget.isLoading}');
                    },
                    child: Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                      style: const TextStyle(color: Colors.pink),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (userImageFile == null) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('Please Pick an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      print('email : $email');
      print('password : $password');
      if (!isLogin) print('user name : $userName');
      widget.submitFun(
        email.trim(),
        password.trim(),
        userName.trim(),
        userImageFile!,
        isLogin,
        context,
      );
    } else {
      print('Hello');
    }
  }
}
