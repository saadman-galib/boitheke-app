class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final List<String> savedBooks;
  final List<String> followingAuthors;
  final List<String> followingOrganizations;
  final List<ReadingHistoryItem> readingHistory;
  final UserPreferences preferences;
  final DateTime createdDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.savedBooks,
    required this.followingAuthors,
    required this.followingOrganizations,
    required this.readingHistory,
    required this.preferences,
    required this.createdDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    List<String>? savedBooks,
    List<String>? followingAuthors,
    List<String>? followingOrganizations,
    List<ReadingHistoryItem>? readingHistory,
    UserPreferences? preferences,
    DateTime? createdDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      savedBooks: savedBooks ?? this.savedBooks,
      followingAuthors: followingAuthors ?? this.followingAuthors,
      followingOrganizations: followingOrganizations ?? this.followingOrganizations,
      readingHistory: readingHistory ?? this.readingHistory,
      preferences: preferences ?? this.preferences,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'savedBooks': savedBooks,
      'followingAuthors': followingAuthors,
      'followingOrganizations': followingOrganizations,
      'readingHistory': readingHistory.map((item) => item.toJson()).toList(),
      'preferences': preferences.toJson(),
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      savedBooks: List<String>.from(json['savedBooks'] ?? []),
      followingAuthors: List<String>.from(json['followingAuthors'] ?? []),
      followingOrganizations: List<String>.from(json['followingOrganizations'] ?? []),
      readingHistory: (json['readingHistory'] as List<dynamic>?)
          ?.map((item) => ReadingHistoryItem.fromJson(item))
          .toList() ?? [],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    );
  }
}

class ReadingHistoryItem {
  final String bookId;
  final String bookTitle;
  final String bookCoverUrl;
  final DateTime lastReadDate;
  final int currentPage;
  final int totalPages;
  final double progress;

  const ReadingHistoryItem({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.lastReadDate,
    required this.currentPage,
    required this.totalPages,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverUrl': bookCoverUrl,
      'lastReadDate': lastReadDate.toIso8601String(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'progress': progress,
    };
  }

  factory ReadingHistoryItem.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryItem(
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      bookCoverUrl: json['bookCoverUrl'] ?? '',
      lastReadDate: DateTime.tryParse(json['lastReadDate'] ?? '') ?? DateTime.now(),
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }
}

class UserPreferences {
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final double fontSize;
  final bool nightMode;
  final bool notificationsEnabled;
  final bool autoDownload;

  const UserPreferences({
    this.language = 'en',
    this.theme = 'system',
    this.fontSize = 16.0,
    this.nightMode = false,
    this.notificationsEnabled = true,
    this.autoDownload = false,
  });

  UserPreferences copyWith({
    String? language,
    String? theme,
    double? fontSize,
    bool? nightMode,
    bool? notificationsEnabled,
    bool? autoDownload,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      nightMode: nightMode ?? this.nightMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoDownload: autoDownload ?? this.autoDownload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'fontSize': fontSize,
      'nightMode': nightMode,
      'notificationsEnabled': notificationsEnabled,
      'autoDownload': autoDownload,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      fontSize: (json['fontSize'] ?? 16.0).toDouble(),
      nightMode: json['nightMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      autoDownload: json['autoDownload'] ?? false,
    );
  }
}
