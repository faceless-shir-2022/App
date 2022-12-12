import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  final myText;
  final controller_2;
  const AutocompleteBasicExample({super.key, this.myText, this.controller_2});

  static const List<String> _kOptions = <String>[
    'IT',
    '104',
    '105',
    '106',
    '107',
    '113',
    '114',
    '115',
    '116',
    'Библиотека',
    '122',
    '123',
    '124',
    '125',
    'вход1',
    'вход2',
    'Учительская',
    'Мед. кабинет',
    'актовый зал',
    '130',
    '131',
    '132',
    '134',
    '301',
    '203',
    '200',
    '204',
    '212',
    '213',
    '206',
    '207',
    '208',
    '209',
    '210',
    '221',
    '220'
        '226',
    '223',
    '224',
    '225',
    'спортивный зал',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        controller_2.text = '$selection';
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onEditingComplete) {
        return TextField(
          controller: textEditingController,
          // controller: controller_2,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(hintText: '$myText'),
        );
      },
    );
  }
}
