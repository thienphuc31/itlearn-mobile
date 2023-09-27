import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MauInput2 extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final FocusNode? nextFocus;
  final FocusNode? currentFocus;
  final BuildContext? context;
  final bool? password;
  final String? kieuValidate;
  final VoidCallback? onDatePickerTap;
  final Widget? suffixIcon;


  MauInput2({
    required this.placeholder,
    required this.controller,
    this.nextFocus,
    this.currentFocus,
    this.context,
    this.password,
    this.kieuValidate,
    this.onDatePickerTap,
    this.suffixIcon,
  });

  @override
  _MauInput2State createState() => _MauInput2State();
}

class _MauInput2State extends State<MauInput2> {
  bool _isPasswordVisible = false; // New state variable

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
              if (widget.onDatePickerTap != null) {
                widget.onDatePickerTap!(); // Gọi hàm callback khi người dùng nhấp vào MauInput2
              }
            },
            child: TextFormField(
              cursorColor: primaryBlue,
              obscureText: widget.password == true ? !_isPasswordVisible : false,
              validator: (value) {
                if (widget.kieuValidate == "email") {
                  return _validateEmail(value!);
                } else if (widget.kieuValidate == "password") {
                  return _validatePassword(value!);
                } else if (widget.kieuValidate == "username") {
                  return _validateUsername(value!);
                } else if (widget.kieuValidate == "fullname") {
                  return _validateFullname(value!);
                } else if (widget.kieuValidate == "phone") {
                  return _validatePhone(value!);
                } else if (widget.kieuValidate == "passwordLogin") {
                  return _validatePasswordLogin(value!);
                }
                return null;
              },
              focusNode: widget.currentFocus,
              onFieldSubmitted: (val) {
                if (context != null && widget.nextFocus != null && widget.currentFocus != null) {
                  widget.currentFocus!.unfocus();
                  FocusScope.of(context!).requestFocus(widget.nextFocus!);
                  _scrollTo(widget.nextFocus!);
                }
              },
              controller: widget.controller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: primaryBlue.withOpacity(0.1),
                contentPadding: const EdgeInsets.all(10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none ,

                ),
                errorMaxLines: 3,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:  BorderSide(width: 2,color: primaryBlue),

                ),

                labelText: widget.placeholder,
                labelStyle: TextStyle(color: Colors.black26),
                prefixIcon: widget.placeholder == "Username"
                    ? Icon(Icons.person)
                    : widget.placeholder == "Password"
                    ? Icon(Icons.lock_rounded)
                    : widget.placeholder == "Confirm Password"
                    ? Icon(Icons.lock_rounded)
                    : widget.placeholder == "Phone"
                    ? Icon(Icons.phone)
                    : widget.placeholder == "Email"
                    ? Icon(Icons.mail)
                    : widget.placeholder == "Full Name"
                    ? Icon(Icons.drive_file_rename_outline)
                    :null,
                suffixIcon: widget.placeholder == "Password" || widget.placeholder == "Old Password" || widget.placeholder == "New Password" || widget.placeholder == "Confirm New Password"
    ? IconButton(
                  // Add IconButton to suffixIcon
                  icon: Icon(
                    // Choose the icon based on the _isPasswordVisible state
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),

                  onPressed: () {
                    // Update the _isPasswordVisible state when pressed
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
                    : widget.placeholder == "Date of Birth (dd/MM/yyyy)"
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
    // Perform email validation and return error message (if any)
  }

  String? _validatePassword(String value) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return 'Must contain 6 characters, uppercase, lowercase, numbers, special case!';
    } else {
      return null;
    }
  }

  String? _validateUsername(String value) {
    // Perform username validation and return error message (if any)
  }

  String? _validateFullname(String value) {
    // Perform full name validation and return error message (if any)
  }

  String? _validatePhone(String value) {
    // Perform phone number validation and return error message (if any)
  }

  String? _validatePasswordLogin(String value) {
    // Perform password login validation and return error message (if any)
  }
}