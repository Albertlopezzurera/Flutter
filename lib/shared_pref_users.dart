
class User {
  final String username;
  final String password;
  final String email;
  final String age;
  final String gender;

  User(this.username, this.password, this.email, this.age, this.gender);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['username'] as String,
      json['password'] as String,
      json['email'] as String,
      json['age'] as String,
      json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email' : email,
      'age' : age,
      'gender' : gender,
    };
  }
}
