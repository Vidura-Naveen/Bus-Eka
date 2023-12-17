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

  //this methode will convert the user data to json object
  Map<String, dynamic> toJSON() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'phoneno': phoneno,
      'loyaltycount': loyaltycount,
      'usercredential': usercredential,
    };
  }

  //this methode will convert the json object to user data

  //here factory is  a constructor that returns a new instance of the class
  /*We use the factory keyword to implement constructors that decides whether to return a new instance or an existing instance.*/
  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      userName: json['userName'],
      phoneno: json['phoneno'],
      loyaltycount: json['loyaltycount'],
      usercredential: json['usercredential'],
    );
  }
}
