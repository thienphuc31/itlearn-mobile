import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/screens/InfoAccount/EditStudentPage.dart';

import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../models/Account.dart';

import '../providers/AccountProvider.dart';
import '../widgets/ExampleShowDialog.dart';
import 'Course/StudentCoursePage.dart';
import 'MenuEndDrawer/DesignEndrawer.dart';


class TestdHomePage extends StatefulWidget {
  TestdHomePage({super.key});

  @override
  State<TestdHomePage> createState() => _TestdHomePageHomePageState();
}

class _TestdHomePageHomePageState extends State<TestdHomePage> {
  final GlobalKey<ScaffoldState> _sKey = GlobalKey();

  List listWidget = [
    EditStudentPage(),
    StudentCoursePage(),
    EditStudentPage(),
    EditStudentPage(),
  ];
  bool _isSearching = false;
  int currenIndex = 0;
  String shortenAddress(String fullAddress, int maxLength) {
    if (fullAddress.length <= maxLength) {
      return fullAddress;
    } else {
      return fullAddress.substring(0, maxLength - 3) + '...';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AccountProvider>(context, listen: false)
        .checkTokenFromPreferences();
  }

  @override
  Widget build(BuildContext context) {

    String _getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return "Good Morning";
      } else if (hour < 17) {
        return "Good Afternoon";
      } else {
        return "Good Evening";
      }
    }

    var checkLogin =
        Provider.of<AccountProvider>(context, listen: true).getToken;
    // double screenWidth = MediaQuery.of(context).size.width;
    print(checkLogin);
    return Scaffold(
        key: _sKey,
        endDrawer: DesignEndrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(

          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title:(checkLogin == "")
              ? InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Login"))
              :
          //Avatar

          Row(

            children: [
              GestureDetector(
                onTap: () {
                  if (Provider.of<AccountProvider>(context, listen: false).getToken == "") {
                    ExampleAlertError(context, "Login to open Drawer");
                  }
                  _sKey.currentState?.openEndDrawer();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        Provider.of<AccountProvider>(context, listen: false).account.avatar), // Đặt URL hình ảnh của avatar ở đây
                    radius: 20, // Điều chỉnh kích thước avatar tùy ý
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                      Image.asset(
                        'assets/images/hello.PNG', // Đặt URL hình ảnh bạn muốn sử dụng
                        width: 20, // Điều chỉnh kích thước hình ảnh tùy ý
                        height: 20,
                        // Đổi màu của hình ảnh tại đây
                      ),
                    ],
                  ),
                  Text(

                    Provider.of<AccountProvider>(context, listen: false).account.fullName,
                    style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),




          // title: _isSearching
          //     ? Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20.0),
          //           border: Border.all(color: Colors.grey),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 2,
          //               blurRadius: 5,
          //               offset: Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         padding: EdgeInsets.symmetric(horizontal: 12.0),
          //         child: TextField(
          //           style: TextStyle(color: Color(0xFF8D6E63)),
          //           decoration: InputDecoration(
          //             hintText: 'Search...',
          //             border: InputBorder.none,
          //           ),
          //           onSubmitted: (value) {
          //             // Xử lý tìm kiếm ứng với giá trị nhập vào
          //           },
          //         ),
          //       )
          //     : Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //
          //
          //         ],
          //       ),

        ),

        body: Container(
             height: double.infinity,
            child: listWidget.elementAt(currenIndex)),

        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currenIndex = 0;
                        });
                      },
                      minWidth: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: (currenIndex == 0)
                                ? primaryGreen
                                : Colors.black,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: (currenIndex == 0)
                                  ? primaryGreen
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currenIndex = 1;
                        });
                      },
                      minWidth: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_box,
                            color: (currenIndex == 1)
                                ? primaryGreen
                                : Colors.black,
                          ),
                          Text(
                            "List Product",
                            style: TextStyle(
                              color: (currenIndex == 1)
                                  ? primaryGreen
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currenIndex = 2;
                        });
                      },
                      minWidth: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: (currenIndex == 2)
                                ? primaryGreen
                                : Colors.black,
                          ),
                          Text(
                            "Favorite",
                            style: TextStyle(
                              color: (currenIndex == 2)
                                  ? primaryGreen
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currenIndex = 3;
                        });
                      },
                      minWidth: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: (currenIndex == 3)
                                ? primaryGreen
                                : Colors.black,
                          ),
                          Text(
                            "Account",
                            style: TextStyle(
                              color: (currenIndex == 3)
                                  ? primaryGreen
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
