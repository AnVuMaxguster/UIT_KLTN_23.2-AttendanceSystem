import 'dart:math';

import 'package:attendace_manager_flutter_app/desktop/desktop_class_screen/_desktop_class_screen_dialogs.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_details_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class desktop_class_screen extends ConsumerWidget {

  final List<Class> demo=[
    Class(1, "Math", DateTime.now(), DateTime.now(), "None", List.empty(), List.empty(), "testing"),
    Class(2, "Math", DateTime.now(), DateTime.now(), "None", List.empty(), List.empty(), "testing"),
    Class(30000000, "Math", DateTime.now(), DateTime.now(), "None", List.empty(), List.empty(), "testing")
  ];
  final Search_box_controller=TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                              child: Container(
                                child: Text(
                                  overflow: TextOverflow.visible,
                                    softWrap: false,
                                    "Class\n\t\t\t\tManager",
                                    style:GoogleFonts.rem(
                                      textStyle:TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        letterSpacing: 2,
                                        height: 0.8
                                      ),
                                    )
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),

                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                        "Add",
                                        style:GoogleFonts.robotoMono(
                                          textStyle:TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                onPressed: ()
                                {
                                  // ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).create_class(ref, Class.name(subject: "testing", start_time: DateTime.parse("2024-05-25 09:00"), end_time: DateTime.parse("2024-05-25 10:00"), className: "MCLL2020"));
                                  ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).showCustom_Dialog(context, Add_class_dialog());
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:20),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: Offset(3,3),
                                      spreadRadius: 3,
                                      blurRadius: 5
                                    )
                                  ]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                          Icons.search,
                                        color: Colors.green,
                                      ),
                                      hintText: "Class name..."
                                    ),
                                    controller: Search_box_controller,
                                      style:GoogleFonts.robotoMono(
                                        textStyle:TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: (){},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 80,
                                  child: Center(
                                    child: Text(
                                      "Search",
                                        style:GoogleFonts.robotoMono(
                                          textStyle:TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.grey.withOpacity(0.2),
                    //       blurRadius: 3,
                    //       spreadRadius: 5,
                    //       offset: Offset(3,3)
                    //   ),
                    // ],
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).classes.length,
                      // itemCount: demo.length,
                      itemBuilder: (context,index)
                      {
                        Class currentClass=ref.watch(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).classes[index];
                        // Class currentClass=demo[index];
                        return class_box_item_builder(
                          item: currentClass,
                          isFirstItem: index==0,
                          detail_function: ()
                          {
                            ref.read(desktop_class_details_screen_Controller as ChangeNotifierProvider<Desktop_class_details_changNotifier>)
                            .filter_temp_class_members(
                              ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).allStudents,
                              currentClass.members_id as List<int>
                            );
                            ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).showCustom_Dialog(context, Detail_class_diaglog(currentClass));
                          },
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
            )
          ],
        ),
      ),
    );
  }
}
class class_box_item_builder extends ConsumerWidget {
  final Class item;
  final bool isFirstItem;
  final column_fraction=[5,30,25,25,15];
  final detail_function;
  class_box_item_builder({required this.item,required this.isFirstItem, this.detail_function});
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
                      custom_table_column(fraction_width:column_fraction[1],data:"Class name",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[2],data:"Start time",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[3],data:"End time",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[4],data:" ",isHeader: true),
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
                custom_table_column(fraction_width:column_fraction[1],data:item.className),
                custom_table_column(fraction_width:column_fraction[2],data:DateFormat("dd/MM/yyyy HH:mm").format(item.start_time)),
                custom_table_column(fraction_width:column_fraction[3],data:DateFormat("dd/MM/yyyy HH:mm").format(item.end_time)),
                Expanded(
                  flex: column_fraction[4],
                  child: Container(
                    child: ElevatedButton(
                        onPressed: detail_function,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                        child: Text(
                            "Detail",
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
class custom_table_column extends ConsumerWidget
{
  final fraction_width;
  final data;
  final isHeader;
  const custom_table_column({super.key, required this.fraction_width,required this.data, this.isHeader=false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: fraction_width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          // color: (()
          // {
          //   if((Random()).nextInt(100)%2==0) return Colors.green;
          //   return Colors.blue;
          // })(),
          child: Text(
              data,
              style:GoogleFonts.robotoMono(
                textStyle:TextStyle(
                  color: Colors.black,
                  fontWeight: ((){
                    if(isHeader)
                      {
                        return FontWeight.bold;
                      }
                    return FontWeight.normal;
                  })(),
                  fontSize: ((){
                    if (isHeader)
                      {
                        return 15.0;
                      }
                    return 20.0;
                  })(),
                ),
              )
          ),
        ),
      ),
    );
  }

}