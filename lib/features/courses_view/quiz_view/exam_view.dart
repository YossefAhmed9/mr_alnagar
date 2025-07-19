import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/features/courses_view/quiz_view/quiz_result.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';

class ExamView extends StatefulWidget {
  const ExamView({Key? key, required this.quizID}) : super(key: key);
  final int quizID;

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  Timer? _timer;
  int remainingSeconds = 0;
  List<Map<String, dynamic>?> studentQuizAnswers = [];
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final quizData = CoursesCubit.get(context).quiz;
    final durationMinutes = quizData?['quiz']?['duration_minutes'] ?? 0;

    final allQuestions = CoursesCubit.get(context).quizQuestions.expand((q) {
      if (q['type'] == 'reading_passage') {
        return q['questions'] ?? [];
      } else {
        return [q];
      }
    }).toList();

    studentQuizAnswers = allQuestions.map<Map<String, dynamic>>((q) {
      return {"id": q['id'], "answer": null};
    }).toList();

    if (durationMinutes > 0) {
      remainingSeconds = durationMinutes * 60;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        _submitExam(auto: true);
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void _submitExam({bool auto = false}) async {
    if (auto) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Time's up!",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: TextStyles.textStyle16w700(context)
              .copyWith(color: AppColors.secondary),
          content: Text(
            "Your exam has been automatically submitted.",
            textAlign: TextAlign.center,
            style: TextStyles.textStyle16w700(context),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 12),
          actions: [
            SizedBox(
              height: 44,
              width: 120,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeLayout()),
                        (context) => false,
                  );
                },
                child: Text(
                  "OK",
                  style: TextStyles.textStyle16w700(context)
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Submit Exam",
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyles.textStyle16w700(context)
            .copyWith(color: AppColors.secondary),
        content: Text(
          "Are you sure you want to submit your exam?",
          textAlign: TextAlign.center,
          style: TextStyles.textStyle16w700(context),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        actions: [
          SizedBox(
            height: 44,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyles.textStyle16w700(context)
                    .copyWith(color: AppColors.secondary),
              ),
            ),
          ),
          SizedBox(width: 12),
          SizedBox(
            height: 44,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => isSubmitting = true);

                final value = await CoursesCubit.get(context).submitQuiz(
                  attemptID: CoursesCubit.get(context).quiz['attempt']['attempt_id'],
                  answers: studentQuizAnswers,
                );

                CoursesCubit.get(context).quizSubmission;
                setState(() => isSubmitting = false);

                final result = CoursesCubit.get(context).quizSubmission;

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Result",
                      textAlign: TextAlign.center,
                    ),
                    titleTextStyle: TextStyles.textStyle16w700(context)
                        .copyWith(color: AppColors.secondary),
                    content: Text(
                      "Your Score: ${result['score_text']}",
                      textAlign: TextAlign.center,
                      style: TextStyles.textStyle16w700(context),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: const EdgeInsets.only(bottom: 12),
                    actions: [
                      SizedBox(
                        height: 44,
                        width: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                           await CoursesCubit.get(context).getQuizResult(attemptID:CoursesCubit.get(context).quiz['attempt']['attempt_id'] );
                            Navigator.pushAndRemoveUntil(context,
                                CupertinoPageRoute(builder: (context)=>QuizResultView()),
                                (context)=>false
                            );
                          },
                          child: Text(
                            "عرض الأسئلة المحلولة",
                            style: TextStyles.textStyle16w700(context)
                                .copyWith(color: AppColors.secondary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 44,
                        width: 100,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HomeLayout(),
                              ),
                                  (context) => false,
                            );
                          },
                          child: Text(
                            "OK",
                            style: TextStyles.textStyle16w700(context)
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

              },
              child: Text(
                "Submit",
                style: TextStyles.textStyle16w700(context)
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

  }

  void updateStudentQuizAnswer({
    required int questionId,
    required dynamic selectedAnswer,
  }) {
    final index = studentQuizAnswers.indexWhere((q) => q?['id'] == questionId);
    if (index != -1) {
      studentQuizAnswers[index] = {
        "id": questionId,
        "answer": selectedAnswer,
      };
    } else {
      studentQuizAnswers.add({
        "id": questionId,
        "answer": selectedAnswer,
      });
    }
    setState(() {});
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours : $minutes : $secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildQuestionTypeSection(String type, String title) {
    final questions = CoursesCubit.get(context).quizQuestions.where((q) => q['type'] == type).toList();
    if (questions.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.textStyle18w700(context)),
        const SizedBox(height: 10),
        ...questions.asMap().entries.expand((entry) {
          final question = entry.value;
          final type = question['type'];

          if (type == 'reading_passage') {
            final List nestedQuestions = question['questions'] ?? [];
            return [
              //const SizedBox(height: 16),
              Text(
                HtmlUnescape().convert(question['description'] ?? 'asdasda').replaceAll(RegExp(r'<[^>]*>'), ''),
                style: TextStyles.textStyle16w400(context).copyWith(color: Colors.black,),maxLines: 50,
              ),
              const SizedBox(height: 10),
              ...nestedQuestions.map((nestedQuestion) {
                final answers = nestedQuestion['answers'] ?? [];
                return _buildQuestionBlock(
                  questionId: nestedQuestion['id'],
                  questionText: nestedQuestion['question'],
                  options: answers,
                  isTrueFalse: false,
                );
              }),
            ];
          }

          final answers = question['answers'] ?? [];
          final bool isTrueFalse = type == 'true_false';
          final List options = answers;


          return [
            _buildQuestionBlock(
              questionId: question['id'],
              questionText: question['question'],
              options: options,
              isTrueFalse: isTrueFalse,
            ),
            if (type == 'short_answer')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Your answer',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    updateStudentQuizAnswer(questionId: question['id'], selectedAnswer: value);
                    print(studentQuizAnswers);
                  },
                ),
              ),
          ];
        }),
      ],
    );
  }

  Widget _buildQuestionBlock({
    required int questionId,
    required String? questionText,
    required List options,
    required bool isTrueFalse,
  }) {
    final selectedAnswer = studentQuizAnswers.firstWhere(
          (entry) => entry != null && entry['id'] == questionId,
      orElse: () => {"id": questionId, "answer": null},
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(questionText ?? '', style: TextStyles.textStyle16w700(context)),
          const SizedBox(height: 8),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3.4,
              crossAxisCount: 1,
            ),
            itemCount: options.length,
            itemBuilder: (context, answerIndex) {
              final answer = options[answerIndex];
              final isSelected = selectedAnswer?['answer'] == answer['id'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    final selectedValue = answer['id'];
                    updateStudentQuizAnswer(
                      questionId: questionId,
                      selectedAnswer: selectedValue,
                    );
                    print(studentQuizAnswers);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : Colors.white,
                      border: Border.all(color: AppColors.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          answer['answer'].toString(),
                          style: TextStyles.textStyle14w700(context).copyWith(
                            color: isSelected ? Colors.white : AppColors.primaryColor,
                          ),
                          maxLines: 5,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final quizData = CoursesCubit.get(context).quiz;

        return ModalProgressHUD(
          inAsyncCall: isSubmitting,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                quizData?['quiz']?['title'] ?? '',
                style: TextStyles.textStyle16w700(context),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: quizData == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 300.w,
                      height: 140.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/pattern 2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(40),
                          dashPattern: [6, 4],
                          color: AppColors.secondary30,
                          strokeWidth: 2,
                          child: Container(
                            width: 270,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MingCuteIcons.mgc_time_duration_line,
                                  color: AppColors.secondary30,
                                  size: 40,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatTime(remainingSeconds),
                                  style: TextStyles.textStyle20w700(context).copyWith(fontSize: 32),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Choose the correct answer from a, b, c or d:',
                      style: TextStyles.textStyle18w700(context).copyWith(color: AppColors.secondary),
                    ),
                    _buildQuestionTypeSection('reading_passage', 'Reading Passage Questions'),
                    _buildQuestionTypeSection('multiple_choice', 'Multiple Choice Questions'),
                    _buildQuestionTypeSection('true_false', 'True or False Questions'),
                    _buildQuestionTypeSection('short_answer', 'Short Answer Questions'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        width: double.infinity,
                        height: 44,
                        child: MaterialButton(
                          onPressed: () => _submitExam(),
                          child: Text(
                            'Next',
                            style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
