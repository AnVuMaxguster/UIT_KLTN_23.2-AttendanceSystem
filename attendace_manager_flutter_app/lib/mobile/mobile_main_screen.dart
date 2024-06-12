import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/mobile/mobile_account_screen.dart';
import 'package:attendace_manager_flutter_app/mobile/mobile_classes_screen.dart';
import 'package:attendace_manager_flutter_app/mobile/mobile_history_screen.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/ble_ChangeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/classes_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/navigation_bar_provider.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class mobile_main_screen extends ConsumerWidget {

  final screen=[mobile_account_screen(),mobile_classess_screen(),mobile_history_screen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index=ref.watch(navigation_bar_index_provider as ChangeNotifierProvider<navigation_bar_index>).index;
    return Scaffold(
      body: screen[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index)
          async {
            ref.read(navigation_bar_index_provider as ChangeNotifierProvider<navigation_bar_index>).index=index;
            // ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).printScanResult();
            switch(index)
                {
              case 0:
                ref.watch(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).requestMember(ref);
                break;
              case 1:
                ref.watch(classes_Controller as ChangeNotifierProvider<ClassesChangeNotifier>).get_undoneClasses(ref);
                break;
              case 2:
                ref.watch(classes_Controller as ChangeNotifierProvider<ClassesChangeNotifier>).get_doneClasses(ref);
                // ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).UniversalBleScan();
                break;

            }
          }
        ,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.account_box),
              label: "Account"
          ),
          NavigationDestination(
              icon: Icon(Icons.class_),
              label: "Classes"
          ),NavigationDestination(
              icon: Icon(Icons.timer),
              label: "History"
          ),
        ],
      ),
    );
  }
}
