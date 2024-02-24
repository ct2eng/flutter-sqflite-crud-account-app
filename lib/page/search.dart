import 'dart:ui';

import 'package:account_app/bottomCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

import 'package:account_app/component/slider.dart';
import 'package:account_app/db/database_hepler.dart';
import 'package:account_app/db/model/acc_info.dart';
import 'package:account_app/db/model/pos_rec.dart';
import 'package:timelines/timelines.dart';

class SearchPage extends StatefulWidget {
  static final GlobalKey<_SearchPageState> globalKey = GlobalKey();
  SearchPage({Key key}) : super(key: globalKey);
// super(key: globalKey);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map searchVal = {};
  List<Map> searchList = [];
  List recList = [];

  double expandedHeight = 100.0;
  double isSearchHeight = 50.0;

  FocusNode _focus = new FocusNode(); // 是否點選搜尋
  bool isSearchDone; //是否搜尋完畢
  TextEditingController searchInput = new TextEditingController(); // 使用者輸入搜尋文字
  Widget nowSearchWidget;

  DatabaseHelper databaseHelper = DatabaseHelper();

  void initState() {
    super.initState();
    isSearchDone = true; //是否搜尋完畢
    nowSearchWidget = searchBar();
    _focus.addListener(_onFocusChange);
    searchInput.addListener(_printLatestValue);
    doSearchRecord({}, true);
    // refreshDataList();
  }

  void _printLatestValue() {
    setState(() {
      searchVal = {'symbol': searchInput.text, 'company_nm': searchInput.text};
      getSearh(searchVal);
    });
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  // refreshDataList() {
  //   setState(() {
  //     getSearh(null, 1);
  //   });
  // }

  @override
  void dispose() {
    // _focus.dispose();
    super.dispose();
  }

  // 搜尋推薦列表
  void goSearch() {
    getSearh(searchVal);
    setState(() {
      nowSearchWidget = inputBar();
      isSearchDone = false;
      // FocusScope.of(context).requestFocus(_focus);
    });
  }

  //查詢結果
  void doSearchRecord(Map data, bool isFuzzy) {
    setState(() {
      if (data.isEmpty) {
        searchInput.text = '';
        searchVal = {};
      } else {
        searchVal = {
          'symbol': data['symbol'],
          'company_nm': data['company_nm']
        };
        searchInput.text = data['symbol'];
      }
      nowSearchWidget = searchBar();
      isSearchDone = true;
      getRecResult(data, isFuzzy);
    });
  }

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(_focus);
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    // int acc_ser_no = Provider.of<Acc_info>(context, listen: false).acc_ser_no;
    int acc_ser_no = 0;

    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                shape: Border(
                    bottom: BorderSide(width: 0.7, color: Colors.white54)),
                expandedHeight: isSearchDone ? expandedHeight : isSearchHeight,
                floating: true,
                pinned: true,
                snap: true,
                backgroundColor: Theme.of(context).bottomAppBarColor,
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransitionX(
                      child: child,
                      direction: isSearchDone
                          ? AxisDirection.down
                          : AxisDirection.up, //上入下出
                      position: animation,
                    );
                  },
                  child: nowSearchWidget,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  // stretchModes: [StretchMode.zoomBackground],
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 8.0, left: 16.0),
                                child: Text("篩選: ",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 16.0)),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, right: 8.0),
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        '日期',
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, right: 8.0),
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        '買賣',
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                // itemExtent: 500.0,
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _recItem(context, index),
                  childCount: recList.length,
                ),
              ),
            ],
          ),
          if (!isSearchDone)
            Padding(
              padding: EdgeInsets.only(
                top: expandedHeight,
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: screenHeight,
                    color: Color.fromRGBO(19, 22, 32, 0.3),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Map reqMap = searchInput.text.isNotEmpty
                                    ? {
                                        'symbol': searchInput.text,
                                        'company_nm': searchInput.text
                                      }
                                    : {};
                                doSearchRecord(reqMap, true);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: Colors.white54))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16, top: 16, bottom: 16),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                            '搜尋: ' +
                                                (searchInput.text.isNotEmpty
                                                    ? searchInput.text
                                                    : '全部'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchList.length,
                                itemBuilder: (_, index) {
                                  return _searchItem(index, context);
                                },
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _recItem(context, index) {
    Map groupList = recList[index];
    List detail = groupList['list'];
    print(detail);
    return Container(
      child: Card(
        // color: Colors.white,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 6,
        margin: EdgeInsets.all(20.0),
        child: Container(
          // color: Color.fromRGBO(88, 88, 89, 1),
          child: Text('123'),
        ),
      ),
    );
  }

  Widget _searchItem(index, context) {
    // searchVal
    // Map detail = detailList[index];
    Map detail = searchList[index];
    // if (detail.isEmpty) return Container();

    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.white54))),
      child: ListTile(
        onTap: () {
          doSearchRecord(detail, false);

          // if (_canVibrate) Vibrate.feedback(FeedbackType.light);
          // setState(() {
          //   searchVal = {
          //     'symbol': detail['symbol'],
          //     'company_nm': detail['company_nm']
          //   };
          //   searchInput.text = detail['symbol'];
          //   nowSearchWidget = searchBar();
          //   isSearchDone = true;
          // });
        },
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.north_east,
                color: Colors.white,
                size: 14,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 20,
              child: Text("${detail['company_nm']}(${detail['symbol']})",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                // FocusScope.of(context).requestFocus(_focus);
                getSearh(searchVal);
                setState(() {
                  goSearch();
                  // nowSearchWidget = inputBar();
                  // isSearchDone = false;
                });
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
          ),
          Flexible(
              flex: 10,
              child: Text('搜尋' +
                  (searchInput.text.isNotEmpty
                      ? ': ${searchInput.text}'
                      : ''))),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget inputBar() {
    return Container(
      child: Row(
        children: [
          Flexible(
              flex: 14,
              child: SizedBox(
                height: 35,
                child: Material(
                  elevation: 5, //陰影
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    child: TextFormField(
                      focusNode: _focus,
                      controller: searchInput,
                      autofocus: true,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromRGBO(19, 22, 32, 0.3),
                        ),
                        // disabledBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        hintText: "搜尋",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 3,
            child: TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                doSearchRecord({}, true);
              },
              child: Text('取消',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          )
        ],
      ),
    );
  }

  //搜尋列表
  void getSearh(Map item) async {
    int accSerNo = Provider.of<Acc_info>(context, listen: false).acc_ser_no;
    final list = await databaseHelper.getSearchData(item, accSerNo);
    setState(() {
      searchList = list;
    });
  }

  //DB搜尋記錄列表
  void getRecResult(Map item, bool isFuzzy) async {
    int accSerNo = Provider.of<Acc_info>(context, listen: false).acc_ser_no;
    List list = await databaseHelper.getRecResult(item, accSerNo, isFuzzy);

    List tmpList = [];
    groupBy(list, (obj) => obj['symbol']).forEach((key, value) {
      tmpList.add({'symbol': key, 'list': value});
    });
    setState(() {
      recList = tmpList;
    });
  }
}
