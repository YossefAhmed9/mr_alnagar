import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import '../../../core/utils/app_loaders.dart';

class BookReservationStepsListView extends StatefulWidget {
  const BookReservationStepsListView({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  State<BookReservationStepsListView> createState() => _BookReservationStepsListViewState();
}

class _BookReservationStepsListViewState extends State<BookReservationStepsListView> {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
TextEditingController quantityController=TextEditingController();
TextEditingController addressController=TextEditingController();


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

  // Future<void> _showSubscriptionDialog(BuildContext context) async {
  //   CoursesCubit.get(context).changeIsCourseLoading();
  //   await CoursesCubit.get(context).getVideosByCourse(id: CoursesCubit.get(context).courseResult[0]['id'], context: context);
  //   Navigator.push(context, CupertinoPageRoute(builder: (context) => CourseVideoScreen(videoIndex: CoursesCubit.get(context).courseResult[0]['id'])));
  //   CoursesCubit.get(context).changeIsCourseLoading();
  // }

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
    final courseResult = BooksCubit.get(context).book;
    final phoneNumber = (courseResult.isNotEmpty && courseResult['phone'] != null)
        ? courseResult['phone'].toString()
        : 'رقم غير متاح حالياً';

    return buildCard(
      title: 'فودافون كاش',
      price: widget.data['price'],
      description: 'وبعد التحويل، ابعت صورة الإيصال على واتساب لنفس الرقم.',
      extra: Column(
        children: [
          Text('حول على الرقم: $phoneNumber',
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


  void showOrderDialog(String method) {
    final _formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  backgroundColor: AppColors.lightBlue,
                  actionsAlignment: MainAxisAlignment.center,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: const Text('معلومات الطلب', textAlign: TextAlign.center),
                  content: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(

                      ),
                     // height: 400,
                      child: Column(
                        spacing: 5,
                        children: [
                          Image.asset('assets/images/pic.png'),
                          SizedBox(height: 20,),
                          TextFormField(

                            controller: addressController,
                            decoration: const InputDecoration(labelText: 'العنوان',border: OutlineInputBorder(),fillColor: Colors.white54,filled: true),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'يرجى إدخال العنوان';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: quantityController,
                            decoration: const InputDecoration(labelText: 'الكمية',border: OutlineInputBorder(),fillColor: Colors.white54,filled: true),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'يرجى إدخال الكمية';
                              if (int.tryParse(value) == null) return 'الكمية يجب أن تكون رقم';
                              if (int.parse(value) <= 0) return 'الكمية يجب أن تكون أكبر من 0';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          if (isLoading) const AppLoaderInkDrop(),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    InkWell(
                      child: Container(
                        width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(25),),
                          child: Center(child: Text('إلغاء',style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),))
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(25),),
                          child: Center(child: Text('تأكيد الطلب',style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),))
                      ),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);

                          await BooksCubit.get(context).orderOfBook(
                            id: widget.data['id'],
                            paymentMethod: method,
                            address: addressController.text.trim(),
                            quantity: int.parse(quantityController.text.trim()),
                          );

                          setState(() {
                            widget.data['status'] = 'pending';
                            widget.data['payment_type'] = method;
                          });

                          Navigator.of(context).pop(); // close dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال الطلب بنجاح'),backgroundColor: Colors.green,),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleButtonPress(String method) {
    final isEnrolled = widget.data['is_enrolled'] == true;
    final String status = widget.data['request_status']?['key'] ?? (isEnrolled ? 'approved' : widget.data['status'] ?? '');

    if (!isEnrolled && status == 'approved') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى التواصل مع الدعم لتفعيل اشتراكك')));
      return;
    }

    if (status == 'approved') {
      // _showSubscriptionDialog(context);
    } else if (status == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('طلبك قيد المراجعة حالياً')));
    } else if (status == 'rejected') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('طلبك مرفوض، تواصل مع الدعم')));
    } else {
      showOrderDialog(method);
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
    final isEnrolled = widget.data['is_enrolled'] == true;
    final String status = widget.data['request_status']?['key'] ??
        (isEnrolled ? 'approved' : widget.data['status'] ?? '');

    Color buttonColor;
    Color textColor;
    String buttonLabel;

    switch (status) {
      case 'approved':
        buttonColor = Colors.green;
        textColor = Colors.white;
        buttonLabel = 'تمت الموافقة';
        break;
      case 'pending':
        buttonColor = Colors.yellow.shade600;
        textColor = Colors.black;
        buttonLabel = 'قيد الانتظار';
        break;
      case 'rejected':
        buttonColor = Colors.red;
        textColor = Colors.white;
        buttonLabel = 'مرفوض';
        break;
      default:
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
            Center(
              child: Text(
                title,
                style: TextStyles.textStyle16w700(context)
                    .copyWith(color: AppColors.secondary30),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('مش عارف تدفع دلوقتي؟'),
                const Spacer(),
                Text(
                  '$price جنيه',
                  style: TextStyles.textStyle20w700(context).copyWith(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyles.textStyle16w400(context).copyWith(color: Colors.red),
            ),
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
                  onPressed: onPressed, // 🔒 Disabled in all cases
                  child: Text(
                    buttonLabel,
                    style: TextStyles.textStyle16w700(context).copyWith(color: textColor),
                  ),
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
    return BlocConsumer<BooksCubit, BooksState>(
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
