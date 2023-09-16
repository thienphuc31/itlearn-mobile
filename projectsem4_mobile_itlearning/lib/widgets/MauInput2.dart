import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MauInput2 extends StatelessWidget {

  final String placeholder;
  final TextEditingController controller;
  final FocusNode? nextFocus;
  final FocusNode? currentFocus;
  final BuildContext? context;
  final bool? password;
  final String? kieuValidate;
  final VoidCallback? onDatePickerTap;


  MauInput2({

    required this.placeholder,
    required this.controller,
    this.nextFocus,
    this.currentFocus,
    this.context,
    this.password,
    this.kieuValidate,
    this.onDatePickerTap,
  });

  void _scrollTo(FocusNode focusNode) {
    Scrollable.ensureVisible(
      focusNode.context!,
      alignment: 0.5,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [


          GestureDetector(
            onTap: () {
              // Ẩn bàn phím và hủy focus khi người dùng nhấp ngoài
              FocusScope.of(context).unfocus();
              if (onDatePickerTap != null) {
                onDatePickerTap!(); // Gọi hàm callback khi người dùng nhấp vào MauInput2
              }
            },

            child: TextFormField(
              cursorColor: primaryBlue,

              obscureText: password ?? false,
              validator: (value) {
                if (kieuValidate == "email") {
                  return _validateEmail(value!);
                } else if (kieuValidate == "password") {
                  return _validatePassword(value!);
                } else if (kieuValidate == "username") {
                  return _validateUsername(value!);
                } else if (kieuValidate == "fullname") {
                  return _validateFullname(value!);
                } else if (kieuValidate == "phone") {
                  return _validatePhone(value!);
                } else if (kieuValidate == "passwordLogin") {
                  return _validatePasswordLogin(value!);
                }
                return null;
              },
              focusNode: currentFocus,

              onFieldSubmitted: (val) {
                if (context != null && nextFocus != null && currentFocus != null) {
                  currentFocus!.unfocus();
                  FocusScope.of(context!).requestFocus(nextFocus!);
                  _scrollTo(nextFocus!);
                }
              },
              controller: controller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: primaryBlue.withOpacity(0.1),
                contentPadding: const EdgeInsets.all(10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none ,

                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:  BorderSide(width: 2,color: primaryBlue),

                ),

                labelText: placeholder,
                labelStyle: TextStyle(color: Colors.black26),
                prefixIcon: placeholder == "Username"
                    ? Icon(Icons.person)
                    : placeholder == "Password"
                    ? Icon(Icons.lock_rounded)
                    : placeholder == "Confirm Password"
                    ? Icon(Icons.lock_rounded)
                    : placeholder == "Phone"
                    ? Icon(Icons.phone)
                    : placeholder == "Email"
                    ? Icon(Icons.mail)
                    : placeholder == "Full Name"
                    ? Icon(Icons.drive_file_rename_outline)
                    :null,
                suffixIcon: placeholder == "Date of Birth (dd/MM/yyyy)"
                    ? Icon(Icons.calendar_month)
                    :null,
              ),

            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String value) {
    // Thực hiện validate email và trả về thông báo lỗi (nếu có)
  }

  String? _validatePassword(String value) {
    // Thực hiện validate password và trả về thông báo lỗi (nếu có)
  }

  String? _validateUsername(String value) {
    // Thực hiện validate username và trả về thông báo lỗi (nếu có)
  }

  String? _validateFullname(String value) {
    // Thực hiện validate fullname và trả về thông báo lỗi (nếu có)
  }

  String? _validatePhone(String value) {
    // Thực hiện validate phone và trả về thông báo lỗi (nếu có)
  }

  String? _validatePasswordLogin(String value) {
    // Thực hiện validate password login và trả về thông báo lỗi (nếu có)
  }
}
