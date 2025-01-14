import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:my_to_do_app/auth_controller.dart';

import 'package:my_to_do_app/splash_screen.dart';

import 'package:get/get.dart';
import 'package:my_to_do_app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      getPages: RoutesClass.routes,
    );
  }
}
