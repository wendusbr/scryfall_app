import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scryfall_app/firebase_options.dart';
import 'package:scryfall_app/pages/details.dart';
import 'package:scryfall_app/pages/home.dart';
import 'package:scryfall_app/pages/login.dart';
import 'package:scryfall_app/pages/search.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(GetMaterialApp(
    initialRoute: '/login',
    getPages: [
      GetPage(name: '/login', page: () => Login()),
      GetPage(name: '/', page: () => Home()),
      GetPage(name: '/search', page: () => Search()),
      GetPage(name: '/details', page: () => Details()),
    ],
  ));
}