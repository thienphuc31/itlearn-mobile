import 'package:flutter/material.dart';

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
                    child: account.avatar != "null"
                        ? Image.network(
                      account.avatar,
                      fit: BoxFit.cover,
                    )
                        :Icon(Icons.account_circle,color: Colors.white,size: 80,)
                ),
              ),
              ListTile(
                title: Text("History Order"),
                leading: Icon(Icons.history),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyApp4()),
                  // );
                },
              ),
              ListTile(
                title: Text("Help"),
                leading: Icon(Icons.question_mark),
                // onTap: () {
                //   Navigator.pushNamed(context, '/HelpMain');
                // },
              ),
              ListTile(
                title: Text("Feed Back"),
                leading: Icon(Icons.feedback_outlined),
                // onTap: () {
                //   Navigator.pushNamed(context, '/Feedback');
                // },
              ),
              ListTile(
                title: Text("SiteMap"),
                leading: Icon(Icons.map_sharp),
                // onTap: (){
                //   Navigator.pushNamed(context, '/SiteMap');
                // },
              ),
              ListTile(
                title: Text("Setting"),
                leading: Icon(Icons.settings),
                onTap: () {
                  // Handle the Add Contact action here
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
