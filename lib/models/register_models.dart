class RegisterRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String role;
  final String username;

  RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    this.role = 'USER',
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'username': username,
    };
  }
}
