import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/settings.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                      child: Icon(Icons.message,
                          color: Colors.green.shade600, size: 60))),
              Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: Text("A N A S A Y F A"),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: Text("A Y A R L A R"),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    },
                  )),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                title: Text("Ç I K I Ş  Y A P"),
                leading: Icon(Icons.logout),
                onTap: logout,
              ))
        ],
      ),
    );
  }
}
