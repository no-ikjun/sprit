import 'package:flutter/material.dart';

class BookThumbnail extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  const BookThumbnail({
    super.key,
    required this.imgUrl,
    this.width = 90,
    this.height = 130,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            width: 1.5,
          ),
          boxShadow: List.generate(
            1,
            (index) => BoxShadow(
              color: const Color(0x0D000000).withOpacity(0.1),
              offset: const Offset(1, 2),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.5),
          child: Image.network(
            imgUrl,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
