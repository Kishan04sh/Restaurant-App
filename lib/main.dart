import 'package:flutter/material.dart';
import 'package:restaurant_app/core/app_config.dart';
import 'package:restaurant_app/core/app_constant.dart';
import 'package:restaurant_app/screens/restaurant/view/restaurant_list_screen.dart';

void main() {
  runApp(
    const AppRoot(),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return AppConfig(
      session: AppSession(
        auth: AppConstant.auth,
        sessionToken: AppConstant.sessionToken,
      ),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const RestaurantListScreen(),
    );
  }
}