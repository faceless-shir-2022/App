import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  final myText;
  final controller_2;
  const AutocompleteBasicExample({super.key, this.myText, this.controller_2});

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
