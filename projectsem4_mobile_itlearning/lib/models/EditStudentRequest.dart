import 'dart:io';

class EditStudentRequest {
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? education;
  String? passwordOld;
  String? dob;
  String? newPassword;
  String? confirmNewPass;
  File? avatarFile; // Thêm trường avatarFile

  EditStudentRequest({
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.education,
    this.passwordOld,
    this.dob,
    this.newPassword,
    this.confirmNewPass,
    this.avatarFile, // Thêm trường avatarFile
  });
}
