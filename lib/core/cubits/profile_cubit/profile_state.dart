part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
final class ProfilePrivacyPolicyLoading extends ProfileState {}
final class ProfilePrivacyPolicyDone extends ProfileState {}
final class ProfilePrivacyPolicyError extends ProfileState {
  final error;
  ProfilePrivacyPolicyError(
      this.error
      );
}

final class ProfileViewChanged extends ProfileState {}

// Profile Info States
final class ProfileInfoLoading extends ProfileState {}

final class ProfileInfoDone extends ProfileState {}

final class ProfileInfoError extends ProfileState {
  final String error;
  ProfileInfoError(this.error);
}

// OTP States
final class SendOtpLoading extends ProfileState {}

final class SendOtpSuccess extends ProfileState {
  final String otp;
  final int remainingSeconds;
  final String via;
  SendOtpSuccess({
    required this.otp,
    required this.remainingSeconds,
    required this.via,
  });
}

final class SendOtpError extends ProfileState {
  final String error;
  SendOtpError(this.error);
}




final class VerifyOtpLoading extends ProfileState {}

final class VerifyOtpSuccess extends ProfileState {}

final class VerifyOtpError extends ProfileState {
  final String error;
  VerifyOtpError(this.error);
}

final class ResendOtpLoading extends ProfileState {}

final class ResendOtpSuccess extends ProfileState {
  final String otp;
  final int remainingSeconds;
  final String via;
  ResendOtpSuccess({
    required this.otp,
    required this.remainingSeconds,
    required this.via,
  });
}

final class ResendOtpError extends ProfileState {
  final String error;
  ResendOtpError(this.error);
}



// Update Profile Info States
final class UpdateProfileInfoLoading extends ProfileState {}

final class UpdateProfileInfoDone extends ProfileState {}

final class UpdateProfileInfoError extends ProfileState {
  final String error;
  UpdateProfileInfoError(this.error);
}

// Logout States
final class LogoutLoading extends ProfileState {}

final class LogoutDone extends ProfileState {}

final class LogoutError extends ProfileState {
  final String error;
  LogoutError(this.error);
}

final class LogoutFromAllDevicesLoading extends ProfileState {}

final class LogoutFromAllDevicesDone extends ProfileState {}

final class LogoutFromAllDevicesError extends ProfileState {
  final String error;
  LogoutFromAllDevicesError(this.error);
}

// Stats States
final class StatsLoading extends ProfileState {}

final class StatsFetched extends ProfileState {}

final class StatsError extends ProfileState {
  final String error;
  StatsError(this.error);
}

class registerImageChoose extends ProfileState {}

final class EnableChanges extends ProfileState {}

// Quiz Results States
final class QuizResultsLoading extends ProfileState {}

final class QuizResultsSuccess extends ProfileState {
  final List<QuizResultModel> quizResults;
  QuizResultsSuccess(this.quizResults);
}

final class QuizResultsError extends ProfileState {
  final String error;
  QuizResultsError(this.error);
}

final class GetMyCoursesLoading extends ProfileState {}

final class GetMyCoursesDone extends ProfileState {}

final class GetMyCoursesError extends ProfileState {
  final error;
  GetMyCoursesError(this.error);
}

final class GetMyCompletedCoursesLoading extends ProfileState {}

final class GetMyCompletedCoursesDone extends ProfileState {}

final class GetMyCompletedCoursesError extends ProfileState {
  final error;
  GetMyCompletedCoursesError(this.error);
}


final class UpdateProfilePasswordLoading extends ProfileState{}
final class UpdateProfilePasswordSuccess extends ProfileState{}
final class UpdateProfilePasswordError extends ProfileState{
  final error;
  UpdateProfilePasswordError(
      this.error
      );
}
