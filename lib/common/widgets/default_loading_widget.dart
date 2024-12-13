// lib/shared/widgets/loading_widget.dart

import 'package:flutter/material.dart';

class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 50, height: 50, child: CircularProgressIndicator());
  }
}
