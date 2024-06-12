import 'package:flutter/foundation.dart';

class navigation_bar_index extends ChangeNotifier
{
  int _index;

  navigation_bar_index(this._index);

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }
}