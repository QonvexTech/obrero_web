class UserLocationModel{
  final int id;
  final String location;
  bool isActive;
  UserLocationModel({required this.id,required this.location, required this.isActive });
  factory UserLocationModel.fromJson(Map<String,dynamic> parsedJson){
    return UserLocationModel(
      id : int.parse(parsedJson['id'].toString()),
      location : parsedJson['location'] is String ? parsedJson['location'] : null,
      isActive : parsedJson['is_active'] ?? false,
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'location' : location,
    'is_active' : isActive,
  };
}