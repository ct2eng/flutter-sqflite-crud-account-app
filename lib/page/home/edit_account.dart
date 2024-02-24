import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:account_app/component/utils.dart';

import 'package:account_app/db/model/acc_info.dart';
import 'package:account_app/db/database_hepler.dart';

class EditAccount extends StatefulWidget {
  Acc_info acc;
  bool isEdit;
  EditAccount(this.acc, this.isEdit);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  String validatorMessage = '';
  bool validate = false;

  StreamController<String> acc_nmStreamController;

  TextEditingController acc_nmController = new TextEditingController();
  TextEditingController total_valueController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    acc_nmStreamController = StreamController<String>.broadcast();

    if (widget.acc != null) {
      acc_nmController.text = widget.acc.acc_nm;
      total_valueController.text = widget.acc.total_value.toString();
      commentController.text = widget.acc.comment;

      acc_nmStreamController.sink.add(acc_nmController.text.trim());
    }

    acc_nmController.addListener(() {
      acc_nmStreamController.sink.add(acc_nmController.text.trim());
    });
  }

  @override
  void dispose() {
    super.dispose();
    acc_nmStreamController.close();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        title: widget.isEdit ? Text('編輯帳戶') : Text('新增帳戶'),
        actions: [
          if (widget.isEdit)
            Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  if (widget.acc.od == 0) {
                    Utils.showSnackBar(context, '無法刪除當前選擇帳戶');
                    return;
                  }
                  showCupertinoDialog();
                },
                icon: Icon(Icons.delete_forever),
                iconSize: 24,
                color: Colors.white,
              );
            })
        ],
      ),
      body: Builder(builder: (contextb) {
        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).bottomAppBarColor,
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width,
            child: Column(
              //  mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 70,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                    padding: EdgeInsets.only(
                        left: 15, top: 15, right: 15, bottom: 10),
                    child: StreamBuilder<Object>(
                        stream: acc_nmStreamController.stream,
                        builder: (context, snapshot) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '帳戶名稱: ',
                                  style: GoogleFonts.lato(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: TextField(
                                  controller: acc_nmController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      // fontSize: 22.0,
                                      color: Colors.white),
                                  // autofocus: false,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: getColor(snapshot.data)),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: getColor(snapshot.data)),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: getColor(snapshot.data)),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                    padding: EdgeInsets.only(
                        left: 15, top: 15, right: 15, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '投資金額: ',
                            style: GoogleFonts.lato(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: TextField(
                            controller: total_valueController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                // fontSize: 22.0,
                                color: Colors.white),
                            // autofocus: false,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.grey),
                              hintStyle:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              '元',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                  padding:
                      EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '備註: ',
                          style: GoogleFonts.lato(
                              color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          maxLength: 200,
                          maxLines: 2,
                          controller: commentController,
                          style: TextStyle(
                              // fontSize: 22.0,
                              color: Colors.white),
                          // autofocus: false,
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Theme.of(context).primaryColor,
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    onPressed: () {
                      validate = true;
                      validatorMessage = '';
                      String reqAccNm = acc_nmController.text.trim();
                      String reqTotalValue = total_valueController.text.trim();

                      setState(() {
                        if (reqAccNm.isEmpty) {
                          acc_nmStreamController.sink.add(reqAccNm);
                          validatorMessage += '『帳戶名稱』不得為空\n';
                        }
                        if (reqTotalValue.isEmpty) {
                          reqTotalValue = '0';
                        }
                      });
                      if (validatorMessage != '') {
                        Utils.showSnackBar(contextb, "尚有欄位未填寫");
                        return;
                      }

                      Acc_info user = new Acc_info(null, reqAccNm,
                          int.parse(reqTotalValue), 1, commentController.text);

                      editUser(user);
                    },
                    child: Text(
                      widget.isEdit ? '修改' : '新增',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  editUser(Acc_info user) async {
    var db = new DatabaseHelper();
    if (widget.isEdit) {
      user.acc_ser_no = widget.acc.acc_ser_no;
      await db.upadteUser(user);
    } else {
      await db.insertUser(user);
    }
    Navigator.pop(context, true);
  }

  delectUser(Acc_info user) async {
    var db = new DatabaseHelper();
    await db.delUser(user);
    Navigator.pop(context, true);
  }

  Future<void> showCupertinoDialog() async {
    return showDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("是否確定刪除"),
        // content: Text("This is the content"),
        actions: [
          // Close the dialog

          CupertinoButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(context).pop();
              delectUser(widget.acc);
            },
          ),
          CupertinoButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}

class SaveBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
