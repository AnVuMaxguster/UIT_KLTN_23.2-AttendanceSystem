
import 'package:attendace_manager_flutter_app/desktop/desktop_class_screen/desktop_class_screen.dart';
import 'package:attendace_manager_flutter_app/desktop/desktop_ultilities.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_details_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Add_class_dialog extends ConsumerWidget
{
  final class_name_controller=TextEditingController();
  final class_subject_controller=TextEditingController();
  final column_fractions=[20,15,15,15,15,10];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      elevation: 30,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        height: 600,
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: column_fractions[0],
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column
                      (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Create Class",
                            style:GoogleFonts.rem(
                              textStyle:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  letterSpacing: 2
                              ),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              "Please fill the following required initial information fields to create a class.",
                              style:GoogleFonts.robotoMono(
                                textStyle:TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[1],
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 1,
                    child: Container(
                      child: TextField(
                        controller: class_name_controller,
                        style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )
                        ),
                        decoration:InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          label: Text(
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                              ),
                              "Class name"
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[2],
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 1,
                    child: Container(
                      child: TextField(
                        controller: class_subject_controller,
                        style:GoogleFonts.robotoMono(
                            textStyle:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )
                        ),
                        decoration:InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          label: Text(
                              style:GoogleFonts.robotoMono(
                                  textStyle:TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                              ),
                              "Class subject"
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex:column_fractions[3],
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Class start time",
                                style:GoogleFonts.robotoMono(
                                    textStyle:TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        wordSpacing: 0.5
                                    )
                                ),
                              ),
                              Text(
                                  DateFormat("dd/MM/yyyy HH:mm").format(ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_startTime),
                                  style:GoogleFonts.robotoMono(
                                      textStyle:TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 30,
                                          wordSpacing: 1
                                      )
                                  )
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () async
                              {
                                DateTime? datetime=await show_pick_date_time(ref, context);
                                if(datetime!=null)
                                  ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_startTime=datetime;
                              },
                              icon: Icon(
                                size: 40,
                                CupertinoIcons.time,
                                color: Colors.green,
                              )
                          )
                        ],
                      )
                  )
              ),
              Expanded(
                  flex:column_fractions[4],
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Class end time",
                                style:GoogleFonts.robotoMono(
                                    textStyle:TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        wordSpacing: 0.5
                                    )
                                ),
                              ),
                              Text(
                                  (()
                                  {
                                    DateTime endtime=ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_endTime;
                                    return DateFormat("dd/MM/yyyy HH:mm").format(endtime);
                                  })(),
                                  style:GoogleFonts.robotoMono(
                                      textStyle:TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 30,
                                          wordSpacing: 1
                                      )
                                  )
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () async
                              {
                                DateTime? datetime=await show_pick_date_time(ref, context);
                                if(datetime!=null)
                                  ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_endTime=datetime;
                              },
                              icon: Icon(
                                size: 40,
                                CupertinoIcons.time,
                                color: Colors.green,
                              )
                          )
                        ],
                      )
                  )
              ),
              Expanded(
                  flex:column_fractions[5],
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Visibility(
                          visible: !ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).add_class_loading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: custom_confirm_button(() async
                                {
                                  if(class_subject_controller.text!="" && class_name_controller.text!="") {
                                    ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).add_class_loading=true;
                                    bool result = await ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).create_class(
                                        ref,
                                        Class.name(
                                            subject:
                                            class_subject_controller.text,
                                            start_time: ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_startTime,
                                            end_time: ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).temp_Add_class_endTime,
                                            className: class_name_controller.text));
                                    ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).add_class_loading=false;
                                    if (result) {
                                      Navigator.of(context).pop();
                                      ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).reset_temp_class_times();
                                    }
                                  }
                                })
                              ),
                              custom_cancel_button(()
                              {
                                Navigator.of(context).pop();
                                ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).reset_temp_class_times();
                              })
                            ],
                          ),
                        ),
                        Visibility(
                            visible: ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).add_class_loading,
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  ],
                                )
                            )
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class Detail_class_diaglog extends ConsumerWidget
{
  final Class current_class;
  final column_fractions=[1,1,1,3];
  Detail_class_diaglog(this.current_class);
  final class_name_controller=TextEditingController();
  final class_subject_controller=TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      elevation: 30,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        height: 600,
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              "Class "+current_class.id.toString(),
                              style:GoogleFonts.rem(
                                textStyle:TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    letterSpacing: 2
                                ),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Stack(
                              children: [
                                Visibility(
                                    visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition!=Colors.transparent,
                                    child: Container(
                                        height: double.infinity,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            CircularProgressIndicator(
                                              color: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition,
                                            ),
                                          ],
                                        )
                                    )
                                ),
                                Visibility(
                                  visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).anyChange(current_class),
                                        child: custom_confirm_button(()async {
                                          ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition=Colors.green;
                                          ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_subject=class_subject_controller.text;
                                          ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_name=class_name_controller.text;
                                          final changed_class= await ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).compose_and_put_all_changes_to_class_by_id(ref, current_class);
                                          if(changed_class!=null)
                                            {
                                              ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition=Colors.transparent;
                                              Navigator.of(context).pop();
                                              ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).reset();
                                              ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).get_all_class(ref);

                                            }
                                          else
                                            {
                                              ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition=Colors.transparent;
                                              ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).reset();
                                            }
                                        }),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: custom_delete_button(()async
                                          {
                                            ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition=Colors.red;
                                            final result = await ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).delete_class_by_id(ref, current_class.id);
                                            if (result)
                                            {
                                              Navigator.of(context).pop();
                                            }
                                            ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition=Colors.transparent;
                                            ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).reset();
                                          })
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: ()
                          {
                            Navigator.of(context).pop();
                            ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).reset();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    height: 1000,
                    child: Column(
                      children: [
                        Expanded(
                            flex: column_fractions[0],
                            child: _detail_class_dialog_information_section_template(
                                "Class Time",
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Start time",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        DateFormat("dd/MM/yyyy HH:mm").format(((){
                                                          if(ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_start_time)
                                                            return ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_edit_start_time;
                                                          return current_class.start_time;
                                                        })()),
                                                        style:GoogleFonts.robotoMono(
                                                          textStyle:TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 20,
                                                          ),
                                                        )
                                                    ),
                                                    Visibility(
                                                      visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: ((){
                                                          if (ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_start_time)
                                                          {
                                                            return IconButton(
                                                              icon: Icon(
                                                                Icons.undo_rounded,
                                                                size: 30,
                                                                color: Colors.red,
                                                              ),
                                                              onPressed: () async
                                                              {
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .use_temp_start_time = false;
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .temp_edit_start_time = DateTime.now();

                                                              },
                                                            );
                                                          }
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              size: 30,
                                                              color: Colors.green,
                                                            ),
                                                            onPressed: () async
                                                            {
                                                              DateTime? datetime=await show_pick_date_time(ref, context);
                                                              if(datetime!=null) {
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .use_temp_start_time = true;
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .temp_edit_start_time = datetime;
                                                              }
                                                            },
                                                          );
                                                        })()
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "End time",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        DateFormat("dd/MM/yyyy HH:mm").format(((){
                                                          if(ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_end_time)
                                                            return ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_edit_end_time;
                                                          return current_class.end_time;
                                                        })()),
                                                        style:GoogleFonts.robotoMono(
                                                          textStyle:TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 20,
                                                          ),
                                                        )
                                                    ),
                                                    Visibility(
                                                      visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: ((){

                                                          if (ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_end_time)
                                                            {
                                                              return IconButton(
                                                                icon: Icon(
                                                                  Icons.undo_rounded,
                                                                  size: 30,
                                                                  color: Colors.red,
                                                                ),
                                                                onPressed: () async
                                                                {
                                                                    ref
                                                                        .read(desktop_class_details_screen_Controller
                                                                    as ChangeNotifierProvider<
                                                                        Desktop_class_details_changNotifier>)
                                                                        .use_temp_end_time = false;
                                                                    ref
                                                                        .read(desktop_class_details_screen_Controller
                                                                    as ChangeNotifierProvider<
                                                                        Desktop_class_details_changNotifier>)
                                                                        .temp_edit_end_time = DateTime.now();

                                                                },
                                                              );
                                                            }
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              size: 30,
                                                              color: Colors.green,
                                                            ),
                                                            onPressed: () async
                                                            {
                                                              DateTime? datetime=await show_pick_date_time(ref, context);
                                                              if(datetime!=null)
                                                              {
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .use_temp_end_time = true;
                                                                ref
                                                                    .read(desktop_class_details_screen_Controller
                                                                as ChangeNotifierProvider<
                                                                    Desktop_class_details_changNotifier>)
                                                                    .temp_edit_end_time = datetime;
                                                              }
                                                            },
                                                          );
                                                        })()
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            )
                        ),
                        Expanded(
                            flex: column_fractions[1],
                            child: _detail_class_dialog_information_section_template(
                                "Class Information",
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Class name",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child:(()
                                                  {
                                                    if(!ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).anyChange(current_class))
                                                      class_name_controller.text=current_class.className;
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              controller: class_name_controller,
                                                              enabled: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_name &&
                                                                  ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                              decoration: InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey,
                                                                        width: 2
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(15)
                                                                ),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.black,
                                                                        style: BorderStyle.none,
                                                                        width: 1
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(15)
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.green,
                                                                        width: 3
                                                                    ),
                                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                                ),
                                                              ),
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle:TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: ((){
                                                                    if(ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_name)
                                                                      return FontWeight.normal;
                                                                    return FontWeight.bold;
                                                                  })(),
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              child: ((){
                                                                if(ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_name) {
                                                                  return IconButton(
                                                                    icon: Icon(
                                                                      Icons.undo_outlined,
                                                                      size: 30,
                                                                      color: Colors.red,
                                                                    ),
                                                                    onPressed: ()
                                                                    {
                                                                      class_name_controller.text=current_class.className;
                                                                      ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_name=false;
                                                                    },
                                                                  );
                                                                }
                                                                return IconButton(
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                    size: 30,
                                                                    color: Colors.green,
                                                                  ),
                                                                  onPressed: ()
                                                                  {
                                                                    ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_name=class_name_controller.text;
                                                                    ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_name=true;
                                                                  },
                                                                );
                                                              })()
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  })()
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Class subject",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child:(()
                                                  {
                                                    if(!ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).anyChange(current_class))
                                                      class_subject_controller.text=current_class.subject;
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              controller: class_subject_controller,
                                                              enabled: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_subject &&
                                                                  ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                              decoration: InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey,
                                                                        width: 2
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(15)
                                                                ),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.black,
                                                                        style: BorderStyle.none,
                                                                        width: 1
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(15)
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.green,
                                                                        width: 3
                                                                    ),
                                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                                ),
                                                              ),
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle:TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: ((){
                                                                    if(ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_subject)
                                                                      return FontWeight.normal;
                                                                    return FontWeight.bold;
                                                                  })(),
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).loading_condition==Colors.transparent,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              child: Container(
                                                                child: (() {
                                                                  if (ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_subject) {
                                                                    return IconButton(
                                                                        icon: Icon(
                                                                          Icons.undo_rounded,
                                                                          size: 30,
                                                                          color: Colors.red,
                                                                        ),
                                                                        onPressed: () {
                                                                          class_subject_controller.text = current_class.subject;
                                                                          ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_subject = false;
                                                                        }
                                                                    );
                                                                  }
                                                                  return IconButton(
                                                                    icon: Icon(
                                                                      Icons.edit,
                                                                      size: 30,
                                                                      color: Colors.green,
                                                                    ),
                                                                    onPressed: () {
                                                                      ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_subject=class_subject_controller.text;
                                                                      ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).use_temp_class_subject = true;
                                                                    },
                                                                  );
                                                                })()
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  })()
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            )
                        ),
                        Expanded(
                            flex: column_fractions[2],
                            child: _detail_class_dialog_information_section_template(
                                "Others",
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Videos footage",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                                child: SizedBox(
                                                  width: 190,
                                                  child: custom_button((){

                                                  }, CupertinoIcons.videocam_circle, "Videos footage",Colors.blueAccent),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "BLE logs",
                                                  style:GoogleFonts.robotoMono(
                                                    textStyle:TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                                child: SizedBox(
                                                  width: 150,
                                                  child: custom_button((){

                                                  }, Icons.code, "BLE logs",Colors.black54),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            )
                        ),
                        Expanded(
                            flex: column_fractions[3],
                            child:  _detail_class_dialog_information_section_template(
                                "Class Members",
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Members of class",
                                                style:GoogleFonts.robotoMono(
                                                  textStyle:TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20 ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_members.length,
                                                    itemBuilder: (context,index)
                                                    {
                                                      Member currentMember=ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_class_members[index];
                                                      // Class currentClass=demo[index];
                                                      return _Student_box_item_builder(
                                                        item: currentMember,
                                                        isFirstItem: index==0,
                                                        detail_function: ()
                                                        {
                                                          ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).switchMember(currentMember);
                                                        },
                                                        button_name: "Eject",
                                                      );
                                                    },

                                                    separatorBuilder: (BuildContext context, int index)
                                                    {
                                                      return const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 50),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Free members",
                                                style:GoogleFonts.robotoMono(
                                                  textStyle:TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20 ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: ((){
                                                      return ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_off_class_members.length;
                                                    })(),
                                                    itemBuilder: (context,index)
                                                    {
                                                      Member currentMember=ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).temp_off_class_members[index];
                                                      // Class currentClass=demo[index];
                                                      return _Student_box_item_builder(
                                                        item: currentMember,
                                                        isFirstItem: index==0,
                                                        detail_function: ()
                                                        {
                                                          ref.watch(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>).switchMember(currentMember);
                                                        },
                                                        button_name: "Add",
                                                      );
                                                    },

                                                    separatorBuilder: (BuildContext context, int index)
                                                    {
                                                      return const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 50),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class _detail_class_dialog_information_section_template extends ConsumerWidget
{
  final Widget content_widget;
  final String title;
  _detail_class_dialog_information_section_template(this.title,this.content_widget);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 20,
            child: Column(
              children: [
                Text(
                    title,
                    style:GoogleFonts.rem(
                      textStyle:TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                ),
                Container(
                  height: 2,
                  width: 170,
                  color: Colors.black,
                ),
              ],
            ),
          ),

          Expanded(
            flex: 80,
            child: content_widget,
          )
        ],
      ),
    );
  }

}

class _Student_box_item_builder extends ConsumerWidget {
  final Member item;
  final bool isFirstItem;
  final column_fraction=[10,60,30];
  final detail_function;
  final String button_name;

  _Student_box_item_builder({required this.item, required this.isFirstItem, required this.detail_function,required this.button_name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      children: [
        ((){
          if(isFirstItem)
          {
            return Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    custom_table_column(fraction_width:column_fraction[0],data:"ID",isHeader: true,),
                    custom_table_column(fraction_width:column_fraction[1],data:"Member name",isHeader: true),
                    custom_table_column(fraction_width:column_fraction[2],data:"",isHeader: true),
                  ],
                ),
              ),
            );
          }
          return Container(height: 0,color: Colors.transparent,);
        })(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                custom_table_column(fraction_width:column_fraction[0],data:item.id.toString()),
                custom_table_column(fraction_width:column_fraction[1],data:item.name),
                Expanded(
                  flex: column_fraction[2],
                  child: Container(
                    child: ElevatedButton(
                        onPressed: detail_function,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                        child: Text(
                            button_name,
                            style:GoogleFonts.robotoMono(
                              textStyle:TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            )
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
