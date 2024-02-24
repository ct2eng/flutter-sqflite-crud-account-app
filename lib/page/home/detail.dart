import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class HomeDetail extends StatefulWidget {
  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  bool _canVibrate = true;

  //symbol(股票代號),comp_nm(公司名),shares(已經實現股數),
  //total_chg(損益)total_pct(百分比),win(正負)
  List detailList = [
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
    {
      'symbol': '2330',
      'comp_nm': 'TSMC',
      'shares': '1000',
      'total_chg': 43554,
      'total_pct': '19%',
      'win': true
    },
    {
      'symbol': '2317',
      'comp_nm': 'FOXCONN',
      'shares': '1000',
      'total_chg': 300000,
      'total_pct': '12%',
      'win': false
    },
  ];

  void initState() {
    super.initState();
    init();
  }

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 45,
                // padding: const EdgeInsets.all(10),
                // color: Colors.transparent,
                child: Container(
                  child: ListTile(
                    title: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '股票',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '股數',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '庫存損益',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  //isAlwaysShown: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: detailList.length,
                    itemBuilder: (_, index) {
                      return _listItem(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Item of the ListView
  Widget _listItem(index) {
    Map detail = detailList[index];
    String addSub = detail['win'] ? '+' : '-';
    Color valueColor = detail['win']
        ? Theme.of(context).errorColor
        : Theme.of(context).indicatorColor;
    Icon arrowDir = detail['win']
        ? Icon(
            Icons.arrow_drop_up,
            size: 18,
            color: Theme.of(context).errorColor,
          )
        : Icon(
            Icons.arrow_drop_down,
            size: 18,
            color: Theme.of(context).indicatorColor,
          );

    return Container(
      // padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          if (_canVibrate) Vibrate.feedback(FeedbackType.light);
        },
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      detail['comp_nm'],
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.lato(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '(' + detail['symbol'] + ')',
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.lato(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        detail['shares'],
                        style: GoogleFonts.lato(
                            color: Colors.white70, fontSize: 14),
                      )),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      addSub + 'NTD' + detail['total_chg'].toString(),
                      style:
                          GoogleFonts.lato(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Row(
                    // crossAxisAlignment:
                    //     CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        flex: 1,
                        child: arrowDir,
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          addSub + detail['total_pct'].toString(),
                          style:
                              GoogleFonts.lato(color: valueColor, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.white30))),
    );
  }
}
