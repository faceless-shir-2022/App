import 'package:flutter/material.dart';
import 'package:flutter_application_1/DropDownClass.dart';
import 'package:http/http.dart' as http;

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Недоступно'),
      content: const Text('Данная функция находится в разработке'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class DialogWrongData extends StatelessWidget {
  const DialogWrongData({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Неверное значение'),
      content:
          const Text('Пожалуйста, выбирайте кабинеты из выпадающего списка'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        ),
      ],
    );
  }
}

class RulesOfUsing extends StatelessWidget {
  const RulesOfUsing({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ВАЖНО К ПРОЧТЕНИЮ'),
      content: Column(
        children: const [
          Text('Кратенькое руководство по эксплуатации:'),
          Text('Утречка, а теперь ты сможешь проложить маршрут.'),
          Text(
              'Для начала введи кабинеты в поля для ввода, но не забудь выбрать их из выпадающего списка, иначе ничего не выйдет.'),
          Text(
              'Затем нажми кнопку "Начать", подтвердив начало движения, и отправляйся в путь.'),
          Text(
              'Ты также можешь перемещаться по этажам, нажимая на кнопку соответствующего этажа.'),
          Text('Удачи не заблудиться! :)'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/first');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class Checkroom extends StatelessWidget {
  final adress;
  final A;
  final B;
  const Checkroom({super.key, this.adress, this.A, this.B});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Введите ваш класс'),
      content: const Text(
          'Пожалуйста, выбирайте ваш класс, для более точного маршрута от раздевалок'),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Text('Выберите класс:'),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: const DropdownButtonExample(),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Отмена'),
        ),
        // TextButton(
        //   onPressed: () {

        // Navigator.pop(context);
        //  http.get(Uri.parse(
        //                   'http://tortik13.pythonanywhere.com/krivorozhskaya/$_startA/$_finishB'));
        //               Navigator.pushNamed(context,
        //                   '/second/$_id/$_img/$_isSearch/$_startA/$_finishB');
        // },
        // child: const Text('ok'),
        // ),
      ],
    );
  }
}
