import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();

  final TextEditingController? textEditingController;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Color? borderColor;
  final double? borderRadius;
  final bool? validation;
  final String? errorText;

  const CustomTextArea({
    Key? key,
    this.textEditingController,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.borderColor,
    this.borderRadius,
    this.validation,
    this.errorText,
  }) : super(key: key);
}

class _BodyState extends State<CustomTextArea> {
  var reasonErrorVisibility = false;
  Color? borderColor;

  @override
  void initState() {
    borderColor = widget.borderColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardView(
          borderRadius: widget.borderRadius,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: borderColor!),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    minLines: 2,
                    maxLines: 5,
                    controller: widget.textEditingController,
        
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      widget.suffixIcon,
                      color: const Color(0xFF0023DB),
                    ),
                    onPressed: widget.onSuffixIconPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: Visibility(
            visible: reasonErrorVisibility,
            child: Text(
              widget.errorText == null ? '' : widget.errorText!,
              style: const TextStyle(color: Color(0xFFCA0D0C), fontSize: 12.0),
            ),
          ),
        )
      ],
    );
  }
}

class CardView extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final Color? background;
  final EdgeInsetsGeometry? padding;

  const CardView({
    Key? key,
    this.child,
    this.borderRadius,
    this.background,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(
          borderRadius != null ? borderRadius! : 0.0,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(6, 6),
              spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}
