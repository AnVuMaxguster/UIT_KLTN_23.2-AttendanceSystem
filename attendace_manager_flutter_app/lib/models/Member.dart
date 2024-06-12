import 'dart:convert';

class Member
{
  int id;
  String name;
  String email;
  Role role;
  List<int> classes_id;
  String description;
  String display_name;

  Member(this.id, this.name, this.email, this.role, this.classes_id,
      this.description, this.display_name);

  factory Member.fromJson(Map<String,dynamic> json)
  {
    var classesJson=(json['classes'] as List).cast<Map<String,dynamic>>();
    var classesIdList=classesJson.map((aClass){
      try{
        var id = aClass['id'] as Map<String, dynamic>;
        return id['class_id'] as int;
      }
      catch(e)
      {
        return aClass['class_id'] as int;
      }
    }).toList();
    return Member(
        json['id'] as int,
        json['username'] as String ,
        json['email'] as String ,
        RoleExtension.fromString(json['role']),
        classesIdList,
        (()
        {
          try
          {
            return utf8.decode(json['description'].runes.toList());
          }
          catch(e)
          {
            return "none";
          }
        })(),
        utf8.decode(json['display_name'].runes.toList())
    );
  }


}
enum Role {
  ADMIN,
  LECTURE,
  STUDENT

}
extension RoleExtension on Role {
  static Role fromString(String roleString) {
    switch (roleString) {
      case 'ADMIN':
        return Role.ADMIN;
      case 'LECTURE':
        return Role.LECTURE;
      case 'STUDENT':
        return Role.STUDENT;
      default:
        throw Exception('Role type not found');
    }
  }
}