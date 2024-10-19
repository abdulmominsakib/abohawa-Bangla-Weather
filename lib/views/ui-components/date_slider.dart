import 'package:flutter/material.dart';

class TrianglePageView extends StatefulWidget {
  final List<int> items;

  const TrianglePageView({Key? key, required this.items}) : super(key: key);

  @override
  _TrianglePageViewState createState() => _TrianglePageViewState();
}

class _TrianglePageViewState extends State<TrianglePageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 1,
    );
    _currentPage = 1;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length - 2,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return TriangleLayout(
            topItem: widget.items[index + 1],
            leftItem: widget.items[index],
            rightItem: widget.items[index + 2],
          );
        },
      ),
    );
  }
}

class TriangleLayout extends StatelessWidget {
  final int topItem;
  final int leftItem;
  final int rightItem;

  const TriangleLayout({
    Key? key,
    required this.topItem,
    required this.leftItem,
    required this.rightItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(child: ItemCard(item: topItem, isLarge: true)),
        ),
        Positioned(
          bottom: 20,
          left: 40,
          child: ItemCard(item: leftItem),
        ),
        Positioned(
          bottom: 20,
          right: 40,
          child: ItemCard(item: rightItem),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final int item;
  final bool isLarge;

  const ItemCard({Key? key, required this.item, this.isLarge = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: isLarge ? 120 : 80,
        height: isLarge ? 120 : 80,
        alignment: Alignment.center,
        child: Text(
          item.toString(),
          style: TextStyle(fontSize: isLarge ? 32 : 24),
        ),
      ),
    );
  }
}
