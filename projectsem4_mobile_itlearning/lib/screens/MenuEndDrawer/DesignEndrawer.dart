import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';

import 'package:provider/provider.dart';

import '../../models/Account.dart';
import '../../providers/AccountProvider.dart';


class DesignEndrawer extends StatelessWidget {
  const DesignEndrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<AccountProvider>(context).account;

    return Drawer(
      elevation: 0,
      width: 250,
      child: SingleChildScrollView(
        child: Container(

          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(account.fullName), // Hiển thị họ tên
                accountEmail: Text(account.email), // Hiển thị email
                currentAccountPicture: ClipOval(
                    child: account.avatar != ""
                        ? Image.network(
                      account.avatar,
                      fit: BoxFit.cover,
                    )
                        :Image.network(
                      "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
                      fit: BoxFit.cover,
                    )
                ),
                decoration: BoxDecoration(
                  color: primaryBlue, // Đặt màu nền
                ),
              ),



              ListTile(
                title: Text("Account"),
                leading: Icon(Icons.account_circle_outlined),
                onTap: () {
                 Navigator.pushNamed(context, '/EditStudentPage');
                },
              ),
              ListTile(
                title: Text("Sign Out"),
                leading: Icon(Icons.logout_sharp),
                onTap: () {
                  Provider.of<AccountProvider>(context,listen: false).logOut(context);
                  Navigator.pushNamed(context, '/LoginMain');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
