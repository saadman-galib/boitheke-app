import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/author.dart';
import '../../../../core/models/book.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../home/presentation/widgets/book_card.dart';

class AuthorProfilePage extends ConsumerStatefulWidget {
  final String authorId;

  const AuthorProfilePage({
    super.key,
    required this.authorId,
  });

  @override
  ConsumerState<AuthorProfilePage> createState() => _AuthorProfilePageState();
}

class _AuthorProfilePageState extends ConsumerState<AuthorProfilePage> {
  final DummyDataService _dataService = DummyDataService();
  
  Author? _author;
  List<Book> _works = [];
  bool _isLoading = true;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
  }

  Future<void> _loadAuthorData() async {
    try {
      final author = await _dataService.getAuthorById(widget.authorId);
      final works = await _dataService.getAllBooks(
        authorId: widget.authorId,
      );
      
      if (mounted && author != null) {
        setState(() {
          _author = author;
          _works = works;
          _isFollowing = author.isFollowing;
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

    if (_author == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Author')),
        body: const Center(
          child: Text('Author not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 350.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
            ),
          ),
          
          // Works Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Works (${_works.length})',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Works Grid
          _works.isEmpty
              ? SliverToBoxAdapter(
                  child: _buildEmptyState(),
                )
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
                        final book = _works[index];
                        return BookCard(
                          book: book,
                          onTap: () => _navigateToReader(book),
                        );
                      },
                      childCount: _works.length,
                    ),
                  ),
                ),
          
          SliverToBoxAdapter(child: SizedBox(height: 40.h)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
        child: Column(
          children: [
            const Spacer(),
            
            // Profile Image
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: _author!.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: _author!.profileImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 60.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 60.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Name
            Text(
              _author!.name,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 8.h),
            
            // Nationality and Birth Year
            if (_author!.nationality != null || _author!.birthDate != null)
              Text(
                [
                  if (_author!.nationality != null) _author!.nationality!,
                  if (_author!.birthDate != null) _author!.birthDate!.year.toString(),
                ].join(' • '),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            
            SizedBox(height: 12.h),
            
            // Genres
            if (_author!.genres.isNotEmpty)
              Wrap(
                spacing: 8.w,
                children: _author!.genres.take(3).map((genre) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            
            SizedBox(height: 16.h),
            
            // Bio
            if (_author!.bio != null)
              Text(
                _author!.bio!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            
            SizedBox(height: 20.h),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Works', _author!.totalWorks.toString()),
                _buildStatItem('Followers', _formatNumber(_author!.followersCount)),
                _buildStatItem('Genres', _author!.genres.length.toString()),
              ],
            ),
            
            SizedBox(height: 20.h),
            
            // Action Buttons
            Row(
              children: [
                // Follow Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFollowing ? Colors.white : Colors.transparent,
                      foregroundColor: _isFollowing ? Theme.of(context).primaryColor : Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      _isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Social Links Button
                if (_author!.socialLinks.isNotEmpty)
                  ElevatedButton(
                    onPressed: _showSocialLinks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                    child: Icon(
                      Icons.share,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ],
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
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Works Available',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This author\'s works are not yet available on the platform.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _toggleFollow() async {
    setState(() => _isFollowing = !_isFollowing);
    
    try {
      await _dataService.toggleAuthorFollow(widget.authorId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing ? 'Following author' : 'Unfollowed author',
            ),
          duration: const Duration(seconds: 2),
        ),
      );
      }
    } catch (e) {
      // Revert on error
      setState(() => _isFollowing = !_isFollowing);
    }
  }

  void _showSocialLinks() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Social Links',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            
            ..._author!.socialLinks.map((link) {
              IconData icon = Icons.link;
              String platform = 'Link';
              
              if (link.contains('twitter.com')) {
                icon = Icons.alternate_email;
                platform = 'Twitter';
              } else if (link.contains('linkedin.com')) {
                icon = Icons.business;
                platform = 'LinkedIn';
              } else if (link.contains('facebook.com')) {
                icon = Icons.facebook;
                platform = 'Facebook';
              } else if (link.contains('instagram.com')) {
                icon = Icons.camera_alt;
                platform = 'Instagram';
              } else if (link.contains('youtube.com')) {
                icon = Icons.play_arrow;
                platform = 'YouTube';
              }
              
              return ListTile(
                leading: Icon(icon),
                title: Text(platform),
                subtitle: Text(
                  link,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _launchUrl(link),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    if (mounted) Navigator.pop(context);
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
