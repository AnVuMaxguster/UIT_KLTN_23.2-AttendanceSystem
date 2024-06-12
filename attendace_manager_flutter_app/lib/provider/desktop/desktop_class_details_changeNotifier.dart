import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/models/PutRequest.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Desktop_class_details_changNotifier extends ChangeNotifier {
  DateTime _temp_edit_start_time = DateTime.now();
  DateTime _temp_edit_end_time = DateTime.now();
  String _temp_class_name = "";
  String _temp_class_subject = "";
  bool _use_temp_start_time = false;
  bool _use_temp_end_time = false;
  bool _use_temp_class_name = false;
  bool _use_temp_class_subject = false;
  Color _loading_condition = Colors.transparent;
  List<Member> _temp_class_members = [];
  List<Member> _temp_off_class_members = [];

  Desktop_class_details_changNotifier();

  bool get use_temp_class_subject => _use_temp_class_subject;

  set use_temp_class_subject(bool value) {
    _use_temp_class_subject = value;
    notifyListeners();
  }

  bool get use_temp_class_name => _use_temp_class_name;

  set use_temp_class_name(bool value) {
    _use_temp_class_name = value;
    notifyListeners();
  }

  bool get use_temp_end_time => _use_temp_end_time;

  set use_temp_end_time(bool value) {
    _use_temp_end_time = value;
    notifyListeners();
  }


  List<Member> get temp_off_class_members => _temp_off_class_members;

  set temp_off_class_members(List<Member> value) {
    _temp_off_class_members = value;
    notifyListeners();
  }

  bool get use_temp_start_time => _use_temp_start_time;

  set use_temp_start_time(bool value) {
    _use_temp_start_time = value;
    notifyListeners();
  }

  String get temp_class_subject => _temp_class_subject;

  set temp_class_subject(String value) {
    _temp_class_subject = value;
    notifyListeners();
  }

  String get temp_class_name => _temp_class_name;

  set temp_class_name(String value) {
    _temp_class_name = value;
    notifyListeners();
  }

  DateTime get temp_edit_end_time => _temp_edit_end_time;

  set temp_edit_end_time(DateTime value) {
    _temp_edit_end_time = value;
    notifyListeners();
  }

  DateTime get temp_edit_start_time => _temp_edit_start_time;

  set temp_edit_start_time(DateTime value) {
    _temp_edit_start_time = value;
    notifyListeners();
  }


  Color get loading_condition => _loading_condition;

  set loading_condition(Color value) {
    _loading_condition = value;
    notifyListeners();
  }


  List<Member> get temp_class_members => _temp_class_members;


  set temp_class_members(List<Member> value) {
    _temp_class_members = value;
  }

  bool areTempMembersModified(Class currentClass) {
    List<int> temp_members_class_id = _temp_class_members.map((e) => e.id)
        .toList();
    List<int> official_member_class_id = currentClass.members_id as List<int>;
    temp_members_class_id.sort();
    official_member_class_id.sort();
    return !ListEquality<int>().equals(
        temp_members_class_id, official_member_class_id);
  }

  void switchMember(Member member) {
    if (_temp_class_members.contains(member)) {
      _temp_class_members.remove(member);
      _temp_off_class_members.add(member);
    }
    else {
      _temp_off_class_members.remove(member);
      _temp_class_members.add(member);
    }
    notifyListeners();
  }

  void filter_temp_class_members(List<Member> allList, List<int>filterList) {
    final List<Member> tempList = [];
    final List<Member> tempOffList = [];
    for (Member member in allList) {
      if (filterList.contains(member.id))
        tempList.add(member);
      else
        tempOffList.add(member);
    }
    _temp_class_members = tempList;
    _temp_off_class_members = tempOffList;
    notifyListeners();
  }

  void reset() {
    _temp_class_name = "";
    _temp_class_subject = "";
    _temp_edit_end_time = DateTime.now();
    _temp_edit_start_time = DateTime.now();
    _use_temp_class_name = false;
    _use_temp_class_subject = false;
    _use_temp_start_time = false;
    _use_temp_end_time = false;
    _temp_class_members = [];
    _temp_off_class_members = [];
    notifyListeners();
  }

  bool anyChange(Class currentClass) {
    if (_use_temp_end_time || _use_temp_start_time || _use_temp_class_subject ||
        _use_temp_class_name || areTempMembersModified(currentClass))
      return true;
    return false;
  }

  delete_class_by_id(WidgetRef ref, int class_id) async
  {
    try {
      final result = await delete_class(
          ref
              .watch(first_screen_Controller as ChangeNotifierProvider<
              First_Screen_Controller>)
              .ipAddress,
          class_id
      );
      if (result) {
        print("Class id " + class_id.toString() + " has been deleted.");
        ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<
            Desktop_class_changeNotifier>).get_all_class(ref);
      }
      return result;
    }
    catch (Exception) {
      print(Exception.toString());
      return false;
    }
  }

  compose_and_put_all_changes_to_class_by_id(WidgetRef ref,Class currentClass) async
  {
    int class_id=currentClass.id;
    Class? final_class = null;
    if (use_temp_class_name) {
      final result = await put_class_by_id(
          ref, PutRequest(class_id, "setClass_name", temp_class_name));
      if (result != null) final_class = result;
    }
    if (use_temp_class_subject) {
      final result = await put_class_by_id(
          ref, PutRequest(class_id, "setSubject", temp_class_subject));
      if (result != null) final_class = result;
    }
    if (use_temp_start_time) {
      final result = await put_class_by_id(
          ref, PutRequest(class_id, "setStart_time", temp_edit_start_time));
      if (result != null) final_class = result;
    }
    if (use_temp_end_time) {
      final result = await put_class_by_id(
          ref, PutRequest(class_id, "setEnd_time", temp_edit_end_time));
      if (result != null) final_class = result;
    }
    if (areTempMembersModified(currentClass)) {
      Set<int>
      temp_members_class_id = _temp_class_members.map((e) => e.id).toSet(),
          original_class_members=(currentClass.members_id as List<int>).toSet();
      final append_members_id=temp_members_class_id.difference(original_class_members);
      final eject_members_id=original_class_members.difference(temp_members_class_id);

      for (int member_id in append_members_id) {
        final addMemberResult = await add_member_to_class(
            ref
                .watch(first_screen_Controller as ChangeNotifierProvider<
                First_Screen_Controller>)
                .ipAddress,
            class_id,
            member_id);
        print(addMemberResult);
      }
      for (int member_id in eject_members_id)
        {
          final deleteMemberResult= await delete_member_from_class(
              ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
              class_id,
              member_id);
          print(deleteMemberResult);
        }
      if(final_class==null) final_class=currentClass;
    }

    if (final_class != null) return final_class;
    return null;
  }
}

  put_class_by_id(WidgetRef ref, PutRequest putRequest) async
  {
    try
        {
          final result=await put_class(
            ref.watch(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
            putRequest
          );
          if (result!=null)
            print("Put "+putRequest.toJson()+" Successed");
          else
            print("Put "+putRequest.toJson()+" Failed");
          return result;
  }
  catch (e)
    {
      print(e.toString());
      return null;
    }
}