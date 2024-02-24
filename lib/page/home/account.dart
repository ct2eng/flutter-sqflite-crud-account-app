import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:account_app/db/model/acc_info.dart';
import 'package:account_app/db/database_hepler.dart';
import 'package:account_app/page/home/edit_account.dart';

typedef void StringCallback(Acc_info acc);

class HomeAccount extends StatefulWidget {
  StringCallback closeACC;
  HomeAccount({Key key, this.closeACC}) : super(key: key);
  @override
  _HomeAccountState createState() => _HomeAccountState();
}

class _HomeAccountState extends State<HomeAccount> {
  bool isEdit = false;
  bool _canVibrate = true;
  // final ScrollController _scrollController = ScrollController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Acc_info> userList = List<Acc_info>.empty();

  void initState() {
    super.initState();
    init();
    refreshDataList();
  }

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  refreshDataList() {
    setState(() {
      getUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    final screenWeight = mediaQueryData.size.width;

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(19, 22, 32, 1),
        padding: EdgeInsets.only(top: 50, bottom: 50, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  // Flexible(
                  //   flex: 1,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       widget.closeACC(null);
                  //     },
                  //     icon: Icon(Icons.arrow_back),
                  //     iconSize: 24,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  Flexible(
                    flex: 10,
                    child: Text(
                      'Stock Track',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
            Flexible(
                flex: 6,
                child: SizedBox(
                  height: screenHeight,
                  width: screenWeight * 0.4,
                  child: Scrollbar(
                    //isAlwaysShown: true,
                    child: ListView.builder(
                      // controller: _scrollController,
                      itemCount: userList.length,
                      itemBuilder: (_, index) {
                        return account(index);
                      },
                    ),
                  ),
                )),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon(
                  //   Icons.settings,
                  //   color: Colors.white,
                  // ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                      // Navigator.of(context).push(_createRoute());
                    },
                    child: Text(
                      '編輯',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Icon(
                  //   Icons.person_add,
                  //   color: Colors.white,
                  // ),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(_createRoute());
                      goEdit(null, false);
                    },
                    child: Text(
                      '新增',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget account(index) {
    var bkColor = userList[index].od == 0
        ? Theme.of(context).primaryColor
        : Theme.of(context).bottomAppBarColor;
    var textColor = userList[index].od == 0
        ? Theme.of(context).bottomAppBarColor
        : Colors.white;
    return GestureDetector(
      onTap: () {
        selectUser(userList[index]);
        // widget.closeACC();
      },
      child: Container(
        decoration: BoxDecoration(
            color: bkColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isEdit)
                IconButton(
                  onPressed: () {
                    goEdit(userList[index], true);
                    // widget.closeACC();
                  },
                  icon: Icon(Icons.edit),
                  iconSize: 16,
                  color: textColor,
                )
              else
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  iconSize: 0,
                  color: textColor,
                ),
              Text(
                userList[index].acc_nm,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),

              // Text(
              //   ' - ',
              //   style: TextStyle(
              //       color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void selectUser(Acc_info acc) async {
    if (acc.od == 0) return;
    if (_canVibrate) Vibrate.feedback(FeedbackType.medium);
    int res = await databaseHelper.selectUser(acc);
    if (res > 0) {
      getUserList();
      widget.closeACC(acc);
    }
  }

  void getUserList() async {
    final userListtmp = await databaseHelper.getUserList();
    setState(() {
      userList = userListtmp;
      isEdit = false;
    });
  }

  void goEdit(Acc_info acc, isedit) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditAccount(acc, isedit)));
    if (result == true) {
      refreshDataList();
    }

    // bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccount(acc, true)));
    // if(result == true){
    //   refreshDataList();
    // }
  }
}

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => EditAccount(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, 1.0);
//       var end = Offset.zero;
//       var curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }