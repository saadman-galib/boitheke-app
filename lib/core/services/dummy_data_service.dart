import '../models/book.dart';
import '../models/author.dart';
import '../models/organization.dart';
import '../models/user.dart';

class DummyDataService {
  static final DummyDataService _instance = DummyDataService._internal();
  factory DummyDataService() => _instance;
  DummyDataService._internal();

  // Dummy Books
  static final List<Book> _books = [
    Book(
      id: '1',
      title: 'রবীন্দ্রনাথের কবিতা',
      author: 'রবীন্দ্রনাথ ঠাকুর',
      authorId: 'author1',
      description: 'রবীন্দ্রনাথ ঠাকুরের অমর কবিতার সংকলন। এই বইটিতে রয়েছে তাঁর সেরা কবিতাগুলো।',
      coverImageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300&h=400&fit=crop',
      pdfUrl: 'sample.pdf',
      tags: ['কবিতা', 'বাংলা সাহিত্য', 'রবীন্দ্রনাথ'],
      language: 'বাংলা',
      organizationId: 'org1',
      organizationName: 'বাংলা একাডেমি',
      publishedDate: DateTime.now().subtract(const Duration(days: 30)),
      totalPages: 150,
      rating: 4.8,
      downloadCount: 1250,
      type: BookType.book,
      isFeatured: true,
    ),
    Book(
      id: '2',
      title: 'Modern Poetry Collection',
      author: 'Various Authors',
      description: 'A collection of contemporary poetry from emerging poets around the world.',
      coverImageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop',
      tags: ['Poetry', 'Modern', 'Contemporary'],
      language: 'English',
      organizationId: 'org2',
      organizationName: 'Poetry Foundation',
      publishedDate: DateTime.now().subtract(const Duration(days: 15)),
      totalPages: 200,
      rating: 4.5,
      downloadCount: 850,
      type: BookType.book,
    ),
    Book(
      id: '3',
      title: 'বিজ্ঞান পত্রিকা - জানুয়ারি ২০২৫',
      author: 'সম্পাদক মণ্ডলী',
      description: 'বিজ্ঞানের সর্বশেষ আবিষ্কার ও গবেষণার উপর ভিত্তি করে তৈরি এই মাসিক পত্রিকা।',
      coverImageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=300&h=400&fit=crop',
      tags: ['বিজ্ঞান', 'গবেষণা', 'প্রযুক্তি'],
      language: 'বাংলা',
      organizationId: 'org3',
      organizationName: 'বাংলাদেশ বিজ্ঞান একাডেমি',
      publishedDate: DateTime.now().subtract(const Duration(days: 5)),
      totalPages: 50,
      rating: 4.3,
      downloadCount: 425,
      type: BookType.magazine,
      isFeatured: true,
    ),
    Book(
      id: '4',
      title: 'The Art of Programming',
      author: 'John Smith',
      authorId: 'author2',
      description: 'A comprehensive guide to modern programming practices and methodologies.',
      coverImageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300&h=400&fit=crop',
      tags: ['Programming', 'Technology', 'Education'],
      language: 'English',
      organizationId: 'org4',
      organizationName: 'Tech Publishers',
      publishedDate: DateTime.now().subtract(const Duration(days: 60)),
      totalPages: 350,
      rating: 4.7,
      downloadCount: 2100,
      type: BookType.book,
    ),
    Book(
      id: '5',
      title: 'গল্পের বই',
      author: 'হুমায়ূন আহমেদ',
      authorId: 'author3',
      description: 'হুমায়ূন আহমেদের জনপ্রিয় ছোটগল্পের সংকলন।',
      coverImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop',
      tags: ['গল্প', 'বাংলা সাহিত্য', 'হুমায়ূন আহমেদ'],
      language: 'বাংলা',
      organizationId: 'org1',
      organizationName: 'বাংলা একাডেমি',
      publishedDate: DateTime.now().subtract(const Duration(days: 45)),
      totalPages: 180,
      rating: 4.6,
      downloadCount: 980,
      type: BookType.book,
    ),
  ];

  // Dummy Authors
  static final List<Author> _authors = [
    Author(
      id: 'author1',
      name: 'রবীন্দ্রনাথ ঠাকুর',
      bio: 'বাংলা সাহিত্যের অন্যতম শ্রেষ্ঠ কবি, ঔপন্যাসিক, গল্পকার, নাট্যকার, প্রাবন্ধিক ও দার্শনিক।',
      profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      socialLinks: [],
      totalWorks: 25,
      followersCount: 15420,
      birthDate: DateTime(1861, 5, 7),
      nationality: 'ভারতীয়',
      genres: ['কবিতা', 'গল্প', 'উপন্যাস', 'নাটক'],
    ),
    Author(
      id: 'author2',
      name: 'John Smith',
      bio: 'A renowned software engineer and author with 20+ years of experience in the tech industry.',
      profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      socialLinks: ['https://twitter.com/johnsmith', 'https://linkedin.com/in/johnsmith'],
      totalWorks: 8,
      followersCount: 3250,
      nationality: 'American',
      genres: ['Technology', 'Programming', 'Education'],
    ),
    Author(
      id: 'author3',
      name: 'হুমায়ূন আহমেদ',
      bio: 'বাংলাদেশের জনপ্রিয় ঔপন্যাসিক, গল্পকার, নাট্যকার এবং চলচ্চিত্র নির্মাতা।',
      profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      socialLinks: [],
      totalWorks: 35,
      followersCount: 28500,
      birthDate: DateTime(1948, 11, 13),
      nationality: 'বাংলাদেশী',
      genres: ['উপন্যাস', 'গল্প', 'নাটক', 'চলচ্চিত্র'],
    ),
  ];

  // Dummy Organizations
  static final List<Organization> _organizations = [
    Organization(
      id: 'org1',
      name: 'বাংলা একাডেমি',
      description: 'বাংলা ভাষা ও সাহিত্যের উন্নয়ন ও প্রসারে নিবেদিত প্রতিষ্ঠান।',
      logoUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=100&h=100&fit=crop',
      website: 'https://banglaacademy.org.bd',
      email: 'info@banglaacademy.org.bd',
      socialLinks: [],
      totalPublications: 450,
      followersCount: 25000,
      isVerified: true,
      createdDate: DateTime(1955, 12, 3),
    ),
    Organization(
      id: 'org2',
      name: 'Poetry Foundation',
      description: 'Dedicated to promoting poetry and poets worldwide.',
      logoUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=100&h=100&fit=crop',
      website: 'https://poetryfoundation.org',
      email: 'info@poetryfoundation.org',
      socialLinks: ['https://twitter.com/poetryfound'],
      totalPublications: 180,
      followersCount: 12000,
      isVerified: true,
      createdDate: DateTime(1941, 1, 1),
    ),
    Organization(
      id: 'org3',
      name: 'বাংলাদেশ বিজ্ঞান একাডেমি',
      description: 'বিজ্ঞান গবেষণা ও প্রচারে নিয়োজিত জাতীয় প্রতিষ্ঠান।',
      logoUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=100&h=100&fit=crop',
      website: 'https://bas.org.bd',
      email: 'info@bas.org.bd',
      socialLinks: [],
      totalPublications: 75,
      followersCount: 8500,
      isVerified: true,
      createdDate: DateTime(1973, 5, 8),
    ),
  ];

  // Dummy User
  static final User _currentUser = User(
    id: 'user1',
    name: 'আহমদ হাসান',
    email: 'ahmad.hasan@example.com',
    profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
    savedBooks: ['1', '3'],
    followingAuthors: ['author1', 'author3'],
    followingOrganizations: ['org1'],
    readingHistory: [
      ReadingHistoryItem(
        bookId: '1',
        bookTitle: 'রবীন্দ্রনাথের কবিতা',
        bookCoverUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300&h=400&fit=crop',
        lastReadDate: DateTime.now().subtract(const Duration(days: 2)),
        currentPage: 45,
        totalPages: 150,
        progress: 0.3,
      ),
      ReadingHistoryItem(
        bookId: '4',
        bookTitle: 'The Art of Programming',
        bookCoverUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300&h=400&fit=crop',
        lastReadDate: DateTime.now().subtract(const Duration(days: 5)),
        currentPage: 120,
        totalPages: 350,
        progress: 0.34,
      ),
    ],
    preferences: const UserPreferences(
      language: 'bn',
      theme: 'system',
      fontSize: 16.0,
    ),
    createdDate: DateTime.now().subtract(const Duration(days: 180)),
  );

  // API Methods
  Future<List<Book>> getFeaturedBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _books.where((book) => book.isFeatured).toList();
  }

  Future<List<Book>> getRecentBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final sortedBooks = List<Book>.from(_books);
    sortedBooks.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    return sortedBooks.take(10).toList();
  }

  Future<List<Book>> getAllBooks({
    BookType? type,
    String? language,
    String? authorId,
    String? organizationId,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filteredBooks = _books.where((book) {
      if (type != null && book.type != type) return false;
      if (language != null && book.language != language) return false;
      if (authorId != null && book.authorId != authorId) return false;
      if (organizationId != null && book.organizationId != organizationId) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!book.title.toLowerCase().contains(query) &&
            !book.author.toLowerCase().contains(query) &&
            !book.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    return filteredBooks;
  }

  Future<Book?> getBookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Author>> getAllAuthors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _authors;
  }

  Future<Author?> getAuthorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _authors.firstWhere((author) => author.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Organization>> getAllOrganizations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _organizations;
  }

  Future<Organization?> getOrganizationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _organizations.firstWhere((org) => org.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  Future<List<Book>> getUserSavedBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = await getCurrentUser();
    return _books.where((book) => user.savedBooks.contains(book.id)).toList();
  }

  Future<List<Author>> getUserFollowingAuthors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = await getCurrentUser();
    return _authors.where((author) => user.followingAuthors.contains(author.id)).toList();
  }

  Future<List<Organization>> getUserFollowingOrganizations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = await getCurrentUser();
    return _organizations.where((org) => user.followingOrganizations.contains(org.id)).toList();
  }

  Future<bool> toggleBookSave(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would update the server
    return !_currentUser.savedBooks.contains(bookId);
  }

  Future<bool> toggleAuthorFollow(String authorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would update the server
    return !_currentUser.followingAuthors.contains(authorId);
  }

  Future<bool> toggleOrganizationFollow(String organizationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would update the server
    return !_currentUser.followingOrganizations.contains(organizationId);
  }
}
