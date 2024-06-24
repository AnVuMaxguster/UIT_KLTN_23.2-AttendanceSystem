import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class mobile_account_screen extends ConsumerWidget {
  Member member=Member(-1, "name", "email", Role.STUDENT, List.empty(), "description", "display_name");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    member=ref.watch(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).member;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Transform.translate(
            offset: Offset(20,0),
            child: Text(
              "Account",
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        toolbarHeight: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: ()
                {
                  ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).showCustom_Dialog(context,update_ble_dialog(member));
                },
                icon: Icon(
                  Icons.settings_bluetooth_rounded,
                  color: Colors.white,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: ()
                {
                  ref.read(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).logout();
                },
                icon: Icon(
                    Icons.logout,
                  color: Colors.white,
                )
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 50,right: 15,left: 15),
        child: Column
          (
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(55)),
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
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: Row(
                  children: [
                    ClipRect(
                      child:Icon(
                        Icons.account_circle_sharp,
                        color: Colors.black,
                        size: 100,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(30,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.display_name,
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                fontSize: 27,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          Text(
                            "id: "+member.id.toString(),
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  backgroundColor: Colors.transparent
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: info_row(Icons.drive_file_rename_outline, "Username",member.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: info_row(Icons.star, "Role",member.role.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: info_row(Icons.mail,"Email",member.email),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
final ble_address_controller=TextEditingController();

class update_ble_dialog extends ConsumerWidget{

  final Member member;


  update_ble_dialog(this.member);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        width: 500,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Bluetooth Address",
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  autofocus: true,
                  controller: ble_address_controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 3
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ref.watch(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).update_ble_error,
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal
                              ),
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: Offset(3, 3),
                                            spreadRadius: 3,
                                            blurRadius: 10
                                        ),
                                      ],
                                    color: Colors.blue
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      final ble_put=ble_address_controller.text;
                                      final result=await ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).putSelfBleMac(ref,member,ble_put);
                                      if(result==true)
                                        {
                                          ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).update_ble_error="";
                                          Navigator.of(context).pop();
                                        }
                                    },
                                    child: Text(
                                      "Submit",
                                      style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          height: 2
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(3, 3),
                                          spreadRadius: 3,
                                          blurRadius: 10
                                      ),
                                    ],
                                    color: Colors.orange
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).update_ble_error="";
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          height: 2
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class info_row extends ConsumerWidget
{
  final IconData icon;
  final String dataTitle;
  final String data;


  info_row(this.icon, this.dataTitle, this.data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataTitle,
            style: GoogleFonts.nunito(
              textStyle:TextStyle
                (
                color: CupertinoColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w300
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Center(
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(55)),
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
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: Offset(10,0),
                        child: Icon(
                          icon,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(30,0),
                        child: SizedBox(
                          width: 250,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              data,
                              style: GoogleFonts.nunito
                                (
                                textStyle:TextStyle(
                                  color: Colors.black,
                                  fontSize: 20
                                )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

