import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.location,
    required this.height,
  });

  final String location;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height / 15,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Colors.white, size: height / 25),
          SizedBox(width: 5),
          Text(
            location,
            style: kHeaderTitle.copyWith(fontSize: height / 22),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
