import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import 'package:mywaylearn/constants/routes.dart';
import 'package:mywaylearn/services/auth/auth_exceptions.dart';
import 'package:mywaylearn/services/auth/auth_service.dart';

import '../utilites/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context,'To Weak Password.');
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context,'Email alredy in use. Please try with a different email');
              } on InvalidEmailAuthException {
                await showErrorDialog(context,'Invalid Email Address');
              } on GenericAuthException {
                await showErrorDialog(context,'Error while registering user!');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute, 
                (route) => false
              );
            },
            child: const Text('Already register? Login Here!')
          )
        ],
      ),
    );
  }
}
