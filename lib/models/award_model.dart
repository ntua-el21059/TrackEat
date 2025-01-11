class Award {
  final String id;
  final String name;
  final int points;
  final String description;
  final String picture;
  final bool isAwarded;
  final dynamic awarded;  // Can be Timestamp or FieldValue

  Award({
    required this.id,
    required this.name,
    required this.points,
    required this.description,
    required this.picture,
    required this.isAwarded,
    this.awarded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'description': description,
      'picture': picture.replaceAll('"', ''),
      'isAwarded': isAwarded,
      'awarded': awarded,
    };
  }

  factory Award.fromMap(Map<String, dynamic> map) {
    try {
      return Award(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? 'Unknown Award',
        points: (map['points'] is int) 
            ? map['points'] 
            : int.tryParse(map['points']?.toString() ?? '0') ?? 0,
        description: map['description']?.toString() ?? 'No description available',
        picture: map['picture']?.toString() ?? 'assets/images/vector.png',
        isAwarded: map['isAwarded'] is bool 
            ? map['isAwarded'] 
            : map['isAwarded']?.toString().toLowerCase() == 'true',
        awarded: map['awarded'],
      );
    } catch (e) {
      print('Error creating Award from map: $e');
      return Award(
        id: '',
        name: 'Error Loading Award',
        points: 0,
        description: 'There was an error loading this award',
        picture: 'assets/images/vector.png',
        isAwarded: false,
        awarded: null,
      );
    }
  }
} 