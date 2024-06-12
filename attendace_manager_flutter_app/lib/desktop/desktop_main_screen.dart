import 'package:attendace_manager_flutter_app/desktop/desktop_account_screen/desktop_account_screen.dart';
import 'package:attendace_manager_flutter_app/desktop/desktop_class_screen/desktop_class_screen.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/navigation_rail_provider.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class desktop_main_screen extends ConsumerWidget {
  List screens=[
    desktop_account_screen(),
    desktop_class_screen()
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: Offset(3,10)
                    )
                  ]
              ),
              child: NavigationRail(
                selectedIndex: ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).index,
                extended: ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend,
                useIndicator: true,
                backgroundColor: Colors.white,
                indicatorColor: Colors.transparent,
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                ),
                onDestinationSelected: (index){
                  ref.read(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).index=index;
                  switch (index)
                      {
                    case 0:
                      ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).requestAllStudentsAndMembers(ref);
                      break;
                    case 1:
                      ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).get_all_class(ref);
                      ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).requestAllStudentsAndMembers(ref);
                      break;
                  }
                },
                  destinations: [
                    custom_navigationRail_destination(Icons.account_circle_sharp, "Account"),
                    custom_navigationRail_destination(Icons.class_, "Class")
                  ],
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: management_account_card(),
                ),
                trailing: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(3,3),
                                blurRadius: 5,
                                spreadRadius: 2
                              )
                            ]
                          ),
                          child: IconButton(
                              onPressed: ()
                              {
                                if (ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend)
                                  ref.read(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend=false;
                                else ref.read(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend=true;
                              },
                              icon: Icon(
                                (()
                                {
                                  if(ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend)
                                    return Icons.keyboard_arrow_left;
                                  return Icons.keyboard_arrow_right;
                                })(),
                                color: Colors.black,
                                size: 30,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: screens[ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).index],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class management_account_card extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 3,
                offset: Offset(3,3),
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRect(
                  child: Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                Visibility(
                  visible: ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        ref.watch(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).member.display_name,
                        style:GoogleFonts.rem(
                          textStyle:TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 3,
                        offset: Offset(3,3),
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5
                    )
                  ]
              ),
              child: TextButton(
                onPressed: ()
                {
                  ref.read(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).logout();
                  ref.watch(navigation_rail_index_provider as ChangeNotifierProvider<navigation_rail_changeNotifier>).extend=false;
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.black54,
                      size: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                          "Log out",
                          style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
NavigationRailDestination custom_navigationRail_destination(IconData icon,String label)
{
  return NavigationRailDestination(
      selectedIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.blue
        ),
        child: Center(
          child: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      icon: Icon(
        icon,
        size: 30,
        color: Colors.blue,
      ),
      label: Text(
          label,
          style:GoogleFonts.robotoMono(
            textStyle:TextStyle(
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
      )
  );
}
