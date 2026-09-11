library newsfeed_multiple_imageview;

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:newsfeed_multiple_imageview/src/smart_image.dart';

import 'package:newsfeed_multiple_imageview/src/multiple_image_view.dart';

class NewsfeedMultipleImageView extends StatelessWidget {

  final List<String> imageUrls;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;

  const NewsfeedMultipleImageView({
    Key? key,
    this.marginLeft = 0,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, costraints) => Container(
        width: costraints.maxWidth,
        height: costraints.maxWidth,
        margin: EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        child: GestureDetector(
          child: MultipleImageView(imageUrls: imageUrls),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewer(imageUrls: imageUrls),
            ),
          ),
        ),
      ),
    );
  }
}
class ImageViewer extends StatefulWidget {
  final List<String> imageUrls;

  const ImageViewer({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    if (_selectedIndex == index) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const Center(
                child: Text(
                  'Không có hình ảnh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Spacer(),

                  // Hiển thị vị trí ảnh hiện tại
                  Text(
                    '${_selectedIndex + 1}/${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 20),
                ],
              ),
            ),

            // Ảnh lớn
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: SmartImage(
                      widget.imageUrls[index],
                      fit: BoxFit.contain,
                      isPost: true,
                    ),
                  );
                },
              ),
            ),

            // Danh sách ảnh preview
            if (widget.imageUrls.length > 1)
              Container(
                height: 92,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                color: Colors.black,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imageUrls.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        index == _selectedIndex;

                    return GestureDetector(
                      onTap: () => _selectImage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68,
                        height: 68,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Opacity(
                            opacity: isSelected ? 1 : 0.6,
                            child: SmartImage(
                              widget.imageUrls[index],
                              fit: BoxFit.cover,
                              isPost: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// class ImageViewer extends StatelessWidget {
//   final List<String> imageUrls;
//   const ImageViewer({Key? key,
//     required this.imageUrls,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SafeArea(
//       bottom: false,
//       child: Container(
//         // width: MediaQuery.of(context).size.width,
//         // height: MediaQuery.of(context).size.height,
//         color: Colors.black,
//         child: SafeArea(
//           top: false,
//           left: false,
//           right: false,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//               Expanded(
//                 child: ImageSlideshow(
//                   initialPage: 0,
//                   indicatorColor: Colors.red,
//                   indicatorBackgroundColor: Colors.grey,
//                   isLoop: imageUrls.length > 1,
//                   children: imageUrls
//                       .map(
//                         (e) => ClipRect(
//                       child: SmartImage(
//                         e,
//                         fit: BoxFit.contain,
//                         isPost: true,
//                       ),
//                     ),
//                   )
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }


