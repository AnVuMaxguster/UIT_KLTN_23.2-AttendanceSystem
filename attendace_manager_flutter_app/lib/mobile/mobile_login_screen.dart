import 'package:attendace_manager_flutter_app/provider/ble_ChangeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class mobile_login_screen extends ConsumerWidget {
  final TextEditingController _username_controller=TextEditingController();
  final TextEditingController _password_controller=TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).visibility,
      child: Scaffold(
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2
                        )
                    ),
                    label: Text(
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        "Username"
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 3
                        )
                    ),
                  ),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue
                  ),
                  controller: _username_controller,
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2
                          )
                      ),
                      label: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                          "Password"
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 3
                          )
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue
                    ),
                    controller: _password_controller,
                  ),
                ),
                TextButton(
                  onPressed: ()
                  {
                    ref.read(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).
                    commit_Login_change(
                        Account(
                            _username_controller.text,
                            _password_controller.text
                        ),
                        ref
                    );
                    ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).enableBluetoothVisibility();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      fixedSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                  child: Text
                    (
                      style: GoogleFonts.robotoMono(
                          textStyle:const TextStyle(
                              color: Colors.black
                          )
                      ),
                      "Login"
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
