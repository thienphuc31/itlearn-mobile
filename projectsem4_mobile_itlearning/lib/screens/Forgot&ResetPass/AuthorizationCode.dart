import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/ForgotPassProvider.dart';
import '../../widgets/BackgroundLogoWidget.dart';

import '../../widgets/ExampleSnackbar.dart';
import 'AuthorizationCode.dart';
import 'ResetPasswordScreen.dart';
 // Import trang NhapMaXacThuc

class AuthorizationCode extends StatefulWidget {
  final String email; // Trường email từ trang ForgotPassMain

  AuthorizationCode({required this.email});

  @override
  _AuthorizationCodeState createState() => _AuthorizationCodeState();
}

class _AuthorizationCodeState extends State<AuthorizationCode> {
  int _resendCountdown = 5; // Thời gian đếm ngược ban đầu (60 giây)
  bool _isCountdownActive = false; // Biến để kiểm tra xem đang trong quá trình đếm ngược hay 0
  bool _showResendButton = false;
  @override
  void initState() {
    super.initState();
    startCountdown(); // Start the countdown when the screen is initialized.
  }
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());
  Future<bool> checkTokenValidity(BuildContext context, String enteredToken) async {
    final tokenFromProvider = Provider.of<ForgotPassProvider>(context, listen: false).getToken();

    if (enteredToken == tokenFromProvider) {
      return true;
    } else {
      SnackBarShowError(context, "Invalid token"); // Hiển thị thông báo token không hợp lệ
      return false;
    }
  }
  void startCountdown() {
    setState(() {
      _isCountdownActive = true;

    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _isCountdownActive = false;
          _showResendButton = true;
          timer.cancel();
          // Hủy bỏ timer khi hết thời gian
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password",style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, // Đổi màu chữ của nút điều hướng thành màu đen
        ),
      ),
      body: BackgroundLogoWidget(
        bodycontent: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Code has been sent to: ${widget.email}',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: screenWidth * 0.17,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center, // Căn giữa số nhập vào ô
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(),
                        counterText: "",
                        filled: true,
                        fillColor: primaryColor,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 3) {
                            focusNodes[index].unfocus();
                            focusNodes[index + 1].requestFocus();
                          } else {
                            focusNodes[index].unfocus();
                          }
                        } else {
                          if (index > 0) {
                            focusNodes[index].unfocus();
                            focusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                    ),
                  );
                }),
              ),

              SizedBox(height: 80),

              // Trong phần onTap của InkWell "Verify"
              InkWell(
                onTap: () async {
                  String enteredToken = controllers.map((controller) => controller.text).join();

                  bool isValid = await checkTokenValidity(context, enteredToken);

                  if (isValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(token: enteredToken),
                      ),
                    );
                  } else {
                    // Xử lý trường hợp mã token không hợp lệ
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: secondaryGreen,
                        borderRadius: BorderRadius.circular(38),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_isCountdownActive)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Color for "Resend code in" and "seconds"
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "Resend code in "),
                            TextSpan(
                              text: "$_resendCountdown",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryBlue, // Color for $_resendCountdown (primaryBlue)
                              ),
                            ),
                            TextSpan(text: " seconds"),
                          ],
                        ),
                      ), // Hiển thị thời gian đếm ngược
                    if (_showResendButton)
                      TextButton(
                        onPressed: () {
                          Provider.of<ForgotPassProvider>(context, listen: false)
                              .sendVerifyCode(widget.email, context);
                          setState(() {
                            _resendCountdown = 5;
                            _showResendButton = false;
                            startCountdown();
                          }); // Gửi lại mã xác minh khi nhấn "Resend"
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh, // Replace with the icon you want
                              color: Colors.black45, // Change the icon color to blue or your preferred color
                            ),
                            SizedBox(width: 5), // Adjust the spacing between the icon and text
                            Text(
                              "Resend code",
                              style: TextStyle(
                                color: primaryBlue, // Change the text color to blue or your preferred color

                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),





              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
