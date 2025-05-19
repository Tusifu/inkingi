import 'dart:convert';

class GenericResponse {
  final String message;
  final String status;
  final String timestamps;

  GenericResponse({
    required this.message,
    required this.status,
    required this.timestamps,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) {
    return GenericResponse(
      message: json['message'],
      status: json['status'],
      timestamps: json['timestamps'],
    );
  }
}
