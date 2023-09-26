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