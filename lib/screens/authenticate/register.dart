import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up to Brew Crew"),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text("Sign in"),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                validator: (val) {
                  return val!.isEmpty ? "Email is required." : null;
                },
                decoration: textInputDecoration.copyWith(hintText: "Email"),
              ),
              SizedBox(height: 20,),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                obscureText: true,
                validator: (val) {
                  return val!.length < 6 ? "Password must be 6+ characters long." : null;
                },
                decoration: textInputDecoration.copyWith(hintText: "Password"),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "There was an error while registering.";
                      });
                    }
                  }
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.brown),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
