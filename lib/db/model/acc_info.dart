class Acc_info {
  int acc_ser_no;
  String acc_nm;
  int total_value;
  int od;
  String comment;
  String crt_tm;

  Acc_info(
    this.acc_ser_no,
    this.acc_nm,
    this.total_value,
    this.od,
    this.comment,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["acc_ser_no"] = acc_ser_no;
    map["acc_nm"] = acc_nm;
    map["total_value"] = total_value;
    map["od"] = od;
    map["comment"] = comment;

    return map;
  }
}
