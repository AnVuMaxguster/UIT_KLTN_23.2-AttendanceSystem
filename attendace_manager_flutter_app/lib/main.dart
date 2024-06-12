import 'package:attendace_manager_flutter_app/data/First_Screen.dart';
import 'package:attendace_manager_flutter_app/desktop/desktop_login_screen.dart';
import 'package:attendace_manager_flutter_app/desktop/desktop_main_screen.dart';
import 'package:attendace_manager_flutter_app/mobile/mobile_login_screen.dart';
import 'package:attendace_manager_flutter_app/mobile/mobile_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends ConsumerWidget
{

  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 600;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(isMobile(context))
      return Stack(
        children: [
          mobile_main_screen(),
          mobile_login_screen(),
          First_Screen(),
        ],
      );
    else
      return
          Stack(
            children: [
              desktop_main_screen(),
              desktop_login_screen(),
              First_Screen()
            ],
          );
  }

}
