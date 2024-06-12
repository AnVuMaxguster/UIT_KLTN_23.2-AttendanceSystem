import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/models/PutRequest.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/login_screen_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Account_ChangeNotifier extends ChangeNotifier
{
  Member _member;
  String _update_ble_error="";

  Account_ChangeNotifier(this._member);

  Member get member => _member;


  String get update_ble_error => _update_ble_error;

  set update_ble_error(String value) {
    _update_ble_error = value;
    notifyListeners();
  }

  void requestMember(WidgetRef ref) async
  {
    var response=await request_self_member(
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress
    );
    if(response!=null && (response as Member).id!=-1)
      {
        _member=response;
        notifyListeners();
      }
    else
      {
        ref.read(login_screen_Controller as ChangeNotifierProvider<LoginChangeNotifier>).logout();
        notifyListeners();
        print("internal request failed");
      }
  }

  putSelfBleMac(WidgetRef ref,Member member,String bleMac) async
  {
    PutRequest putRequest=PutRequest(member.id, "setBleMac", bleMac);
    final response=await put_self_account(
        ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
        putRequest
    );
    return response!=null ? ((){
      if(response is bool){
        return response;
      }
      else
        {
          update_ble_error=response.toString();
          notifyListeners();
          print("------------------"+update_ble_error);
          return false;
        }
    })()
    : false;
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
}