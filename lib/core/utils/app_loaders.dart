import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class AppLoaderInkDrop extends StatelessWidget {
  final double size;
  final Color color;

  const AppLoaderInkDrop({
    super.key,
    this.size = 50.0,
    this.color = const Color(0xFF1A1A3F),
  });

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.inkDrop(
      color: color,
      size: size,
    );
  }
}
class AppLoaderHourglass extends StatelessWidget {
  final double size;
  final Color color;

  const AppLoaderHourglass({
    super.key,
    this.size = 50.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitPouringHourGlassRefined(
      color: color,
      size: size,
    );
  }
}

