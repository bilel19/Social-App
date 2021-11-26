import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';


Widget defaulttextfield({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  bool isPassword = false,
  Function? ontap,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressd,
  bool isEnable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      obscureText: isPassword,
      onChanged: (s) {
        onChange!(s);
      },
      validator: (s) {
        validate(s);
      },
      enabled: isEnable,
      onTap: () {
        ontap!();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 0.8),
        ),
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
            onPressed: () {
              suffixPressd!();
            },
            icon: Icon(suffix))
            : null,
      ),
    );

Widget defaultTextButton({
  required Function? function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function!();
      },
      child: Text(text),
    );

Widget defaultbutton({
  double width = double.infinity,
  double height=40,
  Color backgroundcolor = Colors.blue,
  required Function? function,
  double radius = 0,
  required String text,
  bool isoppercase = true,
  Color textColor=Colors.white,
  bool isBorder=false,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: () {
          function!();
        },
        child: Text(
          isoppercase ? text.toUpperCase() : text,
          style: TextStyle(color: textColor,fontWeight: FontWeight.w600),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: textColor,width: 1),
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: backgroundcolor,
      ),
    );


Widget MyDivider() => Padding(
  padding: EdgeInsets.only(left: 15),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);

void NavigatTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void NavigatAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void ShowToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ChoseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color ChoseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

