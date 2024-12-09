import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scryfall_app/controllers/userController.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((event) => _user = event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 22, 22, 25), Color.fromARGB(255, 66, 30, 62)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(
                  Buttons.google, 
                  onPressed: login, 
                  text: 'Login with Google',
                ),
                TextButton(
                  onPressed: () {
                    Get.delete<UserController>();
                    Get.toNamed('/');
                  }, 
                  child: Text('Continue without an account', style: TextStyle(color: Colors.grey),))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async{
    try{
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successful Login'))
      );

      UserController userController = Get.put(UserController(_user!));
    
      Get.toNamed('/');
    }
    catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'))
      );
    }
  }
}