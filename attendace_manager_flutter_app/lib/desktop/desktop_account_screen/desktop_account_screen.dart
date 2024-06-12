
import 'package:attendace_manager_flutter_app/desktop/desktop_account_screen/_desktop_account_screen_dialogs.dart';
import 'package:attendace_manager_flutter_app/models/Class.dart';
import 'package:attendace_manager_flutter_app/models/Member.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_account_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/desktop/desktop_class_changeNotifier.dart';
import 'package:attendace_manager_flutter_app/provider/riverpod_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class desktop_account_screen extends ConsumerWidget {
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
                                    "Account\n\t\t\t\tManager",
                                    style:GoogleFonts.rem(
                                      textStyle:TextStyle(
                                        color: Colors.orange,
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
                                  backgroundColor: MaterialStateProperty.all(Colors.orange)
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
                                  ref.read(desktop_class_screen_Controller as ChangeNotifierProvider<Desktop_class_changeNotifier>).showCustom_Dialog(context, Add_account_dialog());
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
                                        color: Colors.orange,
                                      ),
                                      hintText: "Account name..."
                                    ),
                                    controller: Search_box_controller,
                                      style:GoogleFonts.robotoMono(
                                        textStyle:TextStyle(
                                            color: Colors.orange,
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
                                  backgroundColor: MaterialStateProperty.all(Colors.orange),
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
                      itemCount: ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).allMembers.length,
                      // itemCount: demo.length,
                      itemBuilder: (context,index)
                      {
                        Member currentMember=ref.watch(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).allMembers[index];
                        return account_box_item_builder(
                          item: currentMember,
                          isFirstItem: index==0,
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
class account_box_item_builder extends ConsumerWidget {
  final Member item;
  final bool isFirstItem;
  final column_fraction=[5,20,20,20,25,10];
  final detail_function;

  account_box_item_builder({required this.item,required this.isFirstItem, this.detail_function});

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
                      custom_table_column(fraction_width:column_fraction[1],data:"Username",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[2],data:"Display name",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[3],data:"Role",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[4],data:"Email",isHeader: true),
                      custom_table_column(fraction_width:column_fraction[5],data:"",isHeader: true),
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
                custom_table_column(fraction_width:column_fraction[2],data:item.display_name),
                custom_table_column(fraction_width:column_fraction[3],data:item.role.name),
                custom_table_column(fraction_width:column_fraction[4],data:item.email),
                Expanded(
                  flex: column_fraction[5],
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: Offset(3,3)
                          )
                        ]
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final response=await ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).deleteAccount(ref, item.id);
                            if (response)
                              ref.read(desktop_account_Controller as ChangeNotifierProvider<Desktop_account_changeNotifier>).requestAllStudentsAndMembers(ref);
                          },
                        ),
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

