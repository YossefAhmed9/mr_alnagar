import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/videos_view/videos_view.dart';

class ReservationStepsListView extends StatefulWidget {
  const ReservationStepsListView({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  State<ReservationStepsListView> createState() => _ReservationStepsListViewState();
}

class _ReservationStepsListViewState extends State<ReservationStepsListView> {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;

  void scrollToIndex(int index) {
    final double itemWidth = 290.w + 16;
    scrollController.animateTo(
      itemWidth * index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
    );
    setState(() {
      currentIndex = index;
    });
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.lightBlue,
          contentPadding: const EdgeInsets.all(20),
          content: ModalProgressHUD(
            inAsyncCall: CoursesCubit.get(context).isCourseLoading,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "تم الإشتراك بنجاح",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1, color: Colors.white),
                const SizedBox(height: 10),
                Image.asset('assets/images/Group.png', height: 180, fit: BoxFit.contain),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      CoursesCubit.get(context).changeIsCourseLoading();
                      await CoursesCubit.get(context).getVideosByCourse(id: CoursesCubit.get(context).courseResult[0]['id'], context: context);
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => CourseVideoScreen(videoIndex: CoursesCubit.get(context).courseResult[0]['id'])));


                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: CoursesCubit.get(context).isCourseLoading ? Center(child: CircularProgressIndicator(),)
                  : Text("ابدأ يلا", style: TextStyle(fontSize: 16, color: Colors.white)
                  ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildPaymentCards() {
    final paymentType = widget.data['payment_type'];
    final isEnrolled = widget.data['is_enrolled'] == true;

    List<Widget> cards = [];

    if (isEnrolled) {
      if (paymentType == 'pay_in_center') {
        cards.add(buildPayInCenterCard());
      } else if (paymentType == 'contact_with_support') {
        cards.add(buildSupportCard());
      } else if (paymentType == 'wallet_transfer') {
        cards.add(buildWalletCard());
      }
    } else {
      if (paymentType == null || paymentType == 'pay_in_center') {
        cards.add(buildPayInCenterCard());
      }
      if (paymentType == null || paymentType == 'contact_with_support') {
        cards.add(buildSupportCard());
      }
      if (paymentType == null || paymentType == 'wallet_transfer') {
        cards.add(buildWalletCard());
      }
    }

    return cards;
  }

  Widget buildPayInCenterCard() {
    return buildCard(
      title: 'ادفع في السنتر',
      price: widget.data['price'],
      description: 'تقدر تدفع مباشرة في السنتر وتشترك على طول.',
      extra: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(FluentIcons.location_20_filled, color: Colors.grey.shade400),
            title: Text('العنوان: شارع التليفونات', style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.primaryColor)),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.access_time_filled, color: Colors.grey.shade400),
            title: Text('المواعيد: من الساعة 3م إلى 9م – كل يوم', style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.primaryColor)),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text('بعد ما تدفع عن طريق السنتر، دوس على زر "تم الدفع" علشان نقدر نراجع الدفع ونفعل اشتراكك بسرعة.',
            style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
      buttonText: 'طلب اشتراك',
      onPressed: () => _handleButtonPress('pay_in_center'),
    );
  }

  Widget buildSupportCard() {
    return buildCard(
      title: 'طلب اشتراك',
      price: widget.data['price'],
      description: 'اضغط على "طلب اشتراك"، وفريق الدعم هيتواصل معاك ويوجهك خطوة بخطوة.',
      buttonText: 'طلب اشتراك',
      onPressed: () => _handleButtonPress('contact_with_support'),
    );
  }

  Widget buildWalletCard() {
    return buildCard(
      title: 'فودافون كاش',
      price: widget.data['price'],
      description: 'وبعد التحويل، ابعت صورة الإيصال على واتساب لنفس الرقم.',
      extra: Column(
        children: [
          Text('حول على الرقم: ${CoursesCubit.get(context).courseResult[0]['phone']}',
            style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.primaryColor),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text('بعد ما تدفع عن طريق فودافون كاش وتبعت صورة الإيصال، دوس على زر "تم الدفع" علشان نراجع الدفع ونفعل اشتراكك.',
            style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
      buttonText: 'طلب اشتراك',
      onPressed: () => _handleButtonPress('wallet_transfer'),
    );
  }

  void _handleButtonPress(String method) async {
    final String status = widget.data['request_status']?['key'] ??
        (widget.data['is_enrolled'] == true ? 'approved' : widget.data['status'] ?? '');

    if (status == 'approved') {
      _showSubscriptionDialog(context);
    } else if (status == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('طلبك قيد المراجعة حالياً')));
    } else if (status == 'refused') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('طلبك مرفوض، تواصل مع الدعم')));
    } else {
      CoursesCubit.get(context).enrollInCourse(courseID: widget.data['id'], paymentType: method);
      setState(() {
        widget.data['status'] = 'pending';
        widget.data['payment_type'] = method;
      });
    }
  }

  Widget buildCard({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required dynamic price,
    Widget? extra,
  }) {
    final String status = widget.data['request_status']?['key'] ??
        (widget.data['is_enrolled'] == true ? 'approved' : widget.data['status'] ?? '');

    Color buttonColor;
    Color textColor;
    String buttonLabel;

    if (status == 'pending') {
      buttonColor = Colors.yellow.shade600;
      textColor = Colors.black;
      buttonLabel = 'قيد الانتظار';
    } else if (status == 'refused') {
      buttonColor = Colors.red;
      textColor = Colors.white;
      buttonLabel = 'مرفوض';
    } else if (status == 'approved') {
      buttonColor = AppColors.primaryColor;
      textColor = Colors.white;
      buttonLabel = 'ابدا الان';
    } else {
      buttonColor = AppColors.primaryColor;
      textColor = Colors.white;
      buttonLabel = buttonText;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 330,
        height: 370.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(title, style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary30))),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('مش عارف تدفع دلوقتي؟'),
                const Spacer(),
                Text('$price جنيه', style: TextStyles.textStyle20w700(context).copyWith(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 6),
            Text(description, style: TextStyles.textStyle16w400(context).copyWith(color: Colors.red)),
            const SizedBox(height: 8),
            if (extra != null) extra,
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: double.infinity,
                height: 44,
                child: MaterialButton(
                  onPressed: (status == 'pending' || status == 'refused') ? null : onPressed,
                  child: Text(buttonLabel, style: TextStyles.textStyle16w700(context).copyWith(color: textColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cards = buildPaymentCards();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: [
              Text('للحجز والاستعلام', style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor)),
              SizedBox(height: 10.h),
              Container(
                height: 480,
                child: Center(
                  child: ListView(
                    controller: scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: cards,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (cards.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                        onPressed: currentIndex > 0 ? () => scrollToIndex(currentIndex - 1) : null,
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: IconButton(
                        onPressed: currentIndex < cards.length - 1 ? () => scrollToIndex(currentIndex + 1) : null,
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
