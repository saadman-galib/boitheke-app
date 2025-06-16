import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/models/book.dart';
import '../../../home/presentation/widgets/book_card.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DummyDataService _dataService = DummyDataService();
  
  List<Book> _favoriteBooks = [];
  List<Book> _readingListBooks = [];
  List<Book> _readBooks = [];
  Map<String, List<Book>> _customCollections = {};
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadLibraryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLibraryData() async {
    try {
      final allBooks = await _dataService.getAllBooks();
      
      setState(() {
        // Simulate user's personal library collections
        _favoriteBooks = allBooks.take(8).toList();
        _readingListBooks = allBooks.skip(8).take(6).toList();
        _readBooks = allBooks.skip(14).take(5).toList();
          // Custom collections
        _customCollections = {
          'Bengali Literature': allBooks.where((book) => book.language == 'বাংলা').take(4).toList(),
          'Science Fiction': allBooks.where((book) => book.tags.any((tag) => tag.toLowerCase().contains('science'))).take(3).toList(),
          'Recently Added': allBooks.take(5).toList(),
        };
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Library',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.sp),
            onPressed: () => _showLibrarySearch(),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 24.sp),
            onPressed: () => _showCreateCollectionDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 14.sp),
          tabs: const [
            Tab(text: 'Favorites'),
            Tab(text: 'Reading List'),
            Tab(text: 'Read'),
            Tab(text: 'Collections'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookGrid(_favoriteBooks, 'No favorite books yet'),
                _buildBookGrid(_readingListBooks, 'Your reading list is empty'),
                _buildBookGrid(_readBooks, 'No completed books yet'),
                _buildCollectionsTab(),
              ],
            ),
    );
  }

  Widget _buildBookGrid(List<Book> books, String emptyMessage) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            onTap: () => _navigateToReader(books[index]),
          );
        },
      ),
    );
  }

  Widget _buildCollectionsTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Collections',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _showCreateCollectionDialog,
                icon: Icon(Icons.add, size: 20.sp),
                label: Text('New Collection'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _customCollections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.collections_bookmark_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No collections yet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: _showCreateCollectionDialog,
                          child: const Text('Create Collection'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _customCollections.length,
                    itemBuilder: (context, index) {
                      final collectionName = _customCollections.keys.elementAt(index);
                      final books = _customCollections[collectionName]!;
                      
                      return _buildCollectionCard(collectionName, books);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(String name, List<Book> books) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Collection'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Collection'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteCollection(name);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '${books.length} books',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: 8.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              books[index].coverImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          books[index].title,
                          style: TextStyle(fontSize: 10.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReader(Book book) {
    Navigator.pushNamed(
      context,
      '/reader',
      arguments: book,
    );
  }

  void _showLibrarySearch() {
    showSearch(
      context: context,
      delegate: LibrarySearchDelegate(_getAllLibraryBooks()),
    );
  }

  List<Book> _getAllLibraryBooks() {
    final allBooks = <Book>[];
    allBooks.addAll(_favoriteBooks);
    allBooks.addAll(_readingListBooks);
    allBooks.addAll(_readBooks);
    
    for (final collection in _customCollections.values) {
      allBooks.addAll(collection);
    }
    
    return allBooks.toSet().toList(); // Remove duplicates
  }

  void _showCreateCollectionDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Collection'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Collection name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _customCollections[controller.text] = [];
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteCollection(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customCollections.remove(name);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class LibrarySearchDelegate extends SearchDelegate<Book?> {
  final List<Book> books;

  LibrarySearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              book.coverImageUrl,
              width: 40.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);
            Navigator.pushNamed(
              context,
              '/reader',
              arguments: book,
            );
          },
        );
      },
    );
  }
}
