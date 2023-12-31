import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/LoginProvider.dart';
import '../../widgets/BackgroundLogoWidget.dart';
import '../../widgets/GachNgangCoChuOGiua.dart';
import '../../widgets/MauInput2.dart';


class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  final formKey = GlobalKey<FormState>();
  TextEditingController txt_Username = TextEditingController();
  TextEditingController txt_Password = TextEditingController();
  FocusNode fc_Username = FocusNode();
  FocusNode fc_Password = FocusNode();

  @override
  Widget build(BuildContext context) {
    var loginProviderLoaing =
        Provider.of<LoginProvider>(context, listen: true).Loading;
    TextSpan forgotPasswordText = TextSpan(
      text: "Forgot the password?",
      style: TextStyle(
        fontSize: 14,
        color: primaryBlue,

      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.pushNamed(context, '/Forgot'); // Điều hướng tới trang ForgotPassword
        },
    );
    return GestureDetector(
      onTap: () {
        // Ẩn bàn phím và hủy focus khi người dùng nhấp ngoài
        FocusScope.of(context).unfocus();
      },
      child: BackgroundLogoWidget(
        bodycontent: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only( top: 80, bottom: 20),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Đặt văn bản bên phải
                      children: [
                        Text(
                          "Login to your",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4), // Khoảng cách giữa hai hàng
                        Text(
                          "Account",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )

                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MauInput2(

                    placeholder: "Username",
                    controller: txt_Username,
                    kieuValidate: "username",
                    currentFocus: fc_Username,
                  ),
                  MauInput2(
                    password: true,
                    placeholder: "Password",
                    controller: txt_Password,
                    kieuValidate: "passwordLogin",
                    currentFocus: fc_Password,
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Provider.of<LoginProvider>(context, listen: false)
                            .dangnhap(txt_Username.text, txt_Password.text, context);
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
                                  "Sign In",
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
                  SizedBox(
                    height: 8,
                  ),
                  Center( // Bao bọc dòng chữ trong Center
                    child: RichText(
                      text: TextSpan(
                        children: [forgotPasswordText], // Sử dụng biến forgotPasswordText ở đây
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GachNgangCoChuOGiua("or continue with"),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/Login/Icon_google.png"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: 15, color: Color.fromRGBO(147, 147, 147, 0.7) ),
                          children: [
                            TextSpan(text: "Don't have an account?"),
                            TextSpan(
                              text: ' Sign up',
                              style: TextStyle(color: primaryBlue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Đoạn này thực hiện điều hướng khi người dùng bấm vào "Đăng ký"
                                  Navigator.pushNamed(context, '/Register');
                                },
                            )
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //
                  // InkWell(
                  //   onTap: () {
                  //     // Provider.of<AccountProvider>(context,listen: false).logOut();
                  //     Navigator.pushNamedAndRemoveUntil(context, "/Main", (route) => false);
                  //   },
                  //   child: Center(
                  //     child: Container(
                  //       width: 50,
                  //       height: 50,
                  //       child: Icon(
                  //         Icons.home,
                  //         color: Colors.white,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Colors.pinkAccent,
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
