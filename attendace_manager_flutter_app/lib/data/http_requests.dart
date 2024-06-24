import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/models/PutRequest.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String using_token="";

testing_server(String address) async
{
  final uri=Uri.http(address,"/api/testing");
  try
  {
    var reponse = await http.get(
      uri,
      headers: {'Access-Control-Allow-Origin': '*'},
    ).timeout(Duration(seconds: 10));
    print("Call completed: " + reponse.body.toString());
    return reponse.statusCode;
  } on TimeoutException catch (e)
  {
    print("Timeout !");
    return 408;
  }catch(e)
  {
    print(e.toString());
    return 500;
  }
}

authenticate(String address,String username,String password) async
{
  final uri=Uri.http(address,"/api/auth/authenticate");
  final body={"username":username,"password":password};
  try{
    var response = await http
        .post(uri,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    return response.statusCode == 200
        ? (() {
            using_token = (jsonDecode(response.body)
                as Map<String, dynamic>)['token'] as String;
            return true;
          })()
        : false;
  }
  catch(e)
  {
    print(e);
  }
}

request_all_students(String address) async
{
  final uri=Uri.http(address,"/api/member/all");
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_all_students_success");
      final json_list=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();
      return json_list.map((e) =>Member.fromJson(e as Map<String,dynamic>)).toList();
    })()
        : [];
  }
  catch(e)
  {
    print(e);
    return [];
  }
}

request_all_members(String address) async
{
  final uri=Uri.http(address,"/api/member/full");
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_all_members_success");
      final json_list=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();
      return json_list.map((e) =>Member.fromJson(e as Map<String,dynamic>)).toList();
    })()
        : [];
  }
  catch(e)
  {
    print(e);
    return [];
  }
}

request_self_member(String address)async
{
  final uri=Uri.http(address,"/api/member");
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_member_success");
      return Member.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    })()
        : Member(-1, "name", "email", Role.STUDENT, List.empty(), "description", "display_name");
  }
  catch(e)
  {
    print(e);
  }
}

find_member_by_username(String address,String username)async
{
  final uri=Uri.http(address,"/api/member/search",{
    "username":username
  });
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("find_members_success");
      final json_list=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();
      return json_list.map((e) =>Member.fromJson(e as Map<String,dynamic>)).toList();
    })()
        : [];
  }
  catch(e)
  {
    print(e);
  }
}

put_self_account(String address, PutRequest putRequest) async
{
  final uri=Uri.http(address,"/api/member");
  try {
    String put_request_string=putRequest.toJson();
    var response = await http.put(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        },
        body: put_request_string
    ).timeout(Duration(seconds: 10));
    if(response.statusCode==200)
      return true;
    else
      return response.body.toString();
  }
  catch (e)
  {
    print(e.toString());
    return false;
  }
}

request_self_undone_classes(String address,int member_id)async
{
  final uri=Uri.http(address,"/api/member/classes/undone",
  {
    "member_id":member_id.toString()
  });
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_undone_classes_success");
      var ListJson=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();
      return ListJson.map((json) => Class.fromJson(json)).toList();
    })()
        : List.empty();
  }
  catch(e)
  {
    print(e);
  }
}

post_account(String address,Member member,String password) async
{
  final uri=Uri.http(address,"/api/auth/register");
  try
  {
    var response = await http.post(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*',
          'Content-Type':'application/json'
        },
        body: (()
        {
          Map<String,dynamic>json=new HashMap();
          json["username"]=member.name;
          json["password"]=password;
          json["displayName"]=member.display_name;
          json["email"]=member.email;
          json["role"]=member.role.name;
          String jsonString=jsonEncode(json);
          return jsonString;
        })()
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ;
  }
  catch(e)
  {
    print(e);
  }
}


delete_account(String address,int id) async
{
  final uri=Uri.http(address,"/api/member",
      {
        "id":id.toString()
      });
  try
  {
    var response = await http.delete(
      uri,
      headers:
      {
        "Authorization": "Bearer-" + using_token,
        'Access-Control-Allow-Origin': '*',
      },
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ;
  }
  catch(e)
  {
    print(e);
  }
}
post_class(String address,Class aclass) async
{
  final uri=Uri.http(address,"/api/class");
  try
  {
    var response = await http.post(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*',
          'Content-Type':'application/json'
        },
      body: (()
      {
        Map<String,dynamic>json=new HashMap();
        json["subject"]=aclass.subject;
        json["start_time"]=DateFormat("dd/MM/yyyy HH:mm:ss").format(aclass.start_time);
        json["end_time"]=DateFormat("dd/MM/yyyy HH:mm:ss").format(aclass.end_time);
        json["class_name"]=aclass.className;
        String jsonString=jsonEncode(json);
        return jsonString;
      })()
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ;
  }
  catch(e)
  {
    print(e);
  }
}

find_class_by_classname(String address,String classname)async
{
  final uri=Uri.http(address,"/api/class/search",{
    "className":classname
  });
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("find_classes_success");
      var ListJson=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();

      return ListJson.map((json){
        return Class.fromJson(json as Map<String,dynamic>);
      }).toList();
    })()
        : List.empty();
  }
  catch(e)
  {
    print(e);
  }
}

put_class(String address,PutRequest putRequest) async
{
  final uri=Uri.http(address,"/api/class");
  try
  {
    var response = await http.put(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*',
          'Content-Type':'application/json'
        },
        body: putRequest.toJson()
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200)
      {
        final result=Class.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
        return result;
      }
    else return null;
  }
  catch(e)
  {
    print(e);
  }
}

add_member_to_class(String address,int class_id,int member_id) async
{
  final uri=Uri.http(address,"/api/member_class",
      {
        "member_id":member_id.toString(),
        "class_id":class_id.toString()
      });
  try
  {
    var response = await http.post(
      uri,
      headers:
      {
        "Authorization": "Bearer-" + using_token,
        'Access-Control-Allow-Origin': '*',
      },
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ? response.body:"Add member $member_id to class $class_id failed!" ;
  }
  catch(e)
  {
    print(e);
  }
}

delete_member_from_class(String address,int class_id,int member_id) async
{
  final uri=Uri.http(address,"/api/member_class",
      {
        "member_id":member_id.toString(),
        "class_id":class_id.toString()
      });
  try
  {
    var response = await http.delete(
      uri,
      headers:
      {
        "Authorization": "Bearer-" + using_token,
        'Access-Control-Allow-Origin': '*',
      },
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ? response.body:"Delete member $member_id to class $class_id failed!" ;
  }
  catch(e)
  {
    print(e);
  }
}

delete_class(String address,int id) async
{
  final uri=Uri.http(address,"/api/class",
      {
        "id":id.toString()
      });
  try
  {
    var response = await http.delete(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*',
        },
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200 ;
  }
  catch(e)
  {
    print(e);
  }
}

request_all_class(String address) async
{
  final uri=Uri.http(address,"/api/class/all");
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_all_classes_success");
      var ListJson=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();

      return ListJson.map((json){
        return Class.fromJson(json as Map<String,dynamic>);
      }).toList();
    })()
        : List.empty();
  }
  catch(e)
  {
    print(e);
  }
}

request_self_done_classes(String address,int member_id)async
{
  final uri=Uri.http(address,"/api/member/classes/done",
      {
        "member_id":member_id.toString()
      });
  try
  {
    var response = await http.get(
        uri,
        headers:
        {
          "Authorization": "Bearer-" + using_token,
          'Access-Control-Allow-Origin': '*'
        }
    ).timeout(Duration(seconds: 10));
    return response.statusCode == 200
        ?
    (() {
      print("request_done_classes_success");
      var ListJson=(jsonDecode(response.body) as List).cast<Map<String,dynamic>>();

      return ListJson.map((json){
        bool isPresent=json["is_present"] as bool;
        double attendancePercents=json["attendance_percents"] as double;
        Class aClass=Class.fromJson(json["class"] as Map<String,dynamic>);
        return <String,dynamic>{
          "isPresent":isPresent,
          "attendancePercents":attendancePercents,
          "class":aClass
        };
      }).toList();
    })()
        : List.empty();
  }
  catch(e)
  {
    print(e);
  }
}
