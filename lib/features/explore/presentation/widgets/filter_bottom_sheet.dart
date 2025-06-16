import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/book.dart';

class FilterBottomSheet extends StatefulWidget {
  final BookType? selectedType;
  final String? selectedLanguage;
  final Function(BookType?, String?, String?, String?) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedType,
    this.selectedLanguage,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  BookType? _selectedType;
  String? _selectedLanguage;
  String? _selectedAuthor;
  String? _selectedOrganization;

  final List<String> _languages = ['English', 'বাংলা', 'हिन्दी', 'اردو'];
  final List<String> _authors = ['রবীন্দ্রনাথ ঠাকুর', 'John Smith', 'হুমায়ূন আহমেদ'];
  final List<String> _organizations = ['বাংলা একাডেমি', 'Poetry Foundation', 'বাংলাদেশ বিজ্ঞান একাডেমি'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayMedium?.color,
                  ),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1.h),
          
          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content Type
                  _buildFilterSection(
                    'Content Type',
                    _buildTypeChips(),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Language
                  _buildFilterSection(
                    'Language',
                    _buildLanguageChips(),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Author
                  _buildFilterSection(
                    'Author',
                    _buildAuthorChips(),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Organization
                  _buildFilterSection(
                    'Organization',
                    _buildOrganizationChips(),
                  ),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Container(
            padding: EdgeInsets.all(20.w),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        SizedBox(height: 12.h),
        content,
      ],
    );
  }

  Widget _buildTypeChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: BookType.values.map((type) {
        final isSelected = _selectedType == type;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedType = isSelected ? null : type;
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),            child: Text(
              _getTypeText(type),
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected 
                    ? Colors.white 
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguageChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _languages.map((language) {
        final isSelected = _selectedLanguage == language;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedLanguage = isSelected ? null : language;
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              language,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected 
                    ? Colors.white 
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAuthorChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _authors.map((author) {
        final isSelected = _selectedAuthor == author;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedAuthor = isSelected ? null : author;
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              author,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected 
                    ? Colors.white 
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrganizationChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _organizations.map((organization) {
        final isSelected = _selectedOrganization == organization;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedOrganization = isSelected ? null : organization;
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              organization,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected 
                    ? Colors.white 
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
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

  void _clearAll() {
    setState(() {
      _selectedType = null;
      _selectedLanguage = null;
      _selectedAuthor = null;
      _selectedOrganization = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _selectedType,
      _selectedLanguage,
      _selectedAuthor,
      _selectedOrganization,
    );
    Navigator.pop(context);
  }
}
