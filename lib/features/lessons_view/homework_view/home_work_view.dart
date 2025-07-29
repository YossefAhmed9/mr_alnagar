import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mr_alnagar/features/profile_view/homework_results/home_work_results.dart';

import '../../../core/cubits/lessons_cubit/lessons_state.dart';
import '../../home_screen/home_layout.dart';
import 'homework_result.dart';

class LessonsHomeworkView extends StatefulWidget {
  final int homeworkID;

  const LessonsHomeworkView({Key? key, required this.homeworkID})
    : super(key: key);

  @override
  State<LessonsHomeworkView> createState() => _LessonsHomeworkViewState();
}

class _LessonsHomeworkViewState extends State<LessonsHomeworkView> {
  Timer? _timer;
  int remainingSeconds = 0;
  List<Map<String, dynamic>?> studentHomeWorkAnswers = [];
ScrollController scrollController=ScrollController();
  @override
  void initState() {
    super.initState();
    //LessonsCubit.get(context).startHomework(homeworkId: widget.homeworkID);

    final homework = LessonsCubit.get(context).homework;
    final durationMinutes = homework['homework']['duration_minutes'];
    print('****************************************');
    print(durationMinutes);
    final allQuestions =
        LessonsCubit.get(context).homeworkQuestions.expand((q) {
          if (q['type'] == 'reading_passage') {
            return q['questions'] ?? [];
          } else {
            return [q];
          }
        }).toList();

    studentHomeWorkAnswers =
        allQuestions.map<Map<String, dynamic>>((q) {
          return {"id": q['id'], "answer": null};
        }).toList();

    if (homework['homework']['duration_minutes'] > 0 == true) {
      setState(() {
        remainingSeconds = durationMinutes * 60;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        _submitHomework(auto: true);
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }
bool isSubmitting=false;
  Future<void> _submitHomework({bool auto = false}) async {
    if (auto) {
      setState(() => isSubmitting = true);
LessonsCubit.get(context).isLessonLoading=true;
      await LessonsCubit.get(context).submitHomework(
        attemptID: LessonsCubit.get(context).homework['attempt']['attempt_id'],
        answers: studentHomeWorkAnswers,
        context: context,
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("انتهى الوقت", textAlign: TextAlign.center),
              titleTextStyle: TextStyles.textStyle16w700(
                context,
              ).copyWith(color: AppColors.secondary),
              content: Column(
                children: [
                  Text(
                    "تم تسليم الواجب تلقائيا لانتهاء الوقت",
                    textAlign: TextAlign.center,
                    style: TextStyles.textStyle16w700(context),
                  ),
                  Text(
                    "درجتك   ${LessonsCubit.get(context).homewrokSubmission['score_text']}",
                    textAlign: TextAlign.center,
                    style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                  ),

                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.only(bottom: 12),
              actions: [
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      "ابدا الحصة",
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
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
                        CupertinoPageRoute(builder: (context) => LessonsHomeworkResultView(attemptID: LessonsCubit.get(context).homeWorkResult['attempt_id'],)),
                            (context) => false,
                      );
                    },
                    child: Text(
                      "اجابات الواجب",
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("تسليم الواجب", textAlign: TextAlign.center),
              titleTextStyle: TextStyles.textStyle16w700(
                context,
              ).copyWith(color: AppColors.secondary),
              content: Text(
                "هل تريد تأكيد اجاباتك ؟"
                    "مع العلم لديك المزيد من الوقت في التفكير",                textAlign: TextAlign.center,
                style: TextStyles.textStyle16w700(context),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
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
                      "الغاء",
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: AppColors.secondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      // print('+++++++++++++');
                      // print("SUBMITTED ANSWERS: $studentHomeWorkAnswers");

                      await LessonsCubit.get(context).submitHomework(
                        attemptID:
                            LessonsCubit.get(
                              context,
                            ).homework['attempt']['attempt_id'],
                        answers: studentHomeWorkAnswers,
                        context: context,
                      );
                      if (!mounted) return;
                      setState(() => isSubmitting = false);
                      final result = LessonsCubit.get(context).homewrokSubmission;
                      _timer?.cancel();

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text("نتيجة الامتحان ", textAlign: TextAlign.center),
                        titleTextStyle: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                        content: Container(
                          width: 150,
                          height: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/submit.png', width: 150, height: 200),
                                Column(
                                   spacing: 7,
                                children: [
                                  Text(
                                    "حليت الواجب بنجاح  ",
                                    textAlign: TextAlign.center,
                                    style: TextStyles.textStyle16w700(context),
                                  ),

                                  Text(
                                    "درجتك  ${result['score_text']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actionsPadding: const EdgeInsets.only(bottom: 12),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 44,
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () async {
                                  await LessonsCubit.get(context).getHomeWorkResult(
                                    attemptID: LessonsCubit.get(context).homework['attempt']['attempt_id'],
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(builder: (context)=>LessonsHomeworkResultView(attemptID: LessonsCubit.get(context).homework['attempt']['attempt_id'],)),
                                        (context) => false,
                                  );
                                },
                                child: Text(
                                  " عرض الاجابات ",
                                  style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 44,
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  LessonsCubit.get(context).isLessonLoading = false;
                                  // LessonsCubit.get(context).getVideosByCourse(
                                  //   id: LessonsCubit.get(context).courseResult[0]['id'],
                                  //   context: context,
                                  // );

                                  LessonsCubit.get(context).isLessonLoading = false;

                                },
                                child: Text(
                                  "ابدا الحصة",
                                  style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),);
                    },
                    child: Text(
                      "تسليم",
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
      );
    }
  }

  void updateStudentHomeWorkAnswer({
    required int questionId,
    required dynamic selectedAnswer,
  }) {
    final questionIndex = studentHomeWorkAnswers.indexWhere(
      (q) => q?['id'] == questionId,
    );
    if (questionIndex != -1) {
      studentHomeWorkAnswers[questionIndex] = {
        "id": questionId,
        "answer": selectedAnswer,
      };
    } else {
      studentHomeWorkAnswers.add({"id": questionId, "answer": selectedAnswer});
    }
    print("Updated Answers: $studentHomeWorkAnswers");
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
    final questions =
        LessonsCubit.get(
          context,
        ).homeworkQuestions.where((q) => q['type'] == type).toList();
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
              const SizedBox(height: 16),
              Text(
                HtmlUnescape()
                    .convert(question['description'] ?? '')
                    .replaceAll(RegExp(r'<[^>]*>'), ''),
                style: TextStyles.textStyle14w400(context),
              ),
              const SizedBox(height: 10),
              ...nestedQuestions.map((nestedQuestion) {
                final answers = nestedQuestion['answers'] ?? [];
                return _buildQuestionBlock(
                  questionId: nestedQuestion['id'],
                  questionText: nestedQuestion['question'],
                  options: answers,
                  isTrueFalse: false,
                  type: type,
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
              type: type,
            ),
            const SizedBox(height: 10),
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
    required String type,
  }) {
    final selectedAnswer = studentHomeWorkAnswers.firstWhere(
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
                  updateStudentHomeWorkAnswer(
                    questionId: questionId,
                    selectedAnswer: value,
                  );
                  setState(() {});
                },
              ),
            )
          else
            ListView.builder(
              itemCount: options.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, answerIndex) {
                final answer = options[answerIndex];
                final isSelected =
                    selectedAnswer != null &&
                    selectedAnswer['answer'] == answer['id'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: InkWell(
                    onTap: () {
                      updateStudentHomeWorkAnswer(
                        questionId: questionId,
                        selectedAnswer: answer['id'],
                      );
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primaryColor : Colors.white,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          answer['answer'].toString(),
                          style: TextStyles.textStyle14w700(context).copyWith(
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.primaryColor,
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
    return BlocConsumer<LessonsCubit, LessonsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final homework = LessonsCubit.get(context).homework['homework'];
        // print('****************');
        // print(homework);

        return ModalProgressHUD(
          inAsyncCall: LessonsCubit.get(context).isSubmissionLoading,

          child: Scaffold(
            appBar: AppBar(
              title: Text(
                homework?['title'] ?? 'No title added to this homework',
                style: TextStyles.textStyle16w700(context),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body:
                homework == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Scrollbar(
                        controller: scrollController,
                        interactive: true,
                        thickness: 10,
                        radius: Radius.circular(25),

                        child: Stack(
                          children: [

                            SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  if (homework?['have_duration'] == true)
                                    Container(
                                      decoration: BoxDecoration(color: Colors.white),
                                      child: Container(
                                        width: double.infinity,
                                        height: 140.h,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/pattern 2.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  radius: const Radius.circular(40),
                                                  dashPattern: [6, 4],
                                                  color: AppColors.secondary30,
                                                  strokeWidth: 2,
                                                  child: Container(
                                                    width: 240,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              MingCuteIcons.mgc_time_duration_line,
                                                              color: AppColors.secondary30,
                                                              size: 30,
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              _formatTime(remainingSeconds),
                                                              style: TextStyles.textStyle20w700(context).copyWith(fontSize: 23),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              spacing: 10,
                                              children: [Row(
                                                children: [
                                                  Text('${homework['full_score']} الدرجة  ',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black),),
                                                  Spacer(),
                                                  Text('${homework['question_count']} عدد الاسئلة  ',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black)),
                                                ],
                                              ),Row(
                                                children: [
                                                  Text('المحاولات المتبقية ${homework['remaining_attempts']}',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black)),
                                                  Spacer(),
                                                  Text('المحاولات الكلية ${homework['attempt_count']}',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black))],
                                              ),],),

                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 10),


                                  Text(
                                    'Choose the correct answer from a, b, c or d:',
                                    style: TextStyles.textStyle18w700(
                                      context,
                                    ).copyWith(color: AppColors.secondary),
                                  ),
                                  _buildQuestionTypeSection(
                                    'reading_passage',
                                    'Reading Passage Questions',
                                  ),
                                  _buildQuestionTypeSection(
                                    'multiple_choice',
                                    'Multiple Choice Questions',
                                  ),
                                  _buildQuestionTypeSection(
                                    'true_false',
                                    'True or False Questions',
                                  ),
                                  _buildQuestionTypeSection(
                                    'short_answer',
                                    'Short Answer Questions',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      width: double.infinity,
                                      height: 44,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          final firstUnansweredIndex = studentHomeWorkAnswers.indexWhere((answer) => answer?['answer'] == null);
                                          if (firstUnansweredIndex != -1) {
                                            // Scroll to the approximate position of the unanswered question
                                            scrollController.animateTo(
                                              firstUnansweredIndex * 300,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );

                                            Fluttertoast.showToast(
                                              msg: "السؤال رقم ${firstUnansweredIndex + 1} لسه من غير اجابة",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );

                                            return;
                                          }
                                          LessonsCubit.get(context).changeIsSubmissionLoading();
                                          await _submitHomework();
                                          LessonsCubit.get(context,).changeIsSubmissionLoading();
                                        },
                                        child: Text(
                                          'تسليم الواجب',
                                          style: TextStyles.textStyle16w700(
                                            context,
                                          ).copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Container(
                                width: double.infinity,
                                height: 140.h,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/pattern 2.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(40),
                                          dashPattern: [6, 4],
                                          color: AppColors.secondary30,
                                          strokeWidth: 2,
                                          child: Container(
                                            width: 240,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      MingCuteIcons.mgc_time_duration_line,
                                                      color: AppColors.secondary30,
                                                      size: 30,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      _formatTime(remainingSeconds),
                                                      style: TextStyles.textStyle20w700(context).copyWith(fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      spacing: 10,
                                      children: [Row(
                                        children: [
                                          Text('${homework['full_score']} الدرجة  ',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black),),
                                          Spacer(),
                                          Text('${homework['question_count']} عدد الاسئلة  ',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black)),
                                        ],
                                      ),Row(
                                        children: [
                                          Text('المحاولات المتبقية ${homework['remaining_attempts']}',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black)),
                                          Spacer(),
                                          Text('المحاولات الكلية ${homework['attempt_count']}',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.black))],
                                      ),],),

                                  ],
                                ),
                              ),
                            ),
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
