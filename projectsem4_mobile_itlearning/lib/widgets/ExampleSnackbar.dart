import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void SnackBarShowError(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.info,color: Colors.white,),SizedBox(width: 5,),
          Text(content),
        ],
      ),
      duration: Duration(seconds: 2), // Đặt thời gian hiển thị
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 80),
    ),
  );

}

void SnackBarShowSuccess(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_sharp,color: Colors.white,),SizedBox(width: 5,),
          Text(content),
        ],
      ),
      duration: Duration(seconds: 2), // Đặt thời gian hiển thị
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 80),
    ),
  );

}