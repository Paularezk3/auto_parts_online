// lib/shared/widgets/loading_widget.dart

import 'package:flutter/material.dart';

class DefaultLoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const DefaultLoadingWidget({this.color, this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ?? 50,
        height: height ?? 50,
        child: CircularProgressIndicator(
          color: color,
        ));
  }
}
