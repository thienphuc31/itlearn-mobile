import 'package:flutter/material.dart';

import '../constants/colors.dart';

Widget GachNgangCoChuOGiua(String content){
  return  Container(
    color: Colors.transparent, // Màu nền cho Container
    child: Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: inputBox, // Màu của gạch ngang
            thickness: 1, // Độ dày của gạch ngang
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), // Khoảng cách giữa gạch và chữ
          child: Text(
            content,
            style: TextStyle(
                color: Color.fromRGBO(147, 147, 147, 1) ,
                fontSize: 12,
                fontWeight: FontWeight.bold

            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: inputBox,
            thickness: 1,
          ),
        ),
      ],
    ),
  );
}