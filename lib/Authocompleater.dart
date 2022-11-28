// import 'dart:js';
import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  final myText;
  const AutocompleteBasicExample({super.key, this.myText});

  static const List<String> _kOptions = <String>[
    '107',
    'актовый зал',
    '301',
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
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onEditingComplete) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(hintText: 'Введите точку $myText пути'),
        );
      },
    );
  }
}
