import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../constants/AuthenticatedHttpClient.dart';
import '../constants/urlAPI.dart';
import '../models/Account.dart';
import '../models/ApiResponse.dart';
import '../models/EditStudentRequest.dart';

class AccountProvider extends ChangeNotifier {
  late  Account account ;
  String _token = "";

  late int expiredTime;
  String get getToken => _token;
  late Timer bienTime;





  Future<void> checkTokenFromPreferences() async {
    var ref = await SharedPreferences.getInstance();
    _token = ref.getString("accessToken") ?? ""; // Use the null-aware operator ?? to provide a default value
    notifyListeners();
  }


  Future<bool> autoLogin() async {
    var ref = await SharedPreferences.getInstance();
    var a = ref.getString("accessToken");
    if (a == "" || a == null) {
      return false;
    } else {

      return true;
    }
  }

  Future<void> logOut(BuildContext context) async {
    _token = "";
    var ref = await SharedPreferences.getInstance();
    ref.remove("accessToken");

    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, "/LoginMain", (route) => false);
  }

  Future<Account?> getInforAccount() async {
    var ref = await SharedPreferences.getInstance();
    var accessToken = ref.getString('accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      return Future.error('Please Login To Continue !');
    }

    final client = AuthenticatedHttpClient(ref); // Sử dụng AuthenticatedHttpClient
    final response = await client.get(
      Uri.parse(infoAccoutAPI),
    );

    if (response.statusCode == 200) {
      var apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiResponse.success) {
        Map<String, dynamic> info = apiResponse.data as Map<String, dynamic>;
        account = Account.fromMap(info);
        notifyListeners();
        return account;
      } else {
        return Future.error(apiResponse.message);
      }
    }

    return Future.error('Please Login To Continue !');
  }
  Future<void> updateStudentInformation(EditStudentRequest editRequest) async {
    final ref = await SharedPreferences.getInstance();
    final accessToken = ref.getString('accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      return Future.error('Please Login To Continue !');
    }

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    };

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(editInfoAccountAPI),
    );

    request.headers.addAll(headers);

    // Thêm các trường thông tin từ editRequest vào request
    if (editRequest.fullName != null && editRequest.fullName!.isNotEmpty) {
      request.fields['fullName'] = editRequest.fullName!;
    }
    if (editRequest.email != null && editRequest.email!.isNotEmpty) {
      request.fields['email'] = editRequest.email!;
    }
    if (editRequest.phone != null && editRequest.phone!.isNotEmpty) {
      request.fields['phone'] = editRequest.phone!;
    }
    if (editRequest.address != null && editRequest.address!.isNotEmpty) {
      request.fields['address'] = editRequest.address!;
    }
    if (editRequest.education != null && editRequest.education!.isNotEmpty) {
      request.fields['education'] = editRequest.education!;
    }
    if (editRequest.passwordOld != null && editRequest.passwordOld!.isNotEmpty) {
      request.fields['passwordOld'] = editRequest.passwordOld!;
    }
    if (editRequest.dob != null && editRequest.dob!.isNotEmpty) {
      request.fields['dob'] = editRequest.dob!;
    }
    if (editRequest.newPassword != null && editRequest.newPassword!.isNotEmpty) {
      request.fields['newPassword'] = editRequest.newPassword!;
    }
    if (editRequest.confirmNewPass != null && editRequest.confirmNewPass!.isNotEmpty) {
      request.fields['confirmNewPass'] = editRequest.confirmNewPass!;
    }

    if (editRequest.avatarFile != null) {
      final file = editRequest.avatarFile!;
      final contentType = MediaType('image', 'jpeg');
      final fileStream = file.openRead();
      final fileLength = file.lengthSync();

      final avatarMultipartFile = http.MultipartFile(
        'avatar',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
        contentType: contentType,
      );

      request.files.add(avatarMultipartFile);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonData = json.decode(responseBody);
      // Xử lý dữ liệu trả về nếu cần

      // Thông báo về sự cập nhật thành công hoặc gì đó
    } else {
      throw Exception('Failed to edit student');
    }
  }


//Update Account "/InforAccount"
  // Future<void> updateAccount({ required String fullName, required String? email,required String phone,
  // required  bool gender, String? avatar,required String dob,required String address,required BuildContext context}) async {
  //   final String updateAPI = 'https://api.techwiz4.store/api/user/update'; // Đặt URL API cần cập nhật
  //   try{
  //     final response = await http.put(
  //       Uri.parse(updateAPI),
  //       headers: {"Content-Type": "application/json;charset=UTF-8",
  //         'Authorization': 'Bearer $_token'},
  //       body: jsonEncode({
  //         "fullName": fullName,
  //         "email": email,
  //         "phone": phone,
  //         "gender": gender,
  //         "avatar": avatar,
  //         "dob": dob,
  //         "address": address
  //       }),
  //     );
  //     var a = response.body;
  //     if(response.statusCode == 200) {
  //       ExampleShowDialogSuccess(context,"Update successful !");
  //
  //       //  Navigator.popAndPushNamed(context, "/Main");
  //
  //     }else{
  //
  //     }
  //   }catch(error){
  //     ExampleShowDialogError(context,"Error");
  //     Navigator.pushNamed(context, "/Main");
  //   }
  //
  //
  //
  // }
  // Future<void> updateImage(File _imageFile)async{
  //   var request = http.MultipartRequest('POST', Uri.parse("https://api.techwiz4.store/api/file/upload"));
  //   request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
  //   request.headers['Authorization'] = 'Bearer $_token';
  //   request.headers['Content-Type'] = 'image/png'; // Adjust this based on the actual image format.
  //
  //   var response = await request.send();
  //   var responseBody = await response.stream.bytesToString();
  //   if (response.statusCode == 200) {
  //     // Xử lý phản hồi từ máy chủ
  //     print('Upload thành công');
  //   } else {
  //     // Xử lý lỗi
  //     print('Upload thất bại');
  //   }
  // }


}
