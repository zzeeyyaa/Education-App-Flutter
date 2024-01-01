part of 'on_boarding_cubit.dart';

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

//initial
final class OnBoardingInitial extends OnBoardingState {
  const OnBoardingInitial();
}

//pas lagi dilakuin
class CachingFirstTimer extends OnBoardingState {
  const CachingFirstTimer();
}

class CheckingIfUserIsFirstTimer extends OnBoardingState {
  const CheckingIfUserIsFirstTimer();
}

//pas udh dilakuin
class UserCached extends OnBoardingState {
  const UserCached();
}

class OnBoardingStatus extends OnBoardingState {
  const OnBoardingStatus({required this.isFirstTimer});

  final bool isFirstTimer;

  @override
  List<bool> get props => [isFirstTimer];
}

//pas error
class OnBoardingError extends OnBoardingState {
  const OnBoardingError(this.message);
  final String message;

  @override
  List<String> get props => [message];
}
