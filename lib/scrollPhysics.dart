import 'package:flutter/material.dart';

class CustomPageScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [PageView].
  const CustomPageScrollPhysics({super.parent});

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

  double _getPage(ScrollMetrics position) {
    // if (position is _PagePosition) {
    //   return position.page!;
    // }
    return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollMetrics position, double page) {
    // if (position is _PagePosition) {
    //   return position.getPixelsFromPage(page);
    // }
    return page * position.viewportDimension;
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);

    print('velocity: $velocity');
    if (velocity < -tolerance.velocity) {
      page -= 1.0;
    } else if (velocity > tolerance.velocity) {
      page += 1.0;
    }
    // print('page: $page');
    return _getPixels(position, page.ceilToDouble());
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      print("Super ballistics");
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
