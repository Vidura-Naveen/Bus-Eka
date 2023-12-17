class User {
  final String uid;
  final String email;
  final String userName;
  final String phoneno;
  final int loyaltycount;
  final String usercredential;

  User({
    required this.uid,
    required this.email,
    required this.userName,
    required this.phoneno,
    required this.loyaltycount,
    required this.usercredential,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      userName: json['userName'],
      phoneno: json['phoneno'],
      loyaltycount: json['loyaltycount'],
      usercredential: json['usercredential'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'phoneno': phoneno,
      'loyaltycount': loyaltycount,
      'usercredential': usercredential,
    };
  }
}
