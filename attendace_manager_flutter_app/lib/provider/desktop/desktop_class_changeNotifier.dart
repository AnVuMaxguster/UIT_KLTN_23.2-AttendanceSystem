import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Desktop_class_changeNotifier extends ChangeNotifier
{

  DateTime _temp_Add_class_startTime;
  DateTime _temp_Add_class_endTime;
  bool _add_class_loading=false;
  late List<Class> classes=[];


  Desktop_class_changeNotifier(
      this._temp_Add_class_startTime, this._temp_Add_class_endTime);


  DateTime get temp_Add_class_startTime => _temp_Add_class_startTime;

  set temp_Add_class_startTime(value) {
    _temp_Add_class_startTime = value;
    notifyListeners();
  }

  void get_all_class(WidgetRef ref) async
  {
    try
    {
      classes=await request_all_class(ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress);
      notifyListeners();
    }
    catch (Exception)
    {
      print(Exception.toString());
    }
  }
  create_class(WidgetRef ref,Class aclass) async
  {
    try
    {
      bool result= await post_class(
          ref.read(
              first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>
          ).ipAddress,
          aclass
      );
      if (result)
        {
          get_all_class(ref);
          return result;
        }
    }
    catch (Exception)
    {
      print (Exception.toString());
      return false;
    }
  }
  void showCustom_Dialog(BuildContext context,ConsumerWidget dialog)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return dialog;
        }
    );
  }

  get temp_Add_class_endTime => _temp_Add_class_endTime;

  set temp_Add_class_endTime(value) {
    _temp_Add_class_endTime = value;
    notifyListeners();
  }

  bool get add_class_loading => _add_class_loading;

  set add_class_loading(bool value) {
    _add_class_loading = value;
    notifyListeners();
  }

  void reset_temp_class_times()
  {
    _temp_Add_class_endTime=DateTime.now();
    _temp_Add_class_startTime=DateTime.now();
    notifyListeners();
  }
}