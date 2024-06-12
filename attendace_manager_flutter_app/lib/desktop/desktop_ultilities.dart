
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<DateTime?> show_pick_date_time(WidgetRef ref,BuildContext context) async
{
  DateTime? date= await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  if(date==null) return null;
  TimeOfDay? time=await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now());
  if(time==null) return null;
  var final_date=DateTime(date.year,date.month,date.day,time.hour,time.minute);
  return final_date;
}

class custom_confirm_button extends ConsumerWidget {

  final Function _onPressButton;


  custom_confirm_button(this._onPressButton);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(3,3),
                blurRadius: 10,
                spreadRadius: 3
            )
          ]
      ),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
        ),
        onPressed: (){
          _onPressButton();
        },
        child: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.lightGreen,
              size: 30,
            ),
            Text(
                "Confirm",
                style:GoogleFonts.robotoMono(
                    textStyle:TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}

class custom_cancel_button extends ConsumerWidget {

  final Function _onPressButton;


  custom_cancel_button(this._onPressButton);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(3,3),
                blurRadius: 10,
                spreadRadius: 3
            )
          ]
      ),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
        ),
        onPressed: ()
        {
          _onPressButton();
        },
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 30,
            ),
            Text(
                "Cancel",
                style:GoogleFonts.robotoMono(
                    textStyle:TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}

class custom_delete_button extends ConsumerWidget {

  final Function _onPressButton;


  custom_delete_button(this._onPressButton);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(3,3),
                blurRadius: 10,
                spreadRadius: 3
            )
          ]
      ),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
        ),
        onPressed: ()
        {
          _onPressButton();
        },
        child: Row(
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 30,
            ),
            Text(
                "Delete",
                style:GoogleFonts.robotoMono(
                    textStyle:TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}

class custom_button extends ConsumerWidget {

  final Function _onPressButton;
  final IconData _icon;
  final String _label;
  final Color _theme;


  custom_button(this._onPressButton, this._icon, this._label,this._theme);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(3,3),
                blurRadius: 10,
                spreadRadius: 3
            )
          ]
      ),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
        ),
        onPressed: ()
        {
          _onPressButton();
        },
        child: Row(
          children: [
            Icon(
              _icon,
              color: _theme,
              size: 30,
            ),
            Text(
                _label,
                style:GoogleFonts.robotoMono(
                    textStyle:TextStyle(
                        color: _theme,
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
