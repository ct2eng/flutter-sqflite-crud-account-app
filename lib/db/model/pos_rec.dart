class Pos_rec {
  String pos_type;
  int acc_ser_no;
  String symbol;
  String company_nm;
  int shares;
  int price;
  int status;
  String trade_dt;
  int mark;
  String comment;

  Pos_rec(
    this.pos_type,
    this.acc_ser_no,
    this.symbol,
    this.company_nm,
    this.shares,
    this.price,
    this.status,
    this.trade_dt,
    this.mark,
    this.comment,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["pos_type"] = pos_type;
    map["acc_ser_no"] = acc_ser_no;
    map["symbol"] = symbol;
    map["company_nm"] = company_nm;
    map["shares"] = shares;
    map["price"] = price;
    map["status"] = status;
    map["trade_dt"] = trade_dt;
    map["mark"] = mark;
    map["comment"] = comment;

    return map;
  }
}
