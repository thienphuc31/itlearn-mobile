import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/providers/ForgotPassProvider.dart';

import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/LoginProvider.dart';
import '../../widgets/BackgroundLogoWidget.dart';
import '../../widgets/GachNgangCoChuOGiua.dart';
import '../../widgets/MauInput2.dart';
import 'AuthorizationCode.dart';


class ForgotPassMain extends StatefulWidget {
  const ForgotPassMain({super.key});

  @override
  State<ForgotPassMain> createState() => _ForgotPassMainState();
}

class _ForgotPassMainState extends State<ForgotPassMain> {
  final formKey = GlobalKey<FormState>();
  TextEditingController txt_Email = TextEditingController();
  FocusNode fc_Email = FocusNode();


  @override
  Widget build(BuildContext context) {
    var loginProviderLoaing =
        Provider.of<ForgotPassProvider>(context, listen: true).Loading;

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password",style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, // Đổi màu chữ của nút điều hướng thành màu đen
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Ẩn bàn phím và hủy focus khi người dùng nhấp ngoài
          FocusScope.of(context).unfocus();
        },
        child: BackgroundLogoWidget(
          bodycontent: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10), // Khoảng cách giữa ảnh và phần nhập liệu
                      child: Image.asset(
                        'assets/images/ForgotPassword/forgotpass.jpg', // Thay 'path_to_your_image.png' bằng đường dẫn thực tế của ảnh
                        width: 400, // Điều chỉnh chiều rộng của ảnh
                        height: 250, // Điều chỉnh chiều cao của ảnh
                        fit: BoxFit.none, // Điều chỉnh cách hiển thị của ảnh
                      ),
                    ),
                    Text("Enter email which we use to reset your password",style: TextStyle(fontSize: 16, color: Colors.black)),
                    SizedBox(height: 20),
                    MauInput2(
                      placeholder: "Email",
                      controller: txt_Email,
                      kieuValidate: "username",
                      currentFocus: fc_Email,
                    ),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          String enteredEmail = txt_Email.text;
                          Provider.of<ForgotPassProvider>(context, listen: false)
                              .sendVerifyCode(txt_Email.text, context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthorizationCode(email: enteredEmail),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: loginProviderLoaing
                                ? SizedBox(
                                height: 19,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ))
                                : Text(
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(38))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
