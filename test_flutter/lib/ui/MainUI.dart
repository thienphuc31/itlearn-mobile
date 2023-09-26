import 'package:flutter/material.dart';
import 'package:test_flutter/ui/Account.dart';
import 'package:test_flutter/ui/Import.dart';
import 'package:test_flutter/ui/Inventory.dart';
import 'package:test_flutter/ui/Itemdata.dart';
import 'package:test_flutter/ui/Itemmaster.dart';
import 'package:test_flutter/ui/Location.dart';
import 'package:test_flutter/ui/Login.dart';
import 'package:test_flutter/ui/QC.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<StatefulWidget> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {

  List dataFake = [
    "Accounts",
    "Import Item",
    "Item Data",
    "Item Master",
    "Location",
    "QC",
  ];

  List<Color> dataFakeColor = [
    const Color(0xffffcf2f),
    const Color(0xff6fe08d),
    const Color(0xff61bdfd),
    const Color(0xfffc7f7f),
    const Color(0xffc884fb),
    const Color(0xff78e667),
  ];

  List<Icon> dataFakeIcon = [
    Icon(Icons.manage_accounts, color: Colors.white, size: 30),
    Icon(Icons.import_export, color: Colors.white, size: 30),
    Icon(Icons.data_thresholding, color: Colors.white, size: 30),
    Icon(Icons.mark_as_unread, color: Colors.white, size: 30),
    Icon(Icons.location_on, color: Colors.white, size: 30),
    Icon(Icons.check_box_rounded, color: Colors.white, size: 30),
  ];

  List<Widget> pages = [
    const Account(),
    const Import(),
    const Itemdata(),
    const InventoryPage(),
    const Location(),
    const QC(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: Color(0xff674AEF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Icon(
                            Icons.dashboard,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "Trong Nguyen",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here...",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 15,
              right: 15,
            ),
            child: Column(
              children: [
                GridView.builder(
                  itemCount: dataFake.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pages[index]),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: dataFakeColor[index],
                                shape: BoxShape.circle),
                            child: Center(
                              child: Center(
                                child: dataFakeIcon[index],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            dataFake[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Warehouse",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff674AEF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        width: 270,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("Trong Nguyen"),
                accountEmail: Text("trong@gmail.com"),
              ),
              ListTile(
                title: const Text("Help"),
                leading: const Icon(Icons.question_mark),
                onTap: () {
                  // Handle the Search Contact action here
                },
              ),
              ListTile(
                title: const Text("Feedback"),
                leading: const Icon(Icons.feedback_outlined),
                onTap: () {
                  // Handle the Search Contact action here
                },
              ),
              ListTile(
                title: const Text("System"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  // Handle the Add Contact action here
                },
              ),
              ListTile(
                title: const Text("Logout"),
                leading: const Icon(Icons.logout_sharp),
                onTap: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
