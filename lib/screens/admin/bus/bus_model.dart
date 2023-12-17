class Bus {
  String busid;
  String busname;
  int seatcount;
  String starttime;
  String endtime;
  String route;

  Bus(
      {required this.busid,
      required this.busname,
      required this.seatcount,
      required this.starttime,
      required this.endtime,
      required this.route});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busid: json['busid'],
      busname: json['busname'],
      seatcount: json['seatcount'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      route: json['route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busid': busid,
      'busname': busname,
      'seatcount': seatcount,
      'starttime': starttime,
      'endtime': endtime,
      'route': route,
    };
  }
}
