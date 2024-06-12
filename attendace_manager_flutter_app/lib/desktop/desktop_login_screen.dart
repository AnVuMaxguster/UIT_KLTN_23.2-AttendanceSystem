import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class desktop_login_screen extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).visibility,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black87,
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image(
                    fit: BoxFit.cover,
                      image:AssetImage("images/login_bg_troll.jpg")
                  ),
                ),
              ),
              Center(
                heightFactor: 1.7,
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: Offset(2,20),
                        child: Text(
                          "Admin",
                            style:GoogleFonts.robotoMono(
                              textStyle:TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(3.0, 3.0), // Position of the shadow
                                      blurRadius: 10.0, // Blur radius of the shadow
                                      color: Colors.grey.withOpacity(0.8) // Color of the shadow
                                    ),
                                  ],
                              ),
                            )
                        ),
                      ),
                      Text(
                        "Login_",
                          style:GoogleFonts.robotoMono(
                          textStyle:TextStyle(
                              color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            shadows: [
                              Shadow(
                                  offset: Offset(3.0, 3.0), // Position of the shadow
                                  blurRadius: 10.0, // Blur radius of the shadow
                                  color: Colors.grey.withOpacity(0.8) // Color of the shadow
                              ),
                            ],
                          ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: _Login_Box(350,300)
              )
            ],
          ),
        )
    );
  }

}

class _Login_Box extends ConsumerWidget {

  final TextEditingController _username_controller=TextEditingController();
  final TextEditingController _password_controller=TextEditingController();
  late final double width;
  late final double height;


  _Login_Box(this.width, this.height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(3,3)
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
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
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))
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
                      ),
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
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                ),
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue
                ),
                controller: _password_controller,
              ),
            ),
            Transform.translate(
              offset: Offset(0,30),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: Offset(3,10)
                      )
                    ]
                ),
                child: TextButton(
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
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                  child: Text
                    (
                      style: GoogleFonts.robotoMono(
                          textStyle:const TextStyle(
                              color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                      ),
                      "Login"
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
