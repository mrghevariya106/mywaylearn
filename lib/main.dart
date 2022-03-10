import 'package:flutter/material.dart';
import 'package:mywaylearn/constants/routes.dart';
import 'package:mywaylearn/services/auth/auth_service.dart';
import 'package:mywaylearn/view/login_view.dart';
import 'package:mywaylearn/view/notes_view.dart';
import 'package:mywaylearn/view/register_view.dart';
import 'package:mywaylearn/view/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: const HomePage(),
    routes: {
      loginRoute : (context) => const LoginView(),
      registerRoute : (context) => const RegisterView(),
      notesRoute : (context) => const NotesView(),
      verifyEmailRoute : (context) => const VerifyEmailView(),
    }
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            // print(user);
            devtools.log(user.toString());
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

