import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:account_app/component/utils.dart';

import 'package:account_app/db/database_hepler.dart';
import 'package:account_app/db/model/pos_rec.dart';
import 'package:account_app/db/model/acc_info.dart';

// https://pub.dev/packages/pattern_formatter
// import 'package:pattern_formatter/pattern_formatter.dart';
// https://pub.dev/packages/keyboard_actions
// import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:account_app/component/z_animated_toggle.dart';
//https://pub.dev/packages/fluttertoast
import 'package:fluttertoast/fluttertoast.dart';

BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

class ActionTab extends StatefulWidget {
  static final GlobalKey<_ActionTabState> globalKey = GlobalKey();
  Pos_rec rec;
  ActionTab({Key key, this.rec}) : super(key: globalKey);

  @override
  _ActionTabState createState() => _ActionTabState();
}

class _ActionTabState extends State<ActionTab> {
  DateTime dateTime = DateTime.now();
  String validatorMessage = '';
  bool validate = false;
  bool tradeSts = true;
  double xOffset = 100;
  bool isDrawerOpen = false;

  // final _validateController = StreamController<String>();

  StreamController<String> symbolStreamController;
  StreamController<String> companyNmStreamController;
  StreamController<String> sharesStreamController;
  StreamController<String> priceStreamController;
  StreamController<String> tradeDtStreamController;

  TextEditingController symbolController = new TextEditingController();
  TextEditingController companyNmController = new TextEditingController();
  TextEditingController sharesController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController tradeDtController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    // toggleBtn(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => toggleBtn(true));

    symbolStreamController = StreamController<String>.broadcast();
    companyNmStreamController = StreamController<String>.broadcast();
    sharesStreamController = StreamController<String>.broadcast();
    priceStreamController = StreamController<String>.broadcast();
    tradeDtStreamController = StreamController<String>.broadcast();

    symbolController.addListener(() {
      symbolStreamController.sink.add(symbolController.text.trim());
    });
    companyNmController.addListener(() {
      companyNmStreamController.sink.add(companyNmController.text.trim());
    });
    sharesController.addListener(() {
      sharesStreamController.sink.add(sharesController.text);
    });
    priceController.addListener(() {
      priceStreamController.sink.add(priceController.text);
    });
    tradeDtController.addListener(() {
      tradeDtStreamController.sink.add(tradeDtController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    symbolStreamController.close();
    companyNmStreamController.close();
    sharesStreamController.close();
    priceStreamController.close();
    tradeDtStreamController.close();
  }

  // 買進/賣出
  void toggleBtn(bool action) {
    setState(() {
      if (action) {
        xOffset = 0;
        isDrawerOpen = true;
      } else {
        // 關閉卡片
        Fluttertoast.cancel();
        xOffset = 100;
        isDrawerOpen = false;
      }
    });
  }

  void setValue(String actionType) {
    if (actionType == "I") {
      symbolController.text = "";
      companyNmController.text = "";
      sharesController.text = "";
      priceController.text = "";
      tradeSts = false;
      tradeDtController.text = "";
      commentController.text = "";
    } else {
      //action_type=='U'
      if (widget.rec != null) {
        symbolController.text = widget.rec.symbol;
        companyNmController.text = widget.rec.company_nm;
        sharesController.text = widget.rec.shares.toString();
        priceController.text = widget.rec.price.toString();
        tradeSts = widget.rec.status == 1;
        tradeDtController.text = widget.rec.trade_dt;
        commentController.text = widget.rec.comment;

        symbolStreamController.sink.add(symbolController.text);
        companyNmStreamController.sink.add(companyNmController.text);
        sharesStreamController.sink.add(sharesController.text);
        priceStreamController.sink.add(priceController.text);
        tradeDtStreamController.sink.add(tradeDtController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // int accSerNo = Provider.of<Acc_info>(context, listen: false).acc_ser_no;
    int accSerNo = 0;
    bool checkingFlight = false;
    bool success = false;
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Container(
          height: screenHeight * 0.7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // widget.panelController.close();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(23.0),
                                topRight: Radius.circular(23.0)),
                          ),
                          child: SizedBox(
                            height: 25,
                            child: buildDragIcon(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {FocusScope.of(context).unfocus()},
                          child: Stack(
                            children: [
                              Builder(
                                builder: (contextb) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ZAnimatedToggle(
                                            tradeSts: tradeSts,
                                            selectColor1: Color.fromRGBO(
                                                243, 104, 104, 1),
                                            selectColor2: Color.fromRGBO(
                                                104, 243, 168, 1),
                                            toggleBackgroundColor:
                                                Theme.of(context).canvasColor,
                                            values: ['買進', '賣出'],
                                            onToggleCallback: (ele) async {
                                              // changeThemeMode(themeProvider.isLightTheme);
                                              setState(() {
                                                tradeSts = ele;
                                              });
                                            },
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 15,
                                                right: 40,
                                                bottom: 10),
                                            child: SizedBox(
                                              height: 85,
                                              child: Column(
                                                children: [
                                                  StreamBuilder(
                                                      stream:
                                                          symbolStreamController
                                                              .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Flexible(
                                                          flex: 2,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                flex: 10,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      symbolController,
                                                                  style: TextStyle(
                                                                      // fontSize: 22.0,
                                                                      color: Colors.white),
                                                                  // autofocus: false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "ex:2330",
                                                                    labelText:
                                                                        '股票代號',
                                                                    labelStyle: Theme.of(
                                                                            context)
                                                                        .inputDecorationTheme
                                                                        .labelStyle,
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey),
                                                                    prefixIcon: Icon(
                                                                        Icons
                                                                            .code,
                                                                        color: Colors
                                                                            .grey),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              getColor(snapshot.data)),
                                                                    ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              getColor(snapshot.data)),
                                                                    ),
                                                                    border:
                                                                        UnderlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              getColor(snapshot.data)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: 10,
                                                                      bottom:
                                                                          10,
                                                                      right: 10,
                                                                      top: 10),
                                                                  // decoration: BoxDecoration(
                                                                  //   border: Border(
                                                                  //     left: BorderSide(
                                                                  //         color: Colors.white10),
                                                                  //   ),
                                                                  // ),
                                                                ),
                                                              ),
                                                              StreamBuilder(
                                                                  stream:
                                                                      companyNmStreamController
                                                                          .stream,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    return Flexible(
                                                                      flex: 10,
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            companyNmController,
                                                                        style: TextStyle(
                                                                            // fontSize: 22.0,
                                                                            color: Colors.white),
                                                                        // autofocus: false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "ex:台GG",
                                                                          labelText:
                                                                              '公司名稱',
                                                                          labelStyle: Theme.of(context)
                                                                              .inputDecorationTheme
                                                                              .labelStyle,
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.grey),
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.business_sharp,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: getColor(snapshot.data)),
                                                                          ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: getColor(snapshot.data)),
                                                                          ),
                                                                          border:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: getColor(snapshot.data)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: Column(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Row(
                                                                  children: [
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        'ex: 台積電(2330)',
                                                                        style: GoogleFonts.lato(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 15, right: 15),
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  top: 15,
                                                  right: 15,
                                                  bottom: 10),
                                              child: StreamBuilder<Object>(
                                                  stream: sharesStreamController
                                                      .stream,
                                                  builder: (context, snapshot) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            '股數: ',
                                                            style: Theme.of(
                                                                    context)
                                                                .inputDecorationTheme
                                                                .labelStyle,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 6,
                                                          child: TextField(
                                                            controller:
                                                                sharesController,
                                                            textAlign: TextAlign
                                                                .center,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            style: TextStyle(
                                                                // fontSize: 22.0,
                                                                color: Colors
                                                                    .white),
                                                            // autofocus: false,
                                                            decoration:
                                                                InputDecoration(
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              hintStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: getColor(
                                                                        snapshot
                                                                            .data)),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: getColor(
                                                                        snapshot
                                                                            .data)),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: getColor(
                                                                        snapshot
                                                                            .data)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                              '股',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 15, right: 15),
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  top: 15,
                                                  right: 15,
                                                  bottom: 10),
                                              child: StreamBuilder<Object>(
                                                stream: priceStreamController
                                                    .stream,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          '價格: ',
                                                          style: Theme.of(
                                                                  context)
                                                              .inputDecorationTheme
                                                              .labelStyle,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: TextField(
                                                          controller:
                                                              priceController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: TextStyle(
                                                              // fontSize: 22.0,
                                                              color:
                                                                  Colors.white),
                                                          // autofocus: false,
                                                          decoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                            hintStyle: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: getColor(
                                                                      snapshot
                                                                          .data)),
                                                            ),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: getColor(
                                                                      snapshot
                                                                          .data)),
                                                            ),
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: getColor(
                                                                      snapshot
                                                                          .data)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '元',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 15, right: 15),
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  top: 15,
                                                  right: 15,
                                                  bottom: 10),
                                              child: StreamBuilder<Object>(
                                                stream: tradeDtStreamController
                                                    .stream,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          '日期: ',
                                                          style: Theme.of(
                                                                  context)
                                                              .inputDecorationTheme
                                                              .labelStyle,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: GestureDetector(
                                                          onTap: () => {
                                                            Utils.showSheet(
                                                              context,
                                                              child:
                                                                  buildDatePicker(),
                                                              onClicked: () {
                                                                final value =
                                                                    DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            dateTime);
                                                                // trade_dtStreamController.sink
                                                                //     .add(value);
                                                                tradeDtController
                                                                        .text =
                                                                    value;
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          },
                                                          child: AbsorbPointer(
                                                            child: TextField(
                                                              controller:
                                                                  tradeDtController,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  // fontSize: 22.0,
                                                                  color: Colors
                                                                      .white),
                                                              // autofocus: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'YYYY-MM-DD',
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .grey),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width: 1,
                                                                      color: getColor(
                                                                          snapshot
                                                                              .data)),
                                                                ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width: 1,
                                                                      color: getColor(
                                                                          snapshot
                                                                              .data)),
                                                                ),
                                                                border:
                                                                    UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width: 1,
                                                                      color: getColor(
                                                                          snapshot
                                                                              .data)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(
                                                        flex: 1,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 15, right: 15),
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                top: 15,
                                                right: 15,
                                                bottom: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '備註: ',
                                                    style: Theme.of(context)
                                                        .inputDecorationTheme
                                                        .labelStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: TextField(
                                                    maxLength: 200,
                                                    maxLines: 1,
                                                    controller:
                                                        commentController,
                                                    style: TextStyle(
                                                        // fontSize: 22.0,
                                                        color: Colors.white),
                                                    // autofocus: false,
                                                    decoration: InputDecoration(
                                                      counterStyle: TextStyle(
                                                          color: Colors.grey),
                                                      labelStyle: TextStyle(
                                                          color: Colors.grey),
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                      ),
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(
                                                  flex: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 30, bottom: 10),
                                      child: AnimatedContainer(
                                        curve: isDrawerOpen
                                            ? Curves.elasticOut
                                            : Curves.linear,
                                        transform: Matrix4.translationValues(
                                            xOffset, 0, 0),
                                        duration: Duration(
                                            milliseconds:
                                                isDrawerOpen ? 1300 : 300),
                                        child: FloatingActionButton(
                                          elevation: 4,
                                          heroTag: 'closeRec',
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.6),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 30, bottom: 60),
                                      child: AnimatedContainer(
                                        curve: isDrawerOpen
                                            ? Curves.elasticOut
                                            : Curves.linear,
                                        transform: Matrix4.translationValues(
                                            xOffset, 0, 0),
                                        duration: Duration(
                                            milliseconds:
                                                isDrawerOpen ? 1600 : 300),
                                        child: FloatingActionButton(
                                          heroTag: 'saveRec',
                                          backgroundColor: Color.fromRGBO(
                                              255, 225, 114, 0.8),
                                          onPressed: () async {
                                            validate = true;
                                            validatorMessage = '';
                                            String symbol =
                                                symbolController.text.trim();
                                            String company_nm =
                                                companyNmController.text.trim();
                                            String shares =
                                                sharesController.text.trim();
                                            String price =
                                                priceController.text.trim();
                                            String trade_dt =
                                                tradeDtController.text.trim();

                                            setState(() {
                                              if (symbol.isEmpty) {
                                                symbolStreamController.sink
                                                    .add(symbol);
                                                validatorMessage +=
                                                    '『股票代號』不得為空\n';
                                              }
                                              if (company_nm.isEmpty) {
                                                companyNmStreamController.sink
                                                    .add(company_nm);
                                                validatorMessage +=
                                                    '『公司名稱』不得為空\n';
                                              }
                                              if (shares.isEmpty) {
                                                sharesStreamController.sink
                                                    .add(shares);
                                                validatorMessage +=
                                                    '『股數』不得為空\n';
                                              }
                                              if (price.isEmpty) {
                                                priceStreamController.sink
                                                    .add(price);
                                                validatorMessage +=
                                                    '『價格』不得為空\n';
                                              }
                                              if (trade_dt.isEmpty) {
                                                tradeDtStreamController.sink
                                                    .add(trade_dt);
                                                validatorMessage += '『時間』不得為空';
                                              }
                                            });
                                            if (validatorMessage != '') {
                                              Fluttertoast.showToast(
                                                  msg: "尚有欄位未填寫",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 2,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .errorColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              // Utils.showSnackBar(context, "尚有欄位未填寫");
                                              return;
                                            }

                                            setState(() {
                                              checkingFlight = true;
                                            });

                                            Pos_rec rec = new Pos_rec(
                                                'ST',
                                                accSerNo,
                                                symbol,
                                                company_nm,
                                                int.parse(shares),
                                                int.parse(price),
                                                tradeSts ? 1 : 0,
                                                trade_dt,
                                                0,
                                                commentController.text);

                                            int updateCnt =
                                                await addRecord(rec);

                                            await Future.delayed(
                                                Duration(milliseconds: 800));

                                            // checkingFlight = false;
                                            if (updateCnt > 0) {
                                              setState(() {
                                                success = true;
                                              });
                                              await Future.delayed(
                                                  Duration(milliseconds: 800));
                                              Navigator.pop(context);
                                            } else {
                                              setState(() {
                                                success = false;
                                              });
                                            }
                                          },
                                          child: !checkingFlight
                                              ? Icon(
                                                  Icons.check_rounded,
                                                  size: 35,
                                                  color: Colors.grey[850],
                                                )
                                              : !success
                                                  ? CircularProgressIndicator()
                                                  : Icon(
                                                      Icons.done_all_rounded,
                                                      size: 35,
                                                      color: Colors.grey[850],
                                                    ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Color getColor(String text) {
    if (validate && (text == null || text.isEmpty || text == "")) {
      return Theme.of(context).errorColor;
    } else {
      return Colors.grey;
    }
  }

  String errorMessage(String text, String message) {
    if (text == null) {
      return '';
    } else if (text.isEmpty) {
      return message;
    } else {
      return '';
    }
  }

  //時間
  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          // minimumYear: 2015,
          maximumYear: DateTime.now().year,
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );
}

// 拖拉桿
Widget buildDragIcon() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          width: 40,
          height: 5,
        )
      ],
    );

Future<int> addRecord(Pos_rec rec) async {
  var db = new DatabaseHelper();
  return await db.saveRec(rec);
}

Future<List<Pos_rec>> getRecord() async {
  var db = new DatabaseHelper();
  await db.getRec();
}
