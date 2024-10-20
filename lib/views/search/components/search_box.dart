import 'package:flutter/material.dart';
import '../../../constants/styling.dart';

class SearchBox extends StatelessWidget {
  final String counterTextUpdator;
  final Color inputBorder;
  final TextEditingController controller;

  const SearchBox({
    super.key,
    required this.counterTextUpdator,
    required this.inputBorder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 30,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        counterText: counterTextUpdator,
        counterStyle: kBanglaFont,
        labelStyle: kBanglaFont,
        labelText: 'উপজেলা বা শহর এর আবহাওয়া',
        hintText: 'আপাতত শুধু ইংরেজি সাপোর্টেড',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: inputBorder),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.white),
        ),
      ),
    );
  }
}
