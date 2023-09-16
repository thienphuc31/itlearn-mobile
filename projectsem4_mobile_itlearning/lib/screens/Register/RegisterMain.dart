import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/userRegister.dart';

import '../../providers/RegisterProvider.dart';
import '../../validate/validateAllFields.dart';
import '../../widgets/BackgroundLogoWidget.dart';
import '../../widgets/ExampleSnackbar.dart';
import '../../widgets/GachNgangCoChuOGiua.dart';
import '../../widgets/MauInput2.dart';

class RegisterMain extends StatefulWidget {
  const RegisterMain({super.key});

  @override
  State<RegisterMain> createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  var validateAF = validateAllFields();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController txt_Username = TextEditingController();
  TextEditingController txt_Email = TextEditingController();
  TextEditingController txt_Password = TextEditingController();
  TextEditingController txt_ConfirmPassword = TextEditingController();

  FocusNode fc_Username = FocusNode();
  FocusNode fc_Email = FocusNode();
  FocusNode fc_Password = FocusNode();
  FocusNode fc_ConfirmPass = FocusNode();

  //Hiển thị cho người dùng chọn năm sinh


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    validateAF = validateAllFields();
    var loadingState = Provider.of<RegisterProvider>(context).getLoading;
    return GestureDetector(
      onTap: () {
        // Ẩn bàn phím và hủy focus khi người dùng nhấp ngoài
        FocusScope.of(context).unfocus();
      },

      child: Stack(
        children: [
          BackgroundLogoWidget(
            bodycontent: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only( top: 150, bottom: 20),
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Đặt văn bản bên phải
                          children: [
                            Text(
                              "Create your",
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
                          placeholder: "Email",
                          controller: txt_Email,
                          currentFocus: fc_Email,
                          kieuValidate: "email",
                          nextFocus: fc_Username
                      ),
                      MauInput2(

                          placeholder: "Username",
                          controller: txt_Username,
                          currentFocus: fc_Username,
                          kieuValidate: "username",
                          nextFocus: fc_Password
                      ),
                      MauInput2(

                          placeholder: "Password",
                          controller: txt_Password,
                          currentFocus: fc_Password,
                          password: true,
                          nextFocus: fc_ConfirmPass,
                          kieuValidate: "password"),
                      MauInput2(
                          password: true,
                          placeholder: "Confirm Password",
                          currentFocus: fc_ConfirmPass,
                          controller: txt_ConfirmPassword,
                          kieuValidate: "password"),
                      InkWell(
                        onTap: () {
                          if(txt_Password.text != txt_ConfirmPassword.text){
                            SnackBarShowError(context,"Password confirmation do not match.");
                            return ;
                          }
                          if (formKey.currentState!.validate()) {
                            UserRegister newUser = UserRegister(
                                email: txt_Email.text,
                                password: txt_Password.text,
                                username: txt_Username.text,
                                );
                            Provider.of<RegisterProvider>(context, listen: false)
                                .register(newUser,context);
                          }

                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: loadingState ? SizedBox(height: 19,child: CircularProgressIndicator(color: Colors.blue,),):Text(
                                "Sign up",
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
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text:
                                        "You already have an account?",
                                        style: TextStyle(color: Color.fromRGBO(147, 147, 147, 0.7))),
                                    TextSpan(
                                      text: ' Sign in',
                                      style: TextStyle(color: primaryBlue,fontSize: 16),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Đoạn này thực hiện điều hướng khi người dùng bấm vào "Đăng ký"
                                          Navigator.pushNamedAndRemoveUntil(context, '/LoginMain',(route) => false);
                                        },
                                    )
                                  ])))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 75,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Điều hướng về trang trước đó
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 24),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }
}
