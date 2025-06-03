enum Roles { BusinessOwner, Investor, Customer, Admin }

class RolesModel {
  String id;
  String name;
  RolesModel({required this.id, required this.name});

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(id: json['Id'], name: json['Name']);
  }
}
