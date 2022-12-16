import 'package:flutter/material.dart';
import 'dart:io' as f;

const List<String> fruktovaya = <String>[
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
  '220',
  '226',
  '223',
  '224',
  '225',
  'спортивный зал',
  '2',
  '311',
  '310',
  '309',
  '308',
  '307',
  '306',
  '305',
  '313',
  '314',
  '304',
  '303',
  '302',
  '300',
  'рубка',
  'трен. зал',
  '321',
  '322',
  '323',
  '326',
  '327',
  '332',
  '331',
  '330',
  '329'
];
const List<String> krivorozhskaya = <String>[
  '103',
  '104',
  '105',
  '106',
  '113',
  '114',
  '115',
  '116',
  '117',
  'раздевалка',
  'актовый зал',
  'спортивный зал',
  '202',
  '203',
  '204',
  '205',
  '206',
  '207',
  '208',
  '209',
  '210',
  '211',
  '212',
  '213',
  '302',
  '303',
  '304',
  '305',
  '306',
  '307',
  '308',
  '309',
  '310',
  '312',
  '313',
  '314',
  '315'
];
const List<String> chongarskaya = <String>[
  'вход',
  '101',
  '103',
  'столовая',
  'спортивный зал',
  '209',
  '208',
  '207',
  '206',
  '205',
  '204',
  '203',
  '202',
  '201',
  '301',
  '302',
  '303',
  '304',
  '305',
  '306',
  '307',
  '401',
  '402',
  '203',
  '404',
  '405',
  '406',
  '407',
  '408',
  '409',
  '501',
  '502',
  '503',
  '503a',
  '504',
  '504a',
  '505',
  '506',
  'актовый зал'
];

class AutocompleteBasicExample extends StatelessWidget {
  final myText;
  final controller_2;
  final schoolAdress;
  const AutocompleteBasicExample(
      {super.key, this.myText, this.controller_2, this.schoolAdress});
  // static final List<String> _kOptions =
  //     f.File('assets/classes.txt').readAsString().toString().split('\n');

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        if (schoolAdress == 'Фруктовая') {
          return fruktovaya.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        } else if (schoolAdress == 'Чонгарская') {
          return chongarskaya.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        } else {
          return krivorozhskaya.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        }
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        controller_2.text = selection;
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
