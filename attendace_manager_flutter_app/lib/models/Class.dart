import 'dart:convert';

class Class
{
  int id;
  String subject;
  DateTime start_time;
  DateTime end_time;
  String ble_log;
  List video;
  List members_id;
  String className;

  Class(this.id, this.subject, this.start_time, this.end_time, this.ble_log,
      this.video, this.members_id,this.className);


  Class.name(
      {this.id=0,
      required this.subject,
      required this.start_time,
      required this.end_time,
      this.ble_log="",
        List? video,
        List? members_id,
      required this.className})
      :
        video =video??[],
        members_id=members_id??[];

  factory Class.fromJson(Map<String,dynamic> json)
  {
    var membersJson=(json['members'] as List).cast<Map<String,dynamic>>();
    var members_id_List=membersJson.map((member){
      try{
        var id = member['id'] as Map<String, dynamic>;
        return id['member_id'] as int;
      }catch(e)
      {
        return member['member_id'] as int;
      }
    }).toList();
    return Class(
        json['id'] as int,
        utf8.decode(json['subject'].runes.toList()),
        DateTime.parse(json["start_time"] as String).add(Duration(hours: 7)),
        DateTime.parse(json["end_time"] as String).add(Duration(hours: 7)),
        (
                () {
                  if(json["ble_log"]!=null)
                    return json["ble_log"] as String;
                  return "";
                }
        )(),
        json["video_footage_list"] as List,
        members_id_List,
        json["class_name"] as String
    );
  }
}