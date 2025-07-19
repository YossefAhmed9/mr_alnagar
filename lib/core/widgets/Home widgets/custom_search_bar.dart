import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(35)
        ),
        hintText: 'ابحث عن شئ ما...',
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: Image.asset('assets/images/search.png'),maintainHintHeight: true

      ),
    );
  }
}
