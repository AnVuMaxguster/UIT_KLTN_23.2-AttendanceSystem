import 'package:attendace_manager_flutter_app/desktop/desktop_ultilities.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Add_account_dialog extends ConsumerWidget
{
  final username_controller=TextEditingController();
  final displayname_controller=TextEditingController();
  final password_controller=TextEditingController();
  final email_controller=TextEditingController();
  Role? role=null;
  final column_fractions=[20,15,15,15,15,10];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      elevation: 30,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        height: 600,
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: column_fractions[0],
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column
                      (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Create Account",
                            style:GoogleFonts.rem(
                              textStyle:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  letterSpacing: 2
                              ),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              "Please fill the following required initial information fields to create an account.",
                              style:GoogleFonts.robotoMono(
                                textStyle:TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[1],
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 1,
                    child: Container(
                      child: TextField(
                        controller: username_controller,
                        style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )
                        ),
                        decoration:InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          label: Text(
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                              ),
                              "Username"
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[2],
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 1,
                    child: Container(
                      child: TextField(
                        controller: displayname_controller,
                        style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )
                        ),
                        decoration:InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          label: Text(
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                              ),
                              "Display name"
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[3],
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: TextField(
                              controller: password_controller,
                              obscureText: true,
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  )
                              ),
                              decoration:InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                label: Text(
                                    style:GoogleFonts.robotoMono(
                                        textStyle:TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        )
                                    ),
                                    "Password"
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 3
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2
                                      ),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  label: Text(
                                      style:GoogleFonts.robotoMono(
                                          textStyle:TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          )
                                      ),
                                      "Role"
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange,
                                          width: 3
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                                  items: Role.values.map((e){
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Center(
                                        child: Text(
                                          e.name,
                                          style:GoogleFonts.robotoMono(
                                              textStyle:TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged:(value)
                                  {
                                    role=value;
                                  }
                              ),
                            ),
                          )
                        ],
                      )
                  )
              ),
              Expanded(
                  flex:column_fractions[4],
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 1,
                    child: Container(
                      child: TextField(
                        controller: email_controller,
                        style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )
                        ),
                        decoration:InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          label: Text(
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                              ),
                              "Email"
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[5],
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Visibility(
                          visible: !ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).isLoading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: custom_confirm_button(() async
                                  {
                                    if(username_controller.text!="" && displayname_controller.text!=""&& password_controller.text!="" && email_controller.text!="" && role!=null) {
                                      ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).isLoading=true;
                                      final result=await ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).postNewAccount(ref, username_controller.text, displayname_controller.text, password_controller.text, email_controller.text, role!);
                                      ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).isLoading=false;
                                      if (result) {
                                        ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).requestAllStudentsAndMembers(ref);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  })
                              ),
                              custom_cancel_button(()
                              {
                                Navigator.of(context).pop();
                                // ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).reset_temp_class_times();
                              })
                            ],
                          ),
                        ),
                        Visibility(
                            visible: ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).isLoading,
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.orange,
                                    ),
                                  ],
                                )
                            )
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}