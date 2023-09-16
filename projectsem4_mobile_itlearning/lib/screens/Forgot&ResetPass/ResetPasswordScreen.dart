import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:projectsem4_mobile_itlearning/providers/ResetPasswordProvider.dart';
import 'package:provider/provider.dart';
import '../../widgets/BackgroundLogoWidget.dart';
import '../../widgets/MauInput2.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String token;

  ResetPasswordScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Password",style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, // Đổi màu chữ của nút điều hướng thành màu đen
        ),
      ),
      body: ResetPasswordForm(token: token),
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  final String token;

  ResetPasswordForm({required this.token});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final txt_Password = TextEditingController();
  final txt_ConfirmPassword = TextEditingController();
  FocusNode fc_Password = FocusNode();
  FocusNode fc_ConfirmPass = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BackgroundLogoWidget(
      bodycontent: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10), // Khoảng cách giữa ảnh và phần nhập liệu
                child: Image.asset(
                  'assets/images/ForgotPassword/resetPass.png', // Thay 'path_to_your_image.png' bằng đường dẫn thực tế của ảnh
                  width: 400, // Điều chỉnh chiều rộng của ảnh
                  height: 250, // Điều chỉnh chiều cao của ảnh
                  fit: BoxFit.cover, // Điều chỉnh cách hiển thị của ảnh
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Create Your New Password'),
              ),
              SizedBox(height: 10),
              MauInput2(
                placeholder: "Password",
                controller: txt_Password,
                currentFocus: fc_Password,
                password: true,
                nextFocus: fc_ConfirmPass,
                kieuValidate: "password",
              ),
              MauInput2(
                password: true,
                placeholder: "Confirm Password",
                currentFocus: fc_ConfirmPass,
                controller: txt_ConfirmPassword,
                kieuValidate: "password",
              ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () async {
                  String newPassword = txt_Password.text;
                  String confirmPassword = txt_ConfirmPassword.text;

                  if (newPassword == confirmPassword) {
                    Provider.of<ResetPasswordProvider>(context, listen: false)
                        .resetPassword(context, newPassword, widget.token);
                  } else {
                    // Passwords don't match
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Passwords do not match")),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: primaryBlue, // Change the color to your desired color
                    borderRadius: BorderRadius.circular(38),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    txt_Password.dispose();
    txt_ConfirmPassword.dispose();
    fc_Password.dispose();
    fc_ConfirmPass.dispose();
    super.dispose();
  }
}
