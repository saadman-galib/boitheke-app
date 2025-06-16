import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/book.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../home/presentation/widgets/book_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final DummyDataService _dataService = DummyDataService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;
  
  // Filter states
  BookType? _selectedType;
  String? _selectedLanguage;
  String? _selectedAuthor;
  String? _selectedOrganization;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    
    try {
      final books = await _dataService.getAllBooks(
        type: _selectedType,
        language: _selectedLanguage,
        searchQuery: _searchController.text.trim(),
      );
      
      if (mounted) {
        setState(() {
          _books = books;
          _filteredBooks = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = _books;
      } else {
        _filteredBooks = _books.where((book) {
          final searchLower = query.toLowerCase();
          return book.title.toLowerCase().contains(searchLower) ||
                 book.author.toLowerCase().contains(searchLower) ||
                 book.description.toLowerCase().contains(searchLower) ||
                 book.organizationName.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedType: _selectedType,
        selectedLanguage: _selectedLanguage,
        onApplyFilters: (type, language, author, organization) {
          setState(() {
            _selectedType = type;
            _selectedLanguage = language;
            _selectedAuthor = author;
            _selectedOrganization = organization;
          });
          _loadBooks();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedLanguage = null;
      _selectedAuthor = null;
      _selectedOrganization = null;
      _searchController.clear();
    });
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        elevation: 0,
        actions: [
          if (_hasActiveFilters())
            IconButton(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear Filters',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search publications...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          size: 20.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Filter Button
                Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: _hasActiveFilters() 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _showFilterBottomSheet,
                    icon: Icon(
                      Icons.tune,
                      color: _hasActiveFilters() 
                          ? Colors.white 
                          : Theme.of(context).textTheme.bodySmall?.color,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Active Filters Chips
          if (_hasActiveFilters())
            Container(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedType != null)
                    _buildFilterChip(
                      _getTypeText(_selectedType!),
                      () => setState(() => _selectedType = null),
                    ),
                  if (_selectedLanguage != null)
                    _buildFilterChip(
                      _selectedLanguage!,
                      () => setState(() => _selectedLanguage = null),
                    ),
                ],
              ),
            ),
          
          // Results Count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Text(
                  '${_filteredBooks.length} publications found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          
          // Books Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(context),
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                        ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return BookCard(
                            book: book,
                            onTap: () => _navigateToReader(book),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        deleteIcon: const Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ),
        onDeleted: onRemove,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            'No publications found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedType != null || 
           _selectedLanguage != null || 
           _selectedAuthor != null || 
           _selectedOrganization != null;
  }

  String _getTypeText(BookType type) {
    switch (type) {
      case BookType.book:
        return 'Books';
      case BookType.magazine:
        return 'Magazines';
      case BookType.article:
        return 'Articles';
    }
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  void _navigateToReader(Book book) {
    Navigator.pushNamed(
      context,
      AppRouter.reader,
      arguments: {
        'bookId': book.id,
        'bookTitle': book.title,
        'bookUrl': book.pdfUrl ?? '',
      },
    );
  }
}
