import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';

bool obSecure = false;

class CustomTextfieldCommon extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  String? errorText;
  TextInputType? textInputType = TextInputType.text;
  bool? obscureText;
  Function validate;
  bool? btnValidate = false;
  AutovalidateMode? autovalidateMode;
  bool readOnly = false;
  GestureTapCallback? onTap;
  List<TextInputFormatter>? inputFormatters;
  Widget? prefix;

  CustomTextfieldCommon(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.textInputType,
      this.errorText,
      this.obscureText = false,
      required this.validate,
      this.btnValidate,
      this.autovalidateMode,
      this.readOnly = false,
      this.onTap,
      this.inputFormatters,
      this.prefix});

  @override
  State<CustomTextfieldCommon> createState() => _CustomTextfieldCommonState();
}

class _CustomTextfieldCommonState extends State<CustomTextfieldCommon> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (widget.btnValidate == null) {
          null;
        } else {
          widget.btnValidate! ? widget.validate() : null;
        }
      },
      onTap: widget.onTap,
      autovalidateMode: widget.autovalidateMode,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: obSecure,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.readOnly,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: kBlack,
      ),
      cursorColor: AppColors.colorFE6927,
      decoration: InputDecoration(
          prefix: widget.prefix,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: widget.errorText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(width: 1, color: kBlack)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(width: 1, color: kBlack)),
          contentPadding: const EdgeInsets.all(13.0),
          suffixIcon: widget.obscureText!
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obSecure = !obSecure;
                    });
                  },
                  child: Icon(
                    obSecure ? Icons.visibility : Icons.visibility_off,
                    color: kDarkGrey,
                  ),
                )
              : null,
          labelText: widget.label,
          labelStyle: Palette.labelStyle,
          hintText: widget.hint,
          hintStyle: Palette.hintStyle),
    );
  }
}
