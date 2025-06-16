import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/models/book.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  static final List<CategoryChip> _categories = [
    CategoryChip(
      label: 'Books',
      labelBn: 'বই',
      icon: Icons.menu_book,
      type: BookType.book,
      color: Colors.blue,
    ),
    CategoryChip(
      label: 'Magazines',
      labelBn: 'ম্যাগাজিন',
      icon: Icons.article,
      type: BookType.magazine,
      color: Colors.green,
    ),
    CategoryChip(
      label: 'Articles',
      labelBn: 'নিবন্ধ',
      icon: Icons.description,
      type: BookType.article,
      color: Colors.orange,
    ),
    CategoryChip(
      label: 'Organizations',
      labelBn: 'সংস্থা',
      icon: Icons.business,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => _navigateToCategory(context, category),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: category.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      color: category.color,
                      size: 20.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToCategory(BuildContext context, CategoryChip category) {
    Map<String, dynamic> arguments = {};
    
    if (category.type != null) {
      arguments['type'] = category.type;
    }
    
    if (category.label == 'Organizations') {
      // TODO: Navigate to organizations list
      return;
    }
    
    Navigator.pushNamed(
      context,
      AppRouter.explore,
      arguments: arguments,
    );
  }
}

class CategoryChip {
  final String label;
  final String labelBn;
  final IconData icon;
  final BookType? type;
  final Color color;

  const CategoryChip({
    required this.label,
    required this.labelBn,
    required this.icon,
    this.type,
    required this.color,
  });
}
