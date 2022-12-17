import 'package:flutter/material.dart';
import 'dart:io' as f;

const List<String> fruktovaya = <String>[
  '103',
  '104',
  '105',
  '106',
  '107',
  'Учительская',
  '113',
  '114',
  '115',
  '116',
  'Библиотека',
  'Вход 1',
  'Вход 2',
  '122',
  '123',
  '124',
  '125',
  '133',
  '134',
  'Медпункт',
  'Столовая',
  'Буфет',
  '200',
  '203',
  '204',
  '206',
  '207',
  '208',
  '209',
  '210',
  '212',
  '213',
  '220',
  '221',
  '223',
  '224',
  '225',
  '226',
  'Спортзал',
  'Актовый зал',
  '300',
  '302',
  '303',
  '304',
  '305',
  '306',
  '307',
  '308',
  '309',
  '310',
  '311',
  '313',
  '314',
  '321',
  '326',
  '327',
  '323',
  '2',
  '329',
  '330',
  '331',
  '332',
  '131',
  '132',
  '322',
  '205',
  '219',
  'Раздевалка'
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
  'Спортзал',
  'Актовый зал',
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
  '315',
];
const List<String> chongarskaya = <String>[
  '101',
  '103',
  'Вход',
  'Столовая',
  'Спортзал',
  '201',
  '202',
  '203',
  '204',
  '205',
  '206',
  '207',
  '208',
  '209',
  '301',
  '302',
  '303',
  '304',
  '305',
  '306',
  '307',
  '401',
  '402',
  '403',
  '404',
  '405',
  '406',
  '407',
  '408',
  '409',
  '501',
  '502',
  '503',
  '503а',
  '504',
  '504а',
  '505',
  '506',
  'Актовый зал',
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
            return option.contains(textEditingValue.text);
          });
        } else if (schoolAdress == 'Чонгарская') {
          return chongarskaya.where((String option) {
            return option.contains(textEditingValue.text);
          });
        } else {
          return krivorozhskaya.where((String option) {
            return option.contains(textEditingValue.text);
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
