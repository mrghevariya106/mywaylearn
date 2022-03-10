import 'package:flutter/material.dart';
import 'package:mywaylearn/constants/routes.dart';
import 'package:mywaylearn/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:mywaylearn/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        backgroundColor: Colors.purple.shade600,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              // print (value);
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDiaLog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Text('Notes is available'),
    );
  }
}

Future<bool> showLogOutDiaLog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          ),
        ]
      );
    },
  ).then((value) => value ?? false);
}
