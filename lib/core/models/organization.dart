class Organization {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String? website;
  final String? email;
  final String? phone;
  final String? address;
  final List<String> socialLinks;
  final int totalPublications;
  final int followersCount;
  final bool isVerified;
  final bool isFollowing;
  final DateTime createdDate;

  const Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    this.website,
    this.email,
    this.phone,
    this.address,
    required this.socialLinks,
    required this.totalPublications,
    required this.followersCount,
    this.isVerified = false,
    this.isFollowing = false,
    required this.createdDate,
  });

  Organization copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? website,
    String? email,
    String? phone,
    String? address,
    List<String>? socialLinks,
    int? totalPublications,
    int? followersCount,
    bool? isVerified,
    bool? isFollowing,
    DateTime? createdDate,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      socialLinks: socialLinks ?? this.socialLinks,
      totalPublications: totalPublications ?? this.totalPublications,
      followersCount: followersCount ?? this.followersCount,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'website': website,
      'email': email,
      'phone': phone,
      'address': address,
      'socialLinks': socialLinks,
      'totalPublications': totalPublications,
      'followersCount': followersCount,
      'isVerified': isVerified,
      'isFollowing': isFollowing,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      website: json['website'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      socialLinks: List<String>.from(json['socialLinks'] ?? []),
      totalPublications: json['totalPublications'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    );
  }
}
