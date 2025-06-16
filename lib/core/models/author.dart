class Author {
  final String id;
  final String name;
  final String? bio;
  final String? profileImageUrl;
  final List<String> socialLinks;
  final int totalWorks;
  final int followersCount;
  final bool isFollowing;
  final DateTime? birthDate;
  final String? nationality;
  final List<String> genres;

  const Author({
    required this.id,
    required this.name,
    this.bio,
    this.profileImageUrl,
    required this.socialLinks,
    required this.totalWorks,
    required this.followersCount,
    this.isFollowing = false,
    this.birthDate,
    this.nationality,
    required this.genres,
  });

  Author copyWith({
    String? id,
    String? name,
    String? bio,
    String? profileImageUrl,
    List<String>? socialLinks,
    int? totalWorks,
    int? followersCount,
    bool? isFollowing,
    DateTime? birthDate,
    String? nationality,
    List<String>? genres,
  }) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      totalWorks: totalWorks ?? this.totalWorks,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
      birthDate: birthDate ?? this.birthDate,
      nationality: nationality ?? this.nationality,
      genres: genres ?? this.genres,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'socialLinks': socialLinks,
      'totalWorks': totalWorks,
      'followersCount': followersCount,
      'isFollowing': isFollowing,
      'birthDate': birthDate?.toIso8601String(),
      'nationality': nationality,
      'genres': genres,
    };
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      socialLinks: List<String>.from(json['socialLinks'] ?? []),
      totalWorks: json['totalWorks'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      birthDate: json['birthDate'] != null 
          ? DateTime.tryParse(json['birthDate']) 
          : null,
      nationality: json['nationality'],
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}
