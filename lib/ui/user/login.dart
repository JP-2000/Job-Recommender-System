import 'package:flutter/material.dart';
import 'package:job_recommender_system/ui/homepage.dart';
import 'package:job_recommender_system/ui/user/profile_setup/profile_setup.dart';
import 'package:job_recommender_system/ui/user/signup.dart';
import '../../Network/network.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String name;
  late String pass;
  late Map userCred;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 130.0,
              width: 190.0,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Image.asset('assets/user.png'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter valid mail id as abc@gmail.com',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  pass = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  userCred = {"uname": name, "pass": pass};
                  String checkUser = await Network.checkUser(userCred);
                  if (checkUser != "False") {
                    debugPrint("checkUser Done");
                    bool checkProfile = await Network.checkProfile();

                    if (checkProfile) {
                      debugPrint(checkProfile.toString());
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HomePage()));
                    } else {
                      debugPrint("Profile not exist");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Profile()));
                    }
                  } else {
                    debugPrint("Invalid User");
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            InkWell(
              child: const Text('New User? Create Account'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignUpWidget()));
              },
            )
          ],
        ),
      ),
    );
  }
}
