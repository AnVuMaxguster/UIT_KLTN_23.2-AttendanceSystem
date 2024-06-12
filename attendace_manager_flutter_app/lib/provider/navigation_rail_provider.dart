import 'package:flutter/material.dart';

class navigation_rail_changeNotifier extends ChangeNotifier{
  int _index;
  bool _extend;
  navigation_rail_changeNotifier(this._index,this._extend);

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  bool get extend => _extend;

  set extend(bool value) {
    _extend = value;
    notifyListeners();
  }
}