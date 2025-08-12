abstract class LessonsState {}

final class LessonsInitial extends LessonsState {}

final class ChangeIsCourseDone extends LessonsState {}


final class IsOneTimeLessonShowAll extends LessonsState {}

// Tab Bar State
final class ChangeTabBarIndex extends LessonsState {}

final class ChangeIsLessonDone extends LessonsState {}

final class EnrollInLessonLoading extends LessonsState {}

final class EnrollInLessonDone extends LessonsState {}

final class EnrollInLessonError extends LessonsState {
  final dynamic error;
  EnrollInLessonError(this.error);
}

final class GetLessonsListForOneTimeClassesLoading extends LessonsState {}

final class GetLessonsListForOneTimeClassesDone extends LessonsState {}

final class GetLessonsListForOneTimeClassesError extends LessonsState {
  final dynamic error;
  GetLessonsListForOneTimeClassesError(this.error);
}



final class GetUserLessonsLoading extends LessonsState {}

final class GetUserLessonsDone extends LessonsState {}

final class GetUserLessonsError extends LessonsState {
  final dynamic error;
  GetUserLessonsError(this.error);
}

final class GetAllOneTimeLessonsLoading extends LessonsState {}

final class GetAllOneTimeLessonsDone extends LessonsState {}

final class GetAllOneTimeLessonsError extends LessonsState {
  final dynamic error;
  GetAllOneTimeLessonsError(this.error);
}

final class GetOneTimeLessonVideosWithCodeLoading extends LessonsState {}

final class GetOneTimeLessonVideosWithCodeDone extends LessonsState {}

final class GetOneTimeLessonVideosWithCodeError extends LessonsState {
  final dynamic error;
  GetOneTimeLessonVideosWithCodeError(this.error);
}





final class OneTimeLessonAccessClassLoading extends LessonsState {}

final class OneTimeLessonAccessClassDone extends LessonsState {}

final class OneTimeLessonAccessClassError extends LessonsState {
  final dynamic error;
  OneTimeLessonAccessClassError(this.error);
}

final class GetClassDataByIDLoading extends LessonsState {}

final class GetClassDataByIDDone extends LessonsState {}

final class GetClassDataByIDError extends LessonsState {
  final dynamic error;
  GetClassDataByIDError(this.error);
}

final class GetVideosByClassesWithCodeLoading extends LessonsState {}

final class GetVideosByClassesWithCodeDone extends LessonsState {}

final class GetVideosByClassesWithCodeError extends LessonsState {
  final dynamic error;
  GetVideosByClassesWithCodeError(this.error);
}


final class HomeWorkSubmissionLoading extends LessonsState {}

final class HomeWorkSubmissionDone extends LessonsState {}

final class HomeWorkSubmissionError extends LessonsState {
  final dynamic error;
  HomeWorkSubmissionError(this.error);
}

final class GetVideosByCourseLoading extends LessonsState {}

final class GetVideosByCourseSuccess extends LessonsState {
  final dynamic videosData;
  GetVideosByCourseSuccess(this.videosData);
}

final class GetVideosByCourseError extends LessonsState {
  final String error;
  GetVideosByCourseError(this.error);
}

final class GetVideosLoading extends LessonsState {}

final class GetVideosDone extends LessonsState {}

final class GetVideosError extends LessonsState {
  final dynamic error;
  GetVideosError(this.error);
}

// Classes States
final class ClassesLoading extends LessonsState {}

final class ClassesFetched extends LessonsState {}

final class ClassesError extends LessonsState {
  final String error;
  ClassesError(this.error);
}

// Courses States
final class CoursesLoading extends LessonsState {}

final class CoursesFetched extends LessonsState {
  final List courses;
  CoursesFetched(this.courses);
}

final class CoursesError extends LessonsState {
  final String error;
  CoursesError(this.error);
}

final class CoursesEmpty extends LessonsState {}

// Videos States
final class VideosLoading extends LessonsState {}

final class VideosFetched extends LessonsState {}

final class VideosError extends LessonsState {
  final String error;
  VideosError(this.error);
}

// Homework States
final class HomeworkResultsLoading extends LessonsState {}

final class HomeworkResultsFetched extends LessonsState {}

final class HomeworkResultsError extends LessonsState {
  final String error;
  HomeworkResultsError(this.error);
}

final class SubmitQuizLoading extends LessonsState {}

final class SubmitQuizDone extends LessonsState {}

final class SubmitQuizError extends LessonsState {
  final dynamic error;
  SubmitQuizError(this.error);
}

// New Class-Related States
final class ClassByIdLoading extends LessonsState {}

final class ClassByIdFetched extends LessonsState {
  final dynamic classData;
  ClassByIdFetched(this.classData);
}

final class ClassByIdError extends LessonsState {
  final String error;
  ClassByIdError(this.error);
}

// Quiz-Related States
final class QuizByIdLoading extends LessonsState {}

final class QuizByIdFetched extends LessonsState {
  final dynamic quizData;
  QuizByIdFetched(this.quizData);
}

final class QuizByIdError extends LessonsState {
  final String error;
  QuizByIdError(this.error);
}

final class StartQuizLoading extends LessonsState {}

final class StartQuizFetched extends LessonsState {
  final dynamic quizStartData;
  StartQuizFetched(this.quizStartData);
}

final class StartQuizError extends LessonsState {
  final String error;
  StartQuizError(this.error);
}

final class GetQuizLoading extends LessonsState {}

final class GetQuizDone extends LessonsState {}

final class GetQuizError extends LessonsState {
  final dynamic error;
  GetQuizError(this.error);
}

final class StudentAnswerStored extends LessonsState {}

final class GetCourseLoading extends LessonsState {}

final class GetCourseDone extends LessonsState {}

final class GetCourseError extends LessonsState {
  final dynamic error;
  GetCourseError(this.error);
}

final class GetHomeWorkResultLoading extends LessonsState {}

final class GetHomeWorkResultDone extends LessonsState {}

final class GetHomeWorkResultError extends LessonsState {
  final dynamic error;
  GetHomeWorkResultError(this.error);
}

final class QuizResultLoading extends LessonsState {}

final class QuizResultFetched extends LessonsState {
  final dynamic quizResultData;
  QuizResultFetched(this.quizResultData);
}

final class QuizResultError extends LessonsState {
  final String error;
  QuizResultError(this.error);
}

// Watch Video States
final class WatchVideoLoading extends LessonsState {}

final class WatchVideoDone extends LessonsState {
  final dynamic watchVideoData;
  WatchVideoDone(this.watchVideoData);
}

final class WatchVideoError extends LessonsState {
  final String error;
  WatchVideoError(this.error);
}

// Enrollment Status States
final class EnrollmentStatusLoading extends LessonsState {}

final class EnrollmentStatusDone extends LessonsState {
  final dynamic enrollmentStatusData;
  EnrollmentStatusDone(this.enrollmentStatusData);
}

final class EnrollmentStatusError extends LessonsState {
  final String error;
  EnrollmentStatusError(this.error);
}

class LessonsLoaded extends LessonsState {
  final List subscribedLessons;
  final List allLessons;
  LessonsLoaded({
    this.subscribedLessons = const [],
    this.allLessons = const [],
  });
}

class LessonsEmpty extends LessonsState {}

class LessonsError extends LessonsState {
  final String message;
  LessonsError(this.message);
}
