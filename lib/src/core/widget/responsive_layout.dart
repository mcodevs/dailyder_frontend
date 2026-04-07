import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    required this.medium,
    required this.large,
    super.key,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder medium;
  final WidgetBuilder large;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1120) {
      return large(context);
    }
    if (width >= 720) {
      return medium(context);
    }
    return mobile(context);
  }
}
