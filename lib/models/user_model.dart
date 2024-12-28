class UserModel {
  String? username;
  String? email;
  String? password;
  
  // Profile 1/3
  String? firstName;
  String? lastName;
  String? birthdate;
  String? gender;
  
  // Profile 2/3
  String? activity;
  String? diet;
  String? goal;
  double? height;
  double? weight;
  
  // Profile 3/3
  int? dailyCalories;

  UserModel({
    this.username,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.gender,
    this.activity,
    this.diet,
    this.goal,
    this.height,
    this.weight,
    this.dailyCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate,
      'gender': gender,
      'activity': activity,
      'diet': diet,
      'goal': goal,
      'height': height,
      'weight': weight,
      'dailyCalories': dailyCalories,
    };
  }
} 