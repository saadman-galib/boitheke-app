import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/user.dart';
import '../../../../core/models/book.dart';
import '../../../../core/models/author.dart';
import '../../../../core/models/organization.dart';
import '../../../../core/services/dummy_data_service.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Modern Profile Header
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildModernProfileHeader(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettings(),
              ),
            ],
          ),
          
          // Tabs Section
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                tabs: const [
                  Tab(text: 'Saved'),
                  Tab(text: 'History'),
                  Tab(text: 'Authors'),
                  Tab(text: 'Organizations'),
                ],
              ),
            ),
          ),
          
          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSavedBooksTab(),
                _buildReadingHistoryTab(),
                _buildFollowingAuthorsTab(),
                _buildFollowingOrganizationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Profile Image
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: _currentUser?.profileImageUrl != null
                      ? CachedNetworkImageProvider(_currentUser!.profileImageUrl!)
                      : null,
                  backgroundColor: Colors.white,
                  child: _currentUser?.profileImageUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50.sp,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Name
              Text(
                _currentUser?.name ?? 'User',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 4.h),
              
              // Email
              if (_currentUser?.email != null)
                Text(
                  _currentUser!.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              
              SizedBox(height: 20.h),
              
              // Stats Row
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Saved', _savedBooks.length.toString()),
                    _buildDivider(),
                    _buildStatItem('Following', 
                      (_followingAuthors.length + _followingOrganizations.length).toString()),
                    _buildDivider(),
                    _buildStatItem('History', _currentUser?.readingHistory.length.toString() ?? '0'),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildSavedBooksTab() {
    if (_savedBooks.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_outline,
        title: 'No Saved Books',
        subtitle: 'Start saving books to read them later',
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: _savedBooks.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: _savedBooks[index],
            onTap: () => _openBook(_savedBooks[index]),
          );
        },
      ),
    );
  }

  Widget _buildReadingHistoryTab() {
    final history = _currentUser?.readingHistory ?? [];
    
    if (history.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Reading History',
        subtitle: 'Your reading history will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: Container(
              width: 40.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.book,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              item.bookTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Read on ${item.lastReadDate.day}/${item.lastReadDate.month}/${item.lastReadDate.year}',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to book
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
        subtitle: 'Follow authors to see their latest works',
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
              backgroundImage: author.profileImageUrl != null
                  ? CachedNetworkImageProvider(author.profileImageUrl!)
                  : null,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: author.profileImageUrl == null
                  ? Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            title: Text(
              author.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${author.totalWorks} works • ${author.followersCount} followers',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
            onTap: () => _openAuthorProfile(author.id),
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
        subtitle: 'Follow organizations to see their publications',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _followingOrganizations.length,
      itemBuilder: (context, index) {
        final org = _followingOrganizations[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(org.logoUrl),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            title: Text(
              org.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${org.totalPublications} publications',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
            onTap: () => _openOrganizationProfile(org.id),
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
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.sp,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openBook(Book book) {
    Navigator.pushNamed(
      context,
      '/reader',
      arguments: book.id,
    );
  }

  void _openAuthorProfile(String authorId) {
    Navigator.pushNamed(
      context,
      '/author-profile',
      arguments: authorId,
    );
  }

  void _openOrganizationProfile(String orgId) {
    Navigator.pushNamed(
      context,
      '/organization-profile',
      arguments: orgId,
    );
  }

  void _showSettings() {
    // Navigate to settings page
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListTile(
                    leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to edit profile
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                    title: const Text('Notifications'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to notifications settings
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: Theme.of(context).primaryColor),
                    title: const Text('Privacy'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to privacy settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      _logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    // Implement logout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Logging out...'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
