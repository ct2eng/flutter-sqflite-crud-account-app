import 'package:account_app/db/model/acc_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:account_app/page/home/detail.dart';

class HomePage extends StatefulWidget {
  VoidCallback showACC;
  HomePage({Key key, this.showACC}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).bottomAppBarColor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
                // height: 130,
                child: Container(
                  margin: EdgeInsets.only(left: 30, top: 65, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 17,
                        child: Text(
                          '首頁',
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 26),
                        ),
                      ),
                      // Spacer(flex: 1),
                      Flexible(
                        flex: 3,
                        child: IconButton(
                          onPressed: () {
                            widget.showACC();
                          },
                          icon: Icon(Icons.people),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 首頁損益card
            Expanded(
              flex: 5,
              child: Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6,
                margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
                  child: SizedBox(
                    height: 85,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  '總損益',
                                  style: GoogleFonts.lato(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  'NTD 999,999',
                                  style: GoogleFonts.lato(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 18,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  '+ NTD 1450 (+12%)',
                                  style: GoogleFonts.lato(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                child: Container(
                  margin: EdgeInsets.only(left: 30, top: 15, right: 30),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          '損益明細',
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 已實現損益列表
            Expanded(
              flex: 16,
              child: Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6,
                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Container(
                  // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: HomeDetail(),
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
    );
  }
}
