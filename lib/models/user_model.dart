class UserModel {
  String? id;
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
  double? weight;
  double? height;
  
  // Profile 3/3
  int? age;
  int? dailyCalories;

  UserModel({
    this.id,
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
    this.weight,
    this.height,
    this.age,
    this.dailyCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate,
      'gender': gender,
      'activity': activity,
      'diet': diet,
      'goal': goal,
      'weight': weight,
      'height': height,
      'age': age,
      'dailyCalories': dailyCalories,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      activity: json['activity'],
      diet: json['diet'],
      goal: json['goal'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      age: json['age'],
      dailyCalories: json['dailyCalories'],
    );
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? birthdate,
    String? gender,
    String? activity,
    String? diet,
    String? goal,
    double? weight,
    double? height,
    int? age,
    int? dailyCalories,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      activity: activity ?? this.activity,
      diet: diet ?? this.diet,
      goal: goal ?? this.goal,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      dailyCalories: dailyCalories ?? this.dailyCalories,
    );
  }
} 