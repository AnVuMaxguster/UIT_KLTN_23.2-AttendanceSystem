import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassesChangeNotifier extends ChangeNotifier
{
  List<Class> _undoneClasses=List.empty();
  List<Map<String,dynamic>> _doneClasses=List.empty();

  ClassesChangeNotifier();


  List<Map<String, dynamic>> get doneClasses => _doneClasses;

  set doneClasses(List<Map<String, dynamic>> value) {
    _doneClasses = value;
    notifyListeners();
  }

  List<Class> get undoneClasses => _undoneClasses;

  set undoneClasses(List<Class> value) {
    _undoneClasses = value;
    notifyListeners();
  }

  void get_undoneClasses(WidgetRef ref) async
  {
    var response=
    await request_self_undone_classes(
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
        ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).member.id
    );
    _undoneClasses=response as List<Class>;
    notifyListeners();
  }
  void get_doneClasses(WidgetRef ref) async
  {
    var response=
    await request_self_done_classes(
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
        ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).member.id
    );
    _doneClasses=response as List<Map<String,dynamic>>;
    notifyListeners();
  }
}