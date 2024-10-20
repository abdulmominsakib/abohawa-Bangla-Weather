import 'package:flutter/material.dart';
import '../../../constants/styling.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text('সার্চ', style: kBanglaFont.copyWith(color: Colors.black)),
    );
  }
}
