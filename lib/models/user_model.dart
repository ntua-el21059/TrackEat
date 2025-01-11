class UserModel {
  String? username;
  String? email;
  String? password;
  String? create;
  String? profilePicture;  // Base64 encoded image data
  
  // Profile 1/3
  String? firstName;
  String? lastName;
  String? birthdate;
  String? gender;
  double? height;
  
  // Profile 2/3
  String? activity;
  String? diet;
  String? goal;
  double? weight;
  double? weeklygoal;
  double? weightgoal;
  
  // Profile 3/3
  int? dailyCalories;
  
  // Macronutrient goals
  double? carbsGoal;
  double? proteinGoal;
  double? fatGoal;

  // Calculate age from birthdate
  int? get age {
    if (birthdate == null) return null;
    try {
      final parts = birthdate!.split('/');
      if (parts.length != 3) return null;
      final birthDay = int.parse(parts[0]);
      final birthMonth = int.parse(parts[1]);
      final birthYear = int.parse(parts[2]);
      
      final today = DateTime.now();
      final birth = DateTime(birthYear, birthMonth, birthDay);
      int age = today.year - birth.year;
      
      // Adjust age if birthday hasn't occurred this year
      if (today.month < birth.month || 
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  UserModel({
    this.username,
    this.email,
    this.password,
    this.create,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.gender,
    this.height,
    this.activity,
    this.diet,
    this.goal,
    this.weight,
    this.weeklygoal,
    this.weightgoal,
    this.dailyCalories,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'create': create,
      'profilePicture': profilePicture,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate,
      'gender': gender,
      'height': height,
      'activity': activity,
      'diet': diet,
      'goal': goal,
      'weight': weight,
      'weeklygoal': weeklygoal,
      'weightgoal': weightgoal,
      'dailyCalories': dailyCalories,
      'carbsGoal': carbsGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      create: json['create'],
      profilePicture: json['profilePicture'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      height: json['height']?.toDouble(),
      activity: json['activity'],
      diet: json['diet'],
      goal: json['goal'],
      weight: json['weight']?.toDouble(),
      weeklygoal: json['weeklygoal']?.toDouble(),
      weightgoal: json['weightgoal']?.toDouble(),
      dailyCalories: json['dailyCalories'],
      carbsGoal: json['carbsGoal']?.toDouble(),
      proteinGoal: json['proteinGoal']?.toDouble(),
      fatGoal: json['fatGoal']?.toDouble(),
    );
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    String? create,
    String? profilePicture,
    String? firstName,
    String? lastName,
    String? birthdate,
    String? gender,
    double? height,
    String? activity,
    String? diet,
    String? goal,
    double? weight,
    double? weeklygoal,
    double? weightgoal,
    int? dailyCalories,
    double? carbsGoal,
    double? proteinGoal,
    double? fatGoal,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      create: create ?? this.create,
      profilePicture: profilePicture ?? this.profilePicture,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      activity: activity ?? this.activity,
      diet: diet ?? this.diet,
      goal: goal ?? this.goal,
      weight: weight ?? this.weight,
      weeklygoal: weeklygoal ?? this.weeklygoal,
      weightgoal: weightgoal ?? this.weightgoal,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
    );
  }
} 