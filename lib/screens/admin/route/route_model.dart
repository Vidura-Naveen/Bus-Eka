class Routez {
  String routeid;
  String routename;
  double fromlatitude;
  double fromlongitude;
  double tolatitude;
  double tolongitude;
  double ticketprice;

  Routez(
      {required this.routeid,
      required this.routename,
      required this.fromlatitude,
      required this.fromlongitude,
      required this.tolatitude,
      required this.tolongitude,
      required this.ticketprice});

  factory Routez.fromJson(Map<String, dynamic> json) {
    return Routez(
      routeid: json['routeid'],
      routename: json['routename'],
      fromlatitude: json['fromlatitude'],
      fromlongitude: json['fromlongitude'],
      tolatitude: json['tolatitude'],
      tolongitude: json['tolongitude'],
      ticketprice: json['ticketprice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeid': routeid,
      'routename': routename,
      'fromlatitude': fromlatitude,
      'fromlongitude': fromlongitude,
      'tolatitude': tolatitude,
      'tolongitude': tolongitude,
      'ticketprice': ticketprice,
    };
  }
}
