import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReaderPage extends StatefulWidget {
  final String bookId;
  final String bookTitle;
  final String bookUrl;

  const ReaderPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.bookUrl,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  int _currentPage = 1;
  final int _totalPages = 150;
  double _fontSize = 16.0;
  bool _isNightMode = false;
  bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNightMode ? Colors.black87 : Colors.white,
      appBar: _showControls
          ? AppBar(
              title: Text(
                widget.bookTitle,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: _isNightMode ? Colors.black54 : null,
              foregroundColor: _isNightMode ? Colors.white : null,
              actions: [
                IconButton(
                  onPressed: _toggleBookmark,
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: 'Bookmark',
                ),
                IconButton(
                  onPressed: _shareBook,
                  icon: const Icon(Icons.share),
                  tooltip: 'Share',
                ),
                PopupMenuButton<String>(
                  onSelected: _onMenuSelected,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text('Download'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Reading Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // Reading Content
            Positioned.fill(
              child: _buildReaderContent(),
            ),
            
            // Bottom Controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaderContent() {
    // Simulated reading content
    return Container(
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _showControls ? 0 : 60.h),
            
            // Sample Bengali text content
            Text(
              'রবীন্দ্রনাথের কবিতা',
              style: TextStyle(
                fontSize: _fontSize + 4,
                fontWeight: FontWeight.bold,
                color: _isNightMode ? Colors.white : Colors.black,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            Text(
              '''আকাশভরা সূর্য-তারা, বিশ্বভরা প্রাণ,
তাহার মাঝখানে আমি পেয়েছি মোর স্থান।

বিস্ময়ে তাই জাগে আমার গান।

আমার চোখে ধরা দেয়, আলোক ছায়ে তা ভেসে যায়—
ছবি ফিরায়ে আনে মনে মোর আঁকা।

বিস্ময়ে তাই জাগে আমার গান।

মোর পরানে লাগে আঘাত, প্রেমে বারি আনে মোর পাত,
সখি রে আঙ্গিনায় পড়ে মোর ঢাকা।

বিস্ময়ে তাই জাগে আমার গান।

মোর ভাবনায় মিশে আছে কত শত কথা,
সেই সুর দিয়ে বলি গো, তোমার কাছে এসেছি বলি।
মোর প্রাণের স্বর গো, শুনে রাখো রাখো কাছে।

বিস্ময়ে তাই জাগে আমার গান।

এই যে জগৎ জুড়ে আমি দিয়েছি আমার ভাল,
বিশ্ব জুড়ে রয়েছি খেলে, রয়েছি কাছে দূরে।
সবার সাথে বেঁধেছি এই যে আমার জাল—

বিস্ময়ে তাই জাগে আমার গান।
''',
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8,
                color: _isNightMode ? Colors.white : Colors.black,
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // English sample text
            Text(
              'The Wonder of Literature',
              style: TextStyle(
                fontSize: _fontSize + 4,
                fontWeight: FontWeight.bold,
                color: _isNightMode ? Colors.white : Colors.black,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            Text(
              '''Literature has the power to transport us to different worlds, different times, and help us understand different perspectives. Through books, we can experience the depths of human emotion, learn from the wisdom of ages, and discover truths about ourselves and the world around us.

In this digital age, where information flows rapidly and attention spans are challenged, the art of deep reading becomes even more precious. Books offer us the opportunity to slow down, to contemplate, and to engage with ideas in a meaningful way.

The beauty of a well-crafted sentence, the power of a compelling narrative, the insight of a profound observation—these are the gifts that literature bestows upon its readers. They remind us of our shared humanity and help us navigate the complexities of life with greater wisdom and empathy.

Whether we're reading poetry that captures the essence of a moment, fiction that explores the human condition, or non-fiction that expands our understanding of the world, literature enriches our lives in countless ways.''',
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.6,
                color: _isNightMode ? Colors.white : Colors.black,
              ),
            ),
            
            SizedBox(height: 100.h), // Space for bottom controls
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: _isNightMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Bar
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  '$_currentPage',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isNightMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                      trackHeight: 4.h,
                    ),
                    child: Slider(
                      value: _currentPage.toDouble(),
                      min: 1,
                      max: _totalPages.toDouble(),
                      onChanged: (value) => setState(() => _currentPage = value.round()),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '$_totalPages',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isNightMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Control Buttons
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _decreaseFontSize,
                  icon: Icon(
                    Icons.text_decrease,
                    color: _isNightMode ? Colors.white70 : Colors.grey[700],
                    size: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: _increaseFontSize,
                  icon: Icon(
                    Icons.text_increase,
                    color: _isNightMode ? Colors.white70 : Colors.grey[700],
                    size: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: _toggleNightMode,
                  icon: Icon(
                    _isNightMode ? Icons.light_mode : Icons.dark_mode,
                    color: _isNightMode ? Colors.white70 : Colors.grey[700],
                    size: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: _showReadingSettings,
                  icon: Icon(
                    Icons.settings,
                    color: _isNightMode ? Colors.white70 : Colors.grey[700],
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleBookmark() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark added'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareBook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing book...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download started...'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'settings':
        _showReadingSettings();
        break;
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > 12) {
      setState(() => _fontSize -= 2);
    }
  }

  void _increaseFontSize() {
    if (_fontSize < 24) {
      setState(() => _fontSize += 2);
    }
  }

  void _toggleNightMode() {
    setState(() => _isNightMode = !_isNightMode);
  }

  void _showReadingSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300.h,
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Settings',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font Size'),
              subtitle: Text('${_fontSize.toInt()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _decreaseFontSize,
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: _increaseFontSize,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),            SwitchListTile(
              title: const Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 8),
                  Text('Night Mode'),
                ],
              ),
              value: _isNightMode,
              onChanged: (value) {
                setState(() => _isNightMode = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
