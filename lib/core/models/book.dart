class Book {
  final String id;
  final String title;
  final String author;
  final String? authorId;
  final String description;
  final String coverImageUrl;
  final String? pdfUrl;
  final String? epubUrl;
  final List<String> tags;
  final String language;
  final String organizationId;
  final String organizationName;
  final DateTime publishedDate;
  final int totalPages;
  final double rating;
  final int downloadCount;
  final BookType type;
  final bool isFeatured;
  final bool isBookmarked;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.authorId,
    required this.description,
    required this.coverImageUrl,
    this.pdfUrl,
    this.epubUrl,
    required this.tags,
    required this.language,
    required this.organizationId,
    required this.organizationName,
    required this.publishedDate,
    required this.totalPages,
    required this.rating,
    required this.downloadCount,
    required this.type,
    this.isFeatured = false,
    this.isBookmarked = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? authorId,
    String? description,
    String? coverImageUrl,
    String? pdfUrl,
    String? epubUrl,
    List<String>? tags,
    String? language,
    String? organizationId,
    String? organizationName,
    DateTime? publishedDate,
    int? totalPages,
    double? rating,
    int? downloadCount,
    BookType? type,
    bool? isFeatured,
    bool? isBookmarked,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      epubUrl: epubUrl ?? this.epubUrl,
      tags: tags ?? this.tags,
      language: language ?? this.language,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      publishedDate: publishedDate ?? this.publishedDate,
      totalPages: totalPages ?? this.totalPages,
      rating: rating ?? this.rating,
      downloadCount: downloadCount ?? this.downloadCount,
      type: type ?? this.type,
      isFeatured: isFeatured ?? this.isFeatured,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'authorId': authorId,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'pdfUrl': pdfUrl,
      'epubUrl': epubUrl,
      'tags': tags,
      'language': language,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'publishedDate': publishedDate.toIso8601String(),
      'totalPages': totalPages,
      'rating': rating,
      'downloadCount': downloadCount,
      'type': type.name,
      'isFeatured': isFeatured,
      'isBookmarked': isBookmarked,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      authorId: json['authorId'],
      description: json['description'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      pdfUrl: json['pdfUrl'],
      epubUrl: json['epubUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      language: json['language'] ?? '',
      organizationId: json['organizationId'] ?? '',
      organizationName: json['organizationName'] ?? '',
      publishedDate: DateTime.tryParse(json['publishedDate'] ?? '') ?? DateTime.now(),
      totalPages: json['totalPages'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      downloadCount: json['downloadCount'] ?? 0,
      type: BookType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BookType.book,
      ),
      isFeatured: json['isFeatured'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}

enum BookType {
  book,
  magazine,
  article,
}
