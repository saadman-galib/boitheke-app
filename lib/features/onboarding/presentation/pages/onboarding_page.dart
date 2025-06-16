import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/router/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      icon: Icons.library_books,
      title: 'Discover Digital Library',
      titleBn: 'ডিজিটাল লাইব্রেরি আবিষ্কার করুন',
      description: 'Access thousands of books, magazines, and articles from verified publishers and organizations.',
      descriptionBn: 'যাচাইকৃত প্রকাশক এবং সংস্থাগুলি থেকে হাজার হাজার বই, ম্যাগাজিন এবং নিবন্ধ অ্যাক্সেস করুন।',
    ),
    OnboardingContent(
      icon: Icons.school,
      title: 'Learn & Explore',
      titleBn: 'শিখুন এবং অন্বেষণ করুন',
      description: 'Explore content by categories, authors, and organizations. Follow your favorite writers.',
      descriptionBn: 'বিভাগ, লেখক এবং সংস্থা অনুসারে বিষয়বস্তু অন্বেষণ করুন। আপনার পছন্দের লেখকদের অনুসরণ করুন।',
    ),
    OnboardingContent(
      icon: Icons.bookmark,
      title: 'Save & Organize',
      titleBn: 'সংরক্ষণ এবং সংগঠিত করুন',
      description: 'Bookmark your favorite books and maintain your personal reading list.',
      descriptionBn: 'আপনার প্রিয় বইগুলি বুকমার্ক করুন এবং আপনার ব্যক্তিগত পঠন তালিকা বজায় রাখুন।',
    ),
  ];

  bool _isLanguageBangla = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMain();
    }
  }

  void _navigateToMain() {
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Language Toggle
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isLanguageBangla = !_isLanguageBangla),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLanguageBangla ? 'বাংলা' : 'English',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.language,
                            size: 16.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  final content = _contents[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            content.icon,
                            size: 60.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        
                        SizedBox(height: 50.h),
                        
                        // Title
                        Text(
                          _isLanguageBangla ? content.titleBn : content.title,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.displayLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Description
                        Text(
                          _isLanguageBangla ? content.descriptionBn : content.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Section
            Padding(
              padding: EdgeInsets.all(30.w),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _contents.length,
                    effect: WormEffect(
                      dotColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      spacing: 12.w,
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Next/Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _contents.length - 1
                            ? (_isLanguageBangla ? 'শুরু করুন' : 'Get Started')
                            : (_isLanguageBangla ? 'পরবর্তী' : 'Next'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Skip Button
                  if (_currentIndex < _contents.length - 1)
                    TextButton(
                      onPressed: _navigateToMain,
                      child: Text(
                        _isLanguageBangla ? 'এড়িয়ে যান' : 'Skip',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final IconData icon;
  final String title;
  final String titleBn;
  final String description;
  final String descriptionBn;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.titleBn,
    required this.description,
    required this.descriptionBn,
  });
}
