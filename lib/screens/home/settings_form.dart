import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data as UserData;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Update your brew settings",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: _currentName ?? userData.name,
                  decoration: textInputDecoration.copyWith(hintText: "Name", fillColor: Colors.brown[50]),
                  validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20,),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(fillColor: Colors.brown[50]),
                  value: _currentSugars ?? userData.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugars"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars = val.toString()),
                ),
                SizedBox(height: 20,),
                Slider(
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  value: (_currentStrength ?? userData.strength ?? 100).toDouble(),
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                  activeColor: Colors.brown[_currentStrength ?? userData.strength ?? 100],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength ?? 100],
                ),
                ElevatedButton(
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentName ?? userData.name!,
                        _currentSugars ?? userData.sugars!,
                        _currentStrength ?? userData.strength!
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                  ),
                )
              ],
            ),
          );
        }
        else {
          return Loading();
        }
      }
    );
  }
}
