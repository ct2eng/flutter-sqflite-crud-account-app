import 'package:flutter/material.dart';
import 'package:account_app/page/home/home.dart';
import 'package:account_app/page/home/account.dart';
import 'package:account_app/page/search.dart';
import 'package:account_app/page/notify.dart';
import 'package:account_app/page/setting.dart';
import 'package:account_app/bottomCard.dart';
// https://pub.dev/packages/flutter_vibrate
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:account_app/db/database_hepler.dart';
import 'package:account_app/db/model/acc_info.dart';

// Copyright (c) 2020 Kemal Türk->https://github.com/kemalturk/panda-bar
import 'package:account_app/component/bottombar/pandabar.dart';
import 'package:provider/provider.dart';

// https://fonts.google.com/icons

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavState();
  }
}

class _NavState extends State<Navigation> {
  // 個人資訊用
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  bool _canVibrate = true;
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];

  int _currentIndex = 0;
  bool isDoubleClick = false;

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  Acc_info nowAcc;

  void initState() {
    init();
    super.initState();
  }

  List<PandaBarButtonData> _bottomItems = [
    PandaBarButtonData(id: 0, icon: Icons.home, title: '首頁'),
    PandaBarButtonData(id: 1, icon: Icons.search, title: '搜尋'),
    PandaBarButtonData(id: 2, icon: Icons.insert_chart_outlined, title: '圖表'),
    PandaBarButtonData(id: 3, icon: Icons.settings, title: '設定')
  ];
  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    refreshUser();
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  refreshUser() {
    setState(() {
      getInitUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<Acc_info>.value(value: nowAcc)],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            if (_currentIndex == 0)
              HomeAccount(closeACC: (Acc_info acc) {
                setState(() {
                  nowAcc = acc;
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                });
              }),
            AnimatedContainer(
              curve: Curves.linear,
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? 0 : 0),
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 15 : 0.0)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(7, 7), // position of shadow
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      extendBody: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: Builder(
                        builder: (context) {
                          switch (_currentIndex) {
                            case 0:
                              return HomePage(showACC: () {
                                setState(() {
                                  xOffset = -100;
                                  yOffset = 100;
                                  scaleFactor = 0.8;
                                  isDrawerOpen = true;
                                });
                              });
                            case 1:
                              return SearchPage();
                            case 2:
                              return NotifyPage();
                            case 3:
                              return SettingPage();
                            default:
                              return Container();
                          }
                        },
                      ),
                      bottomNavigationBar: PandaBar(
                        backgroundColor: Theme.of(context).bottomAppBarColor,
                        buttonColor: Color.fromRGBO(203, 201, 209, 1),
                        buttonSelectedColor: Theme.of(context).primaryColor,
                        fabColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor
                        ],
                        buttonData: _bottomItems,
                        onChange: (id) {
                          if (_canVibrate) Vibrate.feedback(FeedbackType.light);
                          setState(() {
                            //重複點
                            if (id == 1 && _currentIndex == id)
                              SearchPage.globalKey.currentState.goSearch();

                            _currentIndex = id;
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                        onFabButtonPressed: () {
                          var sheetController = showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Provider.value(
                                    value: nowAcc,
                                    child: ActionTab(),
                                  ));
                          sheetController.then((value) {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            });
                          });
                          // showModalBottomSheet(
                          //   backgroundColor: Colors.transparent,
                          //   isScrollControlled: true,
                          //   context: context,
                          //   // useRootNavigator: true,
                          //   builder: (context) {
                          //     return ActionTab();
                          //   },
                          // ).whenComplete(() {
                          //   setState(() {
                          //     xOffset = 0;
                          //     yOffset = 0;
                          //     scaleFactor = 1;
                          //     isDrawerOpen = false;
                          //   });
                          // });
                          setState(() {
                            xOffset = 10;
                            yOffset = 80;
                            scaleFactor = 0.95;
                            isDrawerOpen = true;
                          });
                          if (_canVibrate)
                            Vibrate.feedback(FeedbackType.medium);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getInitUser() async {
    var db = new DatabaseHelper();
    final usertmp = await db.getInitUser();
    setState(() {
      nowAcc = usertmp;
    });
  }
}
