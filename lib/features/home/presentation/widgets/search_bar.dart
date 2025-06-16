import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/app_router.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRouter.explore,
        arguments: {'searchQuery': _controller.text.trim()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _onSearch(),
        decoration: InputDecoration(
          hintText: 'Search books, authors, organizations...',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodySmall?.color,
            size: 20.sp,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: 20.sp,
                  ),
                )
              : IconButton(
                  onPressed: _onSearch,
                  icon: Icon(
                    Icons.tune,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: 20.sp,
                  ),
                ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }
}
