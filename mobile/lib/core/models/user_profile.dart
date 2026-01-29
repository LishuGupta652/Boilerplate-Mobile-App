class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? picture;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
  });

  factory UserProfile.fromClaims(Map<String, dynamic> claims) {
    return UserProfile(
      id: claims['sub']?.toString() ?? '',
      email: claims['email']?.toString() ?? '',
      name: claims['name']?.toString() ??
          claims['preferred_username']?.toString() ??
          'New User',
      picture: claims['picture']?.toString(),
    );
  }
}
