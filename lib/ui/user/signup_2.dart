import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  late String uname;
  late String fname;
  late String email;
  late String pass;
  late Map userCred;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Sign UP",
                  textScaleFactor: width * 0.005,
                ),
                textField("User Name", const Icon(Icons.person)),
                textField("Full Name", const Icon(Icons.person)),
                textField("Email", const Icon(Icons.person)),
                textField("Password", const Icon(Icons.person)),
                textField("Confirm Password", const Icon(Icons.person)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget textField(String text, Icon icon) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(), label: icon, hintText: text),
    ),
  );
}
