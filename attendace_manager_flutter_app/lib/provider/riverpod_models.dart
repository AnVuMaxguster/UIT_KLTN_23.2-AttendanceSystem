import 'dart:async';

import 'package:attendace_manager_flutter_app/data/First_Screen.dart';
import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/ble_ChangeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/classes_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_details_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/navigation_bar_provider.dart';
import 'package:attendace_manager_flutter_app/provider/navigation_rail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider navigation_bar_index_provider=ChangeNotifierProvider<navigation_bar_index>((ref) => navigation_bar_index(0));
final ChangeNotifierProvider first_screen_Controller=ChangeNotifierProvider<First_Screen_Controller>((ref) => First_Screen_Controller(false,/*"192.168.120.72:8080"*/"localhost:8080"));
final ChangeNotifierProvider login_screen_Controller=ChangeNotifierProvider<LoginChangeNotifier>((ref) => LoginChangeNotifier(true));
final ChangeNotifierProvider account_Controller=ChangeNotifierProvider<Account_ChangeNotifier>((ref) => Account_ChangeNotifier(Member(-1, "name", "email", Role.STUDENT, List.empty(), "description", "display_name")));
final ChangeNotifierProvider classes_Controller=ChangeNotifierProvider<ClassesChangeNotifier>((ref) => ClassesChangeNotifier());
final ChangeNotifierProvider bleChangeNotifierProvider=ChangeNotifierProvider<BleChangeNotifier>((ref) => BleChangeNotifier());
final ChangeNotifierProvider navigation_rail_index_provider=ChangeNotifierProvider<navigation_rail_changeNotifier>((ref) => navigation_rail_changeNotifier(0,false));
final ChangeNotifierProvider desktop_class_screen_Controller=ChangeNotifierProvider<Desktop_class_changeNotifier>((ref) => Desktop_class_changeNotifier(DateTime.now(),DateTime.now()));
final ChangeNotifierProvider desktop_class_details_screen_Controller=ChangeNotifierProvider<Desktop_class_details_changNotifier>((ref)=>Desktop_class_details_changNotifier());
final ChangeNotifierProvider desktop_account_Controller=ChangeNotifierProvider<Desktop_account_changeNotifier>((ref) => Desktop_account_changeNotifier());
final serverCheckProvider = Provider.autoDispose<void>((ref) async {
  final Timer timer=Timer.periodic(Duration(seconds: 5), (timer) async {
    bool first_screen_state=ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).isVisible;
    if(first_screen_state==false)
    {
      var reponseCode=await testing_server(ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress);
      if(reponseCode==200)
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).isVisible=false;
      else
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).isVisible=true;
    }
    // ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).enableBluetooth();
    // if(!await ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).bleController.ble.isOn)
    //   {
    //     // print("test test test");
    //     // ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).bleController.openBluetoothSettings();
    //     // ref.read(bleChangeNotifierProvider as ChangeNotifierProvider<BleChangeNotifier>).BleScan();
    //   }
  });
  ref.onDispose(() {
    timer.cancel();
  });
});