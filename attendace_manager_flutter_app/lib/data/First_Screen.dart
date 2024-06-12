import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class First_Screen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(serverCheckProvider);
    return Visibility(
      visible: ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).isVisible,
      child: Scaffold(
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 1,
            child: Column
              (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
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
                        "Server Address"
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
                  controller: ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).textEditingController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(
                      onPressed: ()
                      {
                        ref.read(first_screen_Controller  as ChangeNotifierProvider<First_Screen_Controller>).changeServerIp();
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
                        "Submit"
                      ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

