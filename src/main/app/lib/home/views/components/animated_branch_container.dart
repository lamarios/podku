import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku/home/states/home.dart';

/// Navigator container for the home [StatefulShellRoute] that animates between branches.
///
/// All branches are kept alive (like an indexed stack) and slide side by side like a [TabBarView], in the order of the
/// navigation bar / rail, along [axis] (horizontal for the navigation bar, vertical for the navigation rail).
///
/// Each branch rests at -1 (before the current branch), 0 (current branch) or 1 (after the current branch). Only the
/// current branch and the one we're leaving ([HomeState.previousIndex]) animate, the others jump straight to their
/// resting position so they are always ready to slide in from the right side.
class AnimatedBranchContainer extends StatelessWidget {
  final int currentIndex;
  final List<Widget> children;
  final Axis axis;

  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
    this.axis = .horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final previousIndex = context.select((HomeCubit c) => c.state.previousIndex);

    // clipped so the branches don't slide over the navigation rail
    return ClipRect(
      child: Stack(
        fit: .expand,
        children: [
          for (var i = 0; i < children.length; i++)
            SingleMotionBuilder(
              key: ValueKey(i),
              // non expressive spring, a bounce would show a gap at the edge of a full page slide
              motion: const MaterialSpringMotion.expressiveSpatialDefault(snapToEnd: true),
              value: (i - currentIndex).sign.toDouble(),
              active: i == currentIndex || i == previousIndex,
              child: children[i],
              builder: (context, value, child) {
                // fully slid out, no need to paint or tick
                final hidden = value.abs() >= 1;
                return Offstage(
                  offstage: hidden,
                  child: TickerMode(
                    enabled: !hidden,
                    child: IgnorePointer(
                      ignoring: i != currentIndex,
                      child: FractionalTranslation(
                        translation: axis == .horizontal ? Offset(value, 0) : Offset(0, value),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
