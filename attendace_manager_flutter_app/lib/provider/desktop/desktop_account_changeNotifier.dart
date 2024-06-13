import 'package:attendace_manager_flutter_app/data/http_requests.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/first_screen_visibility_controller.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Desktop_account_changeNotifier extends ChangeNotifier
{
  List<Member> _allStudents=[];
  List<Member> _allMembers=[];
  List<Member> _findMembers=[];
  bool _isLoading = false;
  bool _use_search_result=false;
  Desktop_account_changeNotifier();


  List<Member> get allMembers => _allMembers;

  set allMembers(List<Member> value) {
    _allMembers = value;
    notifyListeners();
  }


  List<Member> get findMembers => _findMembers;

  set findMembers(List<Member> value) {
    _findMembers = value;
    notifyListeners();
  }


  bool get use_search_result => _use_search_result;

  set use_search_result(bool value) {
    _use_search_result = value;
    notifyListeners();
  }

  List<Member> get allStudents => _allStudents;

  set allStudents(List<Member> value) {
    _allStudents = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void requestAllStudents(WidgetRef ref) async
  {
    final reponse= await request_all_students(ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress);
    if (reponse!=null)
    {
      _allStudents=reponse;
      notifyListeners();
    }
    else
      print("request all student failed");
  }

  void findMembersByUsername(WidgetRef ref,String username) async
  {
    use_search_result=true;
    if (username=="")
      {
        use_search_result=false;
        _findMembers=[];
        notifyListeners();
        return;
      }
    final response= await find_member_by_username(ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,username);
    if (response!=null)
    {
      _findMembers=response;
      notifyListeners();
    }
    else
      print("find member failed");
  }

  void requestAllMembers(WidgetRef ref) async
  {
    final reponse= await request_all_members(ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress);
    if (reponse!=null)
    {
      _allMembers=reponse;
      notifyListeners();
    }
    else
      print("request all member failed");
  }
  void requestAllStudentsAndMembers(WidgetRef ref)async
  {
    requestAllStudents(ref);
    requestAllMembers(ref);
  }

  postNewAccount(WidgetRef ref,String username,String displayName,String password,String email,Role role) async
  {
    Member member=Member(0, username, email, role, [], "", displayName);
    final response=await post_account(
        ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,
        member,
        password);
    if(response!=null && response==true)
      {
        print("request all member Success");
        return true;

      }
    print("request all member failed");
    return false;
  }
  deleteAccount(WidgetRef ref,int memberId)async
  {
    final response=await delete_account(ref.read(first_screen_Controller as ChangeNotifierProvider<First_Screen_Controller>).ipAddress,memberId);
    return response ?? false;
  }


  reset_all_member()
  {
    _allMembers=[];
    _allStudents=[];
    _findMembers=[];
    notifyListeners();
  }

}