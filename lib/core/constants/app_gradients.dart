// lib\core\constants\app_gradients.dart

import 'package:flutter/material.dart';

class AppGradients {
  static const linearPrimarySecondary = LinearGradient(
    colors: [Color(0xFFC18B2F), Color(0xFF020024)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const linearPrimaryAccent = LinearGradient(
    colors: [Color(0xFFC18B2F), Color(0xFFD95100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const radialPrimarySecondary = RadialGradient(
    colors: [Color(0xFFC18B2F), Color(0xFF020024)],
    center: Alignment.center,
    radius: 0.8,
  );
}
