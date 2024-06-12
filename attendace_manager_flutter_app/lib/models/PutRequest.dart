import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';

class PutRequest{
  int itemId;
  String property;
  dynamic value;

  PutRequest(this.itemId, this.property, this.value);

  String toJson()
  {
    Map<String,dynamic> json=new HashMap();
    json['itemId']=itemId;
    json['property']=property;
    if(value is DateTime)
      {
        String strValue=DateFormat("dd/MM/yyyy HH:mm:ss").format(value);
        json['value']=strValue;
      }
    else json['value']=value;
    return jsonEncode(json);
  }
}