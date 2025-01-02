class UserModel {
  String? id;
  String? username;
  String? email;
  String? password;
  String? created;
  
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
  
  // Macronutrient goals
  double? carbsGoal;
  double? proteinGoal;
  double? fatGoal;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.created,
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
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'created': created,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate,
      'gender': gender,
      'activity': activity,
      'diet': diet,
      'goal': goal,
      'weight': weight,
      'height': height,
      'dailyCalories': dailyCalories,
      'carbsgoal': carbsGoal,
      'proteingoal': proteinGoal,
      'fatgoal': fatGoal,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      created: json['created'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      activity: json['activity'],
      diet: json['diet'],
      goal: json['goal'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      dailyCalories: json['dailyCalories'],
      carbsGoal: json['carbsgoal']?.toDouble(),
      proteinGoal: json['proteingoal']?.toDouble(),
      fatGoal: json['fatgoal']?.toDouble(),
    );
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? created,
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
    double? carbsGoal,
    double? proteinGoal,
    double? fatGoal,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      created: created ?? this.created,
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
      carbsGoal: carbsGoal ?? this.carbsGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
    );
  }
} 