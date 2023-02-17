import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  Object? value;
  List<DropdownMenuItem<Object>>? items;
  void Function(Object?)? onChanged;
  Widget? hint;
  String? Function(Object?)? validator;
  double? maxHeight;
  MyDropDown(
      {required this.items,
      required this.onChanged,
      required this.hint,
      required this.validator,
      this.value,
      required this.maxHeight,
      Key? key})
      : super(key: key);

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: widget.value,
      dropdownFullScreen: false,
      dropdownMaxHeight: widget.maxHeight ?? 250,
      dropdownOverButton: false,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 10),
      scrollbarAlwaysShow: true,
      isExpanded: true,
      scrollbarThickness: 10,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          // horizontal: 1,
          vertical: 14,
        ),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      items: widget.items,
      onChanged: widget.onChanged,
      hint: widget.hint,
    );
  }
}
