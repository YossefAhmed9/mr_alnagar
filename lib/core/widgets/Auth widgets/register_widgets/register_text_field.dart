import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';

class RegisterTextField extends StatelessWidget {
   RegisterTextField({Key? key,
     required this.hint,
     required this.keyboard,
     required this.controller,
     this.validator,
     this.onChange,
     this.onSubmit}) : super(key: key);
final String hint;
final TextInputType keyboard;
  final validator;
  final onChange;
  final onSubmit;
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.symmetric(vertical:  10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint,style: TextStyles.textStyle12w400(context)),
          TextFormField(
            validator: validator,
            onChanged: onChange,
            onFieldSubmitted: onSubmit,
            keyboardType: keyboard,
            controller: controller,
              decoration: InputDecoration(
                // hintText: hint,
                enabledBorder: OutlineInputBorder(

                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
          ),
        ],
      ),
    );
  }
}
