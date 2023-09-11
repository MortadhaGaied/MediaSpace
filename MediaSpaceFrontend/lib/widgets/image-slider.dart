import 'package:flutter/material.dart';

class MyImageSlider extends StatefulWidget {
  final List<String> images;

  MyImageSlider({required List<dynamic> images})
      : this.images = List<String>.from(images);

  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}


class _MyImageSliderState extends State<MyImageSlider> {
  int currentPage = 0; // Track the current image displayed
  bool isFavorited = false; // Track whether the item is favorited

// Initialize PageController
  final PageController pageController = PageController(initialPage: 0);

// Update current page index
  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }


  void showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: widget.images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => showImageDialog(widget.images[index]),
              child: Image.network(
                widget.images[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            padding: EdgeInsets.all(5),
            color: Colors.grey.withOpacity(0.7),
            child: Row(
              children: [
                Icon(Icons.image, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text(
                  "${currentPage + 1}/${widget.images.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.yellow : Colors.white,
              size: 44,
            ),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited;
              });
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return Container(
                margin: const EdgeInsets.all(2),
                width: currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? Colors.yellow
                      : Colors.white,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
