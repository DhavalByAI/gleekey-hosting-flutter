import 'package:flutter/material.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';

bool obSecure = true;

class CustomTextfieldPass extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  String? errorText;
  TextInputType? textInputType = TextInputType.text;
  Function validate;
  bool? btnValidate = false;

  CustomTextfieldPass(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.textInputType,
      this.errorText,
      required this.validate,
      this.btnValidate});

  @override
  State<CustomTextfieldPass> createState() => _CustomTextfieldPassState();
}

class _CustomTextfieldPassState extends State<CustomTextfieldPass> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (widget.btnValidate == null) {
          null;
        } else {
          widget.btnValidate! ? widget.validate() : null;
        }
      },
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: obSecure,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: kBlack,
      ),
      cursorColor: AppColors.colorFE6927,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: widget.errorText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(width: 1, color: kBlack)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(width: 1, color: kBlack)),
          contentPadding: const EdgeInsets.all(13.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obSecure = !obSecure;
              });
            },
            child: Icon(
              obSecure ? Icons.visibility : Icons.visibility_off,
              color: kDarkGrey,
            ),
          ),
          labelText: widget.label,
          labelStyle: Palette.labelStyle,
          hintText: widget.hint,
          hintStyle: Palette.hintStyle),
    );
  }
}
