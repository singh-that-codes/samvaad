class User {
  late String uid;
  late String name;
  late String email;
  late String username;
  late String status;
  late int state;
  late String profilePhoto;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.status,
    required this.state,
    required this.profilePhoto, required String password,
  });

  // Convert a User instance to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'status': status,
      'state': state,
      'profile_photo': profilePhoto,
    };
  }

  // Named constructor to create a User instance from a map
  factory User.fromMap(Map<String, dynamic> mapData) {
    return User(
      uid: mapData['uid'],
      name: mapData['name'],
      email: mapData['email'],
      username: mapData['username'],
      status: mapData['status'],
      state: mapData['state'],
      profilePhoto: mapData['profile_photo'], password: '',
    );
  }
}
