import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../models/EditStudentRequest.dart';
import '../../providers/AccountProvider.dart';
import '../../widgets/MauInput2.dart';

class EditStudentPage extends StatefulWidget {
  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _passwordOldController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPassController = TextEditingController();

  File? _avatarFile;
  bool showPasswordFields = false;
  void togglePasswordFields() {
    setState(() {
      showPasswordFields = !showPasswordFields;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin tài khoản từ AccountProvider
    final accountProvider = Provider.of<AccountProvider>(context, listen: true);

    // Sử dụng thông tin tài khoản
    final account = accountProvider.account;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: ClipOval(
                      child: _avatarFile != null
                          ? Image.file(
                        _avatarFile!,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      )
                          : (account.avatar != "" && account.avatar.isNotEmpty)
                          ? Image.network(
                        account.avatar,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 110,
                    left: 190,
                    child: GestureDetector(
                      onTap: () {
                        _selectAvatar();
                      },
                      child: Container(
                        width: 10,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryBlue,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            MauInput2(

              placeholder: account.fullName != "null" ? account.fullName : 'Full Name ',
              controller: _fullNameController,
            ),
            MauInput2(
              placeholder: account.email != "null" ? account.email : 'Email ',
              controller: _emailController,
              kieuValidate: 'email',
            ),
            MauInput2(
              placeholder: account.phone != "null" ? account.phone : 'Phone ',
              controller: _phoneController,
              kieuValidate: 'phone',
            ),
            MauInput2(
              placeholder: account.address != "null" ? account.address : 'Address',
              controller: _addressController,
            ),
            MauInput2(
              placeholder: account.education != "null" ? account.education : 'Education',
              controller: _educationController,
            ),

            MauInput2(
              placeholder: account.dob != "null" ? account.dob :'Date of Birth (dd/MM/yyyy)',
              controller: _dobController,
              onDatePickerTap: () {
                _selectDate(context);
              },
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    togglePasswordFields(); // Khi người dùng nhấp vào nút mũi tên, chuyển đổi hiển thị trường mật khẩu
                  },
                  child: Row(
                    children: [
                      Icon(showPasswordFields ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                      Text('Change Password'),
                    ],
                  ),
                ),
              ],
            ),

            if (showPasswordFields)
              MauInput2(
                placeholder: 'Old Password',
                controller: _passwordOldController,
                password: true,
                kieuValidate: 'password',
              ),
            if (showPasswordFields)
              MauInput2(
                placeholder: 'New Password',
                controller: _newPasswordController,
                password: true,
                kieuValidate: 'password',
              ),
            if (showPasswordFields)
              MauInput2(
                placeholder: 'Confirm New Password',
                controller: _confirmNewPassController,
                password: true,
                kieuValidate: 'password',
              ),


            ElevatedButton(
              onPressed: () async {
                final editRequest = EditStudentRequest(
                  fullName: _fullNameController.text.isEmpty ? account.fullName : _fullNameController.text,
                  email: _emailController.text.isEmpty ? account.email : _emailController.text,
                  phone: _phoneController.text.isEmpty ? account.phone : _phoneController.text,
                  address: _addressController.text.isEmpty ? account.address : _addressController.text,
                  education: _educationController.text.isEmpty ? account.education : _educationController.text,
                  passwordOld: _passwordOldController.text,
                  dob: _dobController.text.isEmpty ? account.dob : _dobController.text,
                  newPassword: _newPasswordController.text,
                  confirmNewPass: _confirmNewPassController.text,
                  avatarFile: _avatarFile
                );

                await Provider.of<AccountProvider>(context, listen: false)
                    .updateStudentInformation(editRequest,context);

                Navigator.pushNamed(context, '/Main');
              },
              style: ElevatedButton.styleFrom(
                primary: primaryBlue, // Màu nền của nút
                onPrimary: Colors.white, // Màu văn bản trên nút
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);

      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateFormat('dd/MM/yyyy').parse(_dobController.text, true);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Ngày ban đầu sẽ là ngày đã nhập trước đó
      firstDate: DateTime(1900), // Ngày đầu tiên mà bạn muốn cho phép chọn
      lastDate: DateTime(2101), // Ngày cuối cùng mà bạn muốn cho phép chọn
    );

    if (picked != null && picked != currentDate) {
      // Nếu người dùng đã chọn một ngày và không bằng với ngày đã nhập trước đó
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

}
