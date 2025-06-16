import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/user.dart';
import '../../../../core/models/book.dart';
import '../../../../core/models/author.dart';
import '../../../../core/models/organization.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../home/presentation/widgets/book_card.dart';

class UserDashboardPage extends ConsumerStatefulWidget {
  const UserDashboardPage({super.key});

  @override
  ConsumerState<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends ConsumerState<UserDashboardPage> 
    with SingleTickerProviderStateMixin {
  final DummyDataService _dataService = DummyDataService();
  late TabController _tabController;
  
  User? _currentUser;
  List<Book> _savedBooks = [];
  List<Author> _followingAuthors = [];
  List<Organization> _followingOrganizations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _dataService.getCurrentUser();
      final savedBooks = await _dataService.getUserSavedBooks();
      final followingAuthors = await _dataService.getUserFollowingAuthors();
      final followingOrganizations = await _dataService.getUserFollowingOrganizations();
      
      if (mounted) {
        setState(() {
          _currentUser = user;
          _savedBooks = savedBooks;
          _followingAuthors = followingAuthors;
          _followingOrganizations = followingOrganizations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                indicatorColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 12.sp),
                tabs: const [
                  Tab(text: 'Saved'),
                  Tab(text: 'History'),
                  Tab(text: 'Authors'),
                  Tab(text: 'Organizations'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSavedBooksTab(),
            _buildReadingHistoryTab(),
            _buildFollowingAuthorsTab(),
            _buildFollowingOrganizationsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _currentUser?.profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: _currentUser!.profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Name
          Text(
            _currentUser?.name ?? 'User',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.displaySmall?.color,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Email
          Text(
            _currentUser?.email ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Saved', _savedBooks.length.toString()),
              _buildStatItem('Following', 
                (_followingAuthors.length + _followingOrganizations.length).toString()),
              _buildStatItem('History', _currentUser?.readingHistory.length.toString() ?? '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedBooksTab() {
    if (_savedBooks.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_border,
        title: 'No Saved Books',
        subtitle: 'Books you save will appear here',
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: _savedBooks.length,
      itemBuilder: (context, index) {
        final book = _savedBooks[index];
        return BookCard(
          book: book,
          onTap: () => _navigateToReader(book),
        );
      },
    );
  }

  Widget _buildReadingHistoryTab() {
    final readingHistory = _currentUser?.readingHistory ?? [];
    
    if (readingHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Reading History',
        subtitle: 'Books you read will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: readingHistory.length,
      itemBuilder: (context, index) {
        final item = readingHistory[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.bookCoverUrl,
                width: 50.w,
                height: 70.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50.w,
                  height: 70.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.book, color: Colors.grey[600]),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50.w,
                  height: 70.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.book, color: Colors.grey[600]),
                ),
              ),
            ),
            title: Text(
              item.bookTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  'Page ${item.currentPage} of ${item.totalPages}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                LinearProgressIndicator(
                  value: item.progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            trailing: Text(
              _formatDate(item.lastReadDate),
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            onTap: () {
              // Navigate to reader with the book
              Navigator.pushNamed(
                context,
                AppRouter.reader,
                arguments: {
                  'bookId': item.bookId,
                  'bookTitle': item.bookTitle,
                  'bookUrl': '',
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFollowingAuthorsTab() {
    if (_followingAuthors.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_outline,
        title: 'No Following Authors',
        subtitle: 'Authors you follow will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _followingAuthors.length,
      itemBuilder: (context, index) {
        final author = _followingAuthors[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.r,
              backgroundImage: author.profileImageUrl != null
                  ? CachedNetworkImageProvider(author.profileImageUrl!)
                  : null,
              child: author.profileImageUrl == null
                  ? Icon(Icons.person, size: 25.sp)
                  : null,
            ),
            title: Text(
              author.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${author.totalWorks} works • ${author.followersCount} followers',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: OutlinedButton(
              onPressed: () => _unfollowAuthor(author.id),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                'Following',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.authorProfile,
                arguments: {'authorId': author.id},
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFollowingOrganizationsTab() {
    if (_followingOrganizations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.business_outlined,
        title: 'No Following Organizations',
        subtitle: 'Organizations you follow will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _followingOrganizations.length,
      itemBuilder: (context, index) {
        final organization = _followingOrganizations[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.r,
              backgroundImage: CachedNetworkImageProvider(organization.logoUrl),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
            title: Text(
              organization.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${organization.totalPublications} publications • ${organization.followersCount} followers',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: OutlinedButton(
              onPressed: () => _unfollowOrganization(organization.id),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                'Following',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.organizationProfile,
                arguments: {'organizationId': organization.id},
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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

  void _unfollowAuthor(String authorId) {
    setState(() {
      _followingAuthors.removeWhere((author) => author.id == authorId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unfollowed author'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _unfollowOrganization(String organizationId) {
    setState(() {
      _followingOrganizations.removeWhere((org) => org.id == organizationId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unfollowed organization'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
