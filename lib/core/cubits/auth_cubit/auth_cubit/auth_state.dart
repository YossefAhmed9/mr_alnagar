import 'package:flutter/foundation.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingChanged extends AuthState {}

// OTP States
final class SendOtpLoading extends AuthState {}

final class SendOtpSuccess extends AuthState {
  final String otp;
  final int remainingSeconds;
  final String via;
  SendOtpSuccess({
    required this.otp,
    required this.remainingSeconds,
    required this.via,
  });
}

final class SendOtpError extends AuthState {
  final String error;
  SendOtpError(this.error);
}

final class VerifyOtpLoading extends AuthState {}

final class VerifyOtpSuccess extends AuthState {}

final class VerifyOtpError extends AuthState {
  final String error;
  VerifyOtpError(this.error);
}

final class ResendOtpLoading extends AuthState {}

final class ResendOtpSuccess extends AuthState {
  final String otp;
  final int remainingSeconds;
  final String via;
  ResendOtpSuccess({
    required this.otp,
    required this.remainingSeconds,
    required this.via,
  });
}

final class ResendOtpError extends AuthState {
  final String error;
  ResendOtpError(this.error);
}

// Password Update States
final class UpdatePasswordLoading extends AuthState {}

final class UpdatePasswordSuccess extends AuthState {}

final class UpdatePasswordError extends AuthState {
  final String error;
  UpdatePasswordError(this.error);
}

// Logout States
final class LogoutLoading extends AuthState {}

final class LogoutDone extends AuthState {}

final class LogoutError extends AuthState {
  final String error;
  LogoutError(this.error);
}

final class LogoutFromAllDevicesLoading extends AuthState {}

final class LogoutFromAllDevicesDone extends AuthState {}

final class LogoutFromAllDevicesError extends AuthState {
  final String error;
  LogoutFromAllDevicesError(this.error);
}

// Levels for Auth Categories
final class LevelsForAuthCategoriesLoading extends AuthState {}

final class LevelsForAuthCategoriesDone extends AuthState {}

final class LevelsForAuthCategoriesError extends AuthState {
  final dynamic error;
  LevelsForAuthCategoriesError(this.error);
}

// Governments
final class GovernmentsLoading extends AuthState {}

final class GovernmentsDone extends AuthState {}

final class GovernmentsError extends AuthState {
  final dynamic error;
  GovernmentsError(this.error);
}

// Register
final class RegisterLoading extends AuthState {}

final class RegisterDone extends AuthState {}

final class RegisterError extends AuthState {
  final dynamic error;
  RegisterError(this.error);
}

// Login
final class LoginLoading extends AuthState {}

final class LoginDone extends AuthState {}

final class LoginError extends AuthState {
  final dynamic error;
  LoginError(this.error);
}


