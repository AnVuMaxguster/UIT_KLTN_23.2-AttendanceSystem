// import 'dart:js_util';
import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/provider/account_info_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class Account
{
  String username;
  String Password;

  Account(this.username, this.Password);
}

class LoginChangeNotifier extends ChangeNotifier{
  late Account _account;
  bool _visibility;


  LoginChangeNotifier(this._visibility);

  Account get account => _account;
  bool get visibility => _visibility;

  set visibility(bool value) {
    _visibility = value;
    notifyListeners();
  }
  void commit_Login_change(Account newAccount,WidgetRef ref) async
  {
    var test= await authenticate(ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,newAccount.username, newAccount.Password);
    if(test){
      print("success");
      _account=newAccount;
      _visibility=false;
      ref.read(account_Controller as ChangeNotifierProvider<Account_ChangeNotifier>).requestMember(ref);
      notifyListeners();
      ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).requestAllStudentsAndMembers(ref);
    }
    else print("failed");
  }
  void logout()
  {
    using_token="";
    _account=Account("", "");
    _visibility=true;
    notifyListeners();
  }
}