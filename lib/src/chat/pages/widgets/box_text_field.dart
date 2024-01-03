import 'package:flutter/material.dart';

class BoxTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final Widget suffixIcons;
  final void Function() onFieldSubmitted;

  const BoxTextField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.suffixIcons,
      required this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (_) => onFieldSubmitted(),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      style:
          const TextStyle(fontSize: 16, color: Color.fromARGB(255, 87, 87, 87)),
      decoration: InputDecoration(
        labelText: 'Digite algo',
        labelStyle: const TextStyle(fontSize: 16, color: Colors.blue),
        filled: true,
        fillColor: Colors.blue.withAlpha(50),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: suffixIcons,
      ),
    );
  }
}
