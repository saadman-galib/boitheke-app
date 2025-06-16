import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/organization.dart';
import '../../../../core/models/book.dart';
import '../../../../core/services/dummy_data_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../home/presentation/widgets/book_card.dart';

class OrganizationProfilePage extends ConsumerStatefulWidget {
  final String organizationId;

  const OrganizationProfilePage({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<OrganizationProfilePage> createState() => _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends ConsumerState<OrganizationProfilePage> {
  final DummyDataService _dataService = DummyDataService();
  
  Organization? _organization;
  List<Book> _publications = [];
  bool _isLoading = true;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadOrganizationData();
  }

  Future<void> _loadOrganizationData() async {
    try {
      final organization = await _dataService.getOrganizationById(widget.organizationId);
      final publications = await _dataService.getAllBooks(
        organizationId: widget.organizationId,
      );
      
      if (mounted && organization != null) {
        setState(() {
          _organization = organization;
          _publications = publications;
          _isFollowing = organization.isFollowing;
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

    if (_organization == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Organization')),
        body: const Center(
          child: Text('Organization not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
            ),
          ),
          
          // Publications Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Publications (${_publications.length})',
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
          
          // Publications Grid
          _publications.isEmpty
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
                        final book = _publications[index];
                        return BookCard(
                          book: book,
                          onTap: () => _navigateToReader(book),
                        );
                      },
                      childCount: _publications.length,
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
            
            // Logo
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CachedNetworkImage(
                  imageUrl: _organization!.logoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.business,
                      size: 50.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.business,
                      size: 50.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Name and Verification
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _organization!.name,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_organization!.isVerified) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ],
            ),
            
            SizedBox(height: 8.h),
            
            // Description
            Text(
              _organization!.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 20.h),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Publications', _organization!.totalPublications.toString()),
                _buildStatItem('Followers', _formatNumber(_organization!.followersCount)),
                _buildStatItem('Founded', _organization!.createdDate.year.toString()),
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
                
                // Contact Button
                if (_organization!.email != null || _organization!.website != null)
                  ElevatedButton(
                    onPressed: _showContactOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                    child: Icon(
                      Icons.contact_mail,
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
              'No Publications Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This organization hasn\'t published any content yet.',
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
      await _dataService.toggleOrganizationFollow(widget.organizationId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing ? 'Following organization' : 'Unfollowed organization',
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

  void _showContactOptions() {
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
              'Contact ${_organization!.name}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            
            if (_organization!.website != null)
              ListTile(
                leading: const Icon(Icons.web),
                title: const Text('Website'),
                subtitle: Text(_organization!.website!),
                onTap: () => _launchUrl(_organization!.website!),
              ),
            
            if (_organization!.email != null)
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(_organization!.email!),
                onTap: () => _launchUrl('mailto:${_organization!.email!}'),
              ),
            
            if (_organization!.phone != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: Text(_organization!.phone!),
                onTap: () => _launchUrl('tel:${_organization!.phone!}'),
              ),
            
            if (_organization!.address != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Address'),
                subtitle: Text(_organization!.address!),
              ),
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
