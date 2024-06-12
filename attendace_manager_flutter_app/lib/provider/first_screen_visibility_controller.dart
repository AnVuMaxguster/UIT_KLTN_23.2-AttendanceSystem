import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:flutter/material.dart';

class First_Screen_Controller extends ChangeNotifier
{
  bool _isVisible;
  String _ipAddress;
  TextEditingController textEditingController= TextEditingController();
  First_Screen_Controller(this._isVisible,this._ipAddress);

  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  String get ipAddress => _ipAddress;

  set ipAddress(String value) {
    _ipAddress = value;
    notifyListeners();
  }
  void changeServerIp() async
  {
    if(textEditingController.text=="")
      return;
    var test=await testing_server(textEditingController.text);
    if(test==200){
      _ipAddress = textEditingController.text;
      _isVisible = false;
      notifyListeners();
    }
  }
}