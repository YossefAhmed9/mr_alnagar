import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';

class RegisterPasswordFormField extends StatefulWidget {
   RegisterPasswordFormField(
      {required this.hint,
        required this.controller,
        required this.validator,
        required this.onChange,
        required this.onSubmit});
final String hint;
final   validator;
final onChange;
final onSubmit;
 TextEditingController controller=TextEditingController();

  @override
  State<RegisterPasswordFormField> createState() => _RegisterPasswordFormFieldState();
}

class _RegisterPasswordFormFieldState extends State<RegisterPasswordFormField> {
  bool obsecure=true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(widget.hint,style: TextStyles.textStyle12w400(context),),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChange,
          onFieldSubmitted: widget.onSubmit,
          obscureText: obsecure,
          decoration: InputDecoration(
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                obsecure=!obsecure;

              });
            }, icon: Icon(obsecure==false ? FluentIcons.eye_20_filled : FluentIcons.eye_off_20_filled)),

            //hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
            ),),
      ],
    );
  }
}
