import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext context,
  ) submitFun;
  const AuthForm(
    this.submitFun, {
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
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ))),
                  onPressed: submit,
                  child: Text(
                    isLogin ? 'Login' : 'Sign Up',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
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
    if (isValid) {
      _formKey.currentState!.save();
      print('email : $email');
      print('password : $password');
      if (!isLogin) print('user name : $userName');
      widget.submitFun(
        email.trim(),
        password.trim(),
        userName.trim(),
        isLogin,
        context,
      );
    } else {
      print('Hello');
    }
  }
}
