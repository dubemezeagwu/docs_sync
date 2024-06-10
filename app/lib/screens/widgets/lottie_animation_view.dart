import 'package:docs_sync/screens/app_screens.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool reverse;
  final bool repeat;

  const LottieAnimationView(
      {super.key,
      required this.animation,
      this.reverse = false,
      this.repeat = true});

  @override
  Widget build(BuildContext context) =>
      Lottie.asset(animation.fullPath, repeat: repeat, reverse: reverse);
}

class EmptyContentsAnimationView extends LottieAnimationView {
  const EmptyContentsAnimationView({super.key})
      : super(animation: LottieAnimation.empty);
}

class LoadingContentsAnimationView extends LottieAnimationView {
  const LoadingContentsAnimationView({super.key})
      : super(animation: LottieAnimation.loading);
}

class ErrorContentsAnimationView extends LottieAnimationView {
  const ErrorContentsAnimationView({super.key})
      : super(animation: LottieAnimation.error);
}
