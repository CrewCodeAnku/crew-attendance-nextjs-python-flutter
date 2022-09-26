import 'package:flutter/material.dart';

MaterialButton longButtons(String title, VoidCallback fun,
    {Color color = const Color(0xfff063057), Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    height: 45,
    minWidth: 600,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration({hintText, icon}) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    filled: true, //<-- SEE HERE
    fillColor: Colors.lightBlue.shade100,
    //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}
