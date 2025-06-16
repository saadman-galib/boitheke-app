import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/book.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/book_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chips.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final DummyDataService _dataService = DummyDataService();
  List<Book> _featuredBooks = [];
  List<Book> _recentBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final featuredBooks = await _dataService.getFeaturedBooks();
      final recentBooks = await _dataService.getRecentBooks();
      
      if (mounted) {
        setState(() {
          _featuredBooks = featuredBooks;
          _recentBooks = recentBooks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
              title: Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'BoiTheke',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Implement notifications
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const CustomSearchBar(),
            ),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          
          // Category Chips
          const SliverToBoxAdapter(
            child: CategoryChips(),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          
          // Featured Books Section
          SliverToBoxAdapter(
            child: _buildSectionHeader('Featured Publications', 'প্রদর্শিত প্রকাশনা'),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildLoadingShimmer()
                : _buildFeaturedBooksCarousel(),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          
          // Recently Published Section
          SliverToBoxAdapter(
            child: _buildSectionHeader('Recently Published', 'সম্প্রতি প্রকাশিত'),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          
          // Recent Books Grid
          _isLoading
              ? SliverToBoxAdapter(child: _buildLoadingShimmer())
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _recentBooks.length) return null;
                        return BookCard(
                          book: _recentBooks[index],
                          onTap: () => _navigateToReader(_recentBooks[index]),
                        );
                      },
                      childCount: _recentBooks.length,
                    ),
                  ),
                ),
          
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String titleBn) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                ),
              ),
              Text(
                titleBn,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.explore);
            },
            child: Text(
              'See All',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBooksCarousel() {
    return SizedBox(
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _featuredBooks.length,
        itemBuilder: (context, index) {
          final book = _featuredBooks[index];
          return Container(
            width: 180.w,
            margin: EdgeInsets.only(right: 16.w),
            child: BookCard(
              book: book,
              onTap: () => _navigateToReader(book),
              showFeaturedBadge: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      height: 260.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 180.w,
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
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
