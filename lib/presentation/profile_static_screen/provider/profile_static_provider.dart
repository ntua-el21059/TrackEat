import 'package:flutter/material.dart';
import '../models/profile_static_model.dart';

class ProfileStaticProvider extends ChangeNotifier {
  ProfileStaticModel _profileStaticModelObj = ProfileStaticModel();

  ProfileStaticModel get profileStaticModelObj => _profileStaticModelObj;

  Map<String, String> _values = {
    'name': 'John',
    'surname': 'Appleseed',
    'username': 'jappleseed',
    'birthday': '23/01/1993',
    'sex': 'Male',
    'height': '180cm',
    'profileImage': '',
  };

  String getValue(String key) => _values[key.toLowerCase()] ?? '';

  void updateValue(String key, String value) {
    _values[key.toLowerCase()] = value;
    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    _values['profileimage'] = imagePath;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}