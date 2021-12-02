import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: [
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text("Logout"),
              style: TextButton.styleFrom(primary: Colors.white),
            ),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text("Settings"),
                style: TextButton.styleFrom(primary: Colors.white),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/coffee_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BrewList()
        ),
      ),
    );
  }
}
