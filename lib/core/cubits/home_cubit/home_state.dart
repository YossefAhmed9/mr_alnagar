part of 'home_cubit.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class ChangeNavBarIndex extends HomeState {}

final class ChangeTabBarIndex extends HomeState {}

final class POSTAskUsLoading extends HomeState {}

final class POSTAskUsDone extends HomeState {}

final class POSTAskUsError extends HomeState {
  final error;
  POSTAskUsError(this.error);
}

final class GETAskUsLoading extends HomeState {}

final class GETAskUsDone extends HomeState {}

final class GETAskUsError extends HomeState {
  final error;
  GETAskUsError(this.error);
}

final class GetAboutUsDataLoading extends HomeState {}

final class GetAboutUsDataDone extends HomeState {}

final class GetAboutUsDataError extends HomeState {
  final error;
  GetAboutUsDataError(this.error);
}


final class GETHomeDataLoading extends HomeState {}

final class GETHomeDataDone extends HomeState {}

final class GETHomeDataError extends HomeState {
  final error;
  GETHomeDataError(this.error);
}

final class GETLeaderBoardLoading extends HomeState {}

final class GETLeaderBoardDone extends HomeState {}

final class GETLeaderBoardError extends HomeState {
  final error;
  GETLeaderBoardError(this.error);
}
