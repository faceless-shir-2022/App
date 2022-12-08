import 'package:flutter/material.dart';

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
            Navigator.pushNamed(context, '/first');
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
            Navigator.pushNamed(context, '/second/Фруктовая/1/nosearch//');
          },
          child: const Text('OK'),
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
