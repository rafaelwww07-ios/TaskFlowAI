import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.createdAt,
    this.isDemo = false,
  });

  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime? createdAt;
  final bool isDemo;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    bool? isDemo,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, createdAt, isDemo];
}

