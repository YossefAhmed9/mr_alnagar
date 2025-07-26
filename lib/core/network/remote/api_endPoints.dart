abstract class EndPoints {
  static String courses_by_category = 'courses_by_category';
  static String courses = 'courses';
  static String privacyPolicy = 'privacy_policy';
  static String aboutUs = 'about_us';

  static String levelsForAuthCategories = 'categories';
  static String home = 'home';
  static String governments = 'governments';
  static String register = 'register';
  static String login = 'login';
  static String AskUs = 'Ask_us';
  static String getAllBooks = 'books';
  static String getCourseByID = 'courses_by_id';
  static String getClassesByCoursesID = 'classes_by_courses_id';
  static String orderBooks = 'books/order';
  static String sendOtp = 'send-otp';
  static String verifyOtp = 'verify-otp';
  static String resendOtp = 'resend-otp';
  static String resetPassword = 'change-password';

  static String enrollClass = 'enroll-class';
  static String enrollCourse = 'enroll-course';

  static String homeworkStart = 'homeworks';
  static String studentHomework = 'student-homeworks';

  static String leaderBoard = 'heroes/by-category';

  static String classById = 'class_by_id';
  static String quizById = 'quiz_by_id';
  static String startQuiz = 'quizzes';
  static String submitQuiz = 'student-quizzes';
  static String resultQuiz = 'student-quizzes';
  // static String watchVideo = 'watch_video';
  static String videosByCourse = 'videos_by_course';
  static String videosByClass = 'videos_by_classes';
  static String videos = 'videos';

  static String myCourses='my-courses';
  static String startHomework = 'homeworks';
  static String submitHomework = 'student-homeworks';
  static String resultHomework = 'student-homeworks';
  static String homeWorksResultsForProfile = 'homework-results';
  static String videosByClasses = 'videos_by_classes';
  static String certificate = 'certificate';
  static String enrollmentStatus = 'enrollment-status';

  // Profile-related endpoints
  static String profileInfo = 'profile-info';
  static String updateProfileInfo = 'update-profile-info';
  static String updatePassword = 'update-pass';

  // Logout endpoints
  static String logout = 'logout';
  static String logoutFromAllDevices = 'logout-all';

  // Additional profile-related endpoints
  static String quizzesResults = 'quizzes-results';
  static String studentQuizes = 'student-quizzes';
  static String homeworkResults = 'homework-results';
  static String stats = 'stats';

  // OTP Endpoints
  static String otpSend = 'send-otp';
  static String otpVerify = 'verify-otp';
  static String otpResend = 'resend-otp';

  // Password Update Endpoint
  static String updateProfilePassword = 'update-profile-password';
}
