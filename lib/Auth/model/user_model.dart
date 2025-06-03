
class UserModel{
  String message;
  String userId;
  String email;
  String roleName;
  String token;

  UserModel({required this.message,required this.userId,required this.email,required this.roleName,required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json){

    return UserModel(
      message: json['Message'] ,
      userId: json['UserId'] ,
      email: json['Email'] ,
      roleName: json['RoleName'] ,
      token: json['Token'] ,
    );
  }

}



