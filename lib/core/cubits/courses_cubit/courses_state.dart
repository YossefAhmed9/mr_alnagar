abstract class CoursesState {}

final class CoursesInitial extends CoursesState {}

// Courses Fetching States
final class ChangeIsCourseDone extends CoursesState {}
final class GetCoursesByCategoryLoading extends CoursesState {}

final class GetCoursesByCategoryDone extends CoursesState {}

final class GetCoursesByCategoryError extends CoursesState {
  final dynamic error;
  GetCoursesByCategoryError(this.error);
}

final class GetVideosLoading extends CoursesState {}

final class GetVideosDone extends CoursesState {}

final class GetVideosError extends CoursesState {
  final dynamic error;
  GetVideosError(this.error);
}


final class GetQuizLoading extends CoursesState {}

final class GetQuizDone extends CoursesState {}

final class GetQuizError extends CoursesState {
  final dynamic error;
  GetQuizError(this.error);
}






final class GetHomeWorkResultLoading extends CoursesState {}

final class GetHomeWorkResultDone extends CoursesState {}

final class GetHomeWorkResultError extends CoursesState {
  final dynamic error;
  GetHomeWorkResultError(this.error);
}






final class StudentAnswerStored extends CoursesState {}
final class GetCourseLoading extends CoursesState {}

final class GetCourseDone extends CoursesState {}

final class GetCourseError extends CoursesState {
  final dynamic error;
  GetCourseError(this.error);
}

// Classes Fetching States
final class GetClassesByCoursesIDLoading extends CoursesState {}

final class GetClassesByCoursesIDDone extends CoursesState {}

final class GetClassesByCoursesIDError extends CoursesState {
  final dynamic error;
  GetClassesByCoursesIDError(this.error);
}

// Enrollment States
final class EnrollInCourseLoading extends CoursesState {}

final class EnrollInCourseDone extends CoursesState {}

final class EnrollInCourseError extends CoursesState {
  final dynamic error;
  EnrollInCourseError(this.error);
}

final class SubmitQuizLoading extends CoursesState {}

final class SubmitQuizDone extends CoursesState {}

final class SubmitQuizError extends CoursesState {
  final dynamic error;
  SubmitQuizError(this.error);
}


final class EnrollInClassLoading extends CoursesState {}

final class EnrollInClassDone extends CoursesState {}

final class EnrollInClassError extends CoursesState {
  final dynamic error;
  EnrollInClassError(this.error);
}

// Enrollment Status States
final class CheckEnrollmentStatusLoading extends CoursesState {}

final class CheckEnrollmentStatusDone extends CoursesState {}

final class CheckEnrollmentStatusError extends CoursesState {
  final dynamic error;
  CheckEnrollmentStatusError(this.error);
}

// Videos by Course States
final class GetVideosByCourseLoading extends CoursesState {}

final class GetVideosByCourseSuccess extends CoursesState {
  final dynamic videosData;
  GetVideosByCourseSuccess(this.videosData);
}

final class GetVideosByCourseError extends CoursesState {
  final String error;
  GetVideosByCourseError(this.error);
}

// Certificate States
final class GetCertificateLoading extends CoursesState {}

final class GetCertificateSuccess extends CoursesState {
  final dynamic certificateData;
  GetCertificateSuccess(this.certificateData);
}

final class GetCertificateError extends CoursesState {
  final String error;
  GetCertificateError(this.error);
}
