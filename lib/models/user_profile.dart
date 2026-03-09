import 'package:flutter/foundation.dart';

/// Represents a simplified user profile for the game.
@immutable
class UserProfile {
  final String id;
  final String username;
  // Add more fields if needed, e.g., avatar, total games played, etc.

  UserProfile({
    required this.id,
    required this.username,
  });

  UserProfile copyWith({
    String? id,
    String? username,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username);

  @override
  int get hashCode => id.hashCode ^ username.hashCode;

  @override
  String toString() {
    return 'UserProfile{id: $id, username: $username}';
  }
}