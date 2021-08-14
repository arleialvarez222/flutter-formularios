import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    //propiedades que se pasan en el widget que se llama
    required String hintText,
    required String labelText,
    IconData? prefixIcon,

  }){
    //propiedades de un input 
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2 )
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null 
        ? Icon(prefixIcon, color: Colors.deepPurple)
        : null
    );
  }
}