import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StarRowWidget extends StatelessWidget {
  final double star;
  final double gap;
  final double size;

  const StarRowWidget({
    super.key,
    required this.star,
    this.gap = 3,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          star >= 0.5
              ? 'assets/images/star_yellow.svg'
              : 'assets/images/star_grey.svg',
          width: size,
        ),
        SizedBox(
          width: gap,
        ),
        SvgPicture.asset(
          star >= 1.5
              ? 'assets/images/star_yellow.svg'
              : 'assets/images/star_grey.svg',
          width: size,
        ),
        SizedBox(
          width: gap,
        ),
        SvgPicture.asset(
          star >= 2.5
              ? 'assets/images/star_yellow.svg'
              : 'assets/images/star_grey.svg',
          width: size,
        ),
        SizedBox(
          width: gap,
        ),
        SvgPicture.asset(
          star >= 3.5
              ? 'assets/images/star_yellow.svg'
              : 'assets/images/star_grey.svg',
          width: size,
        ),
        SizedBox(
          width: gap,
        ),
        SvgPicture.asset(
          star >= 4.5
              ? 'assets/images/star_yellow.svg'
              : 'assets/images/star_grey.svg',
          width: size,
        ),
      ],
    );
  }
}
