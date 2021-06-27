import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:product_list/styles/text_styles.dart';

class ProductItem extends StatelessWidget {
  static final TextStyle descriptionTextStyle = TextStyles.description;
  static final TextStyle unitsTextStyle = TextStyles.units;

  final String description;
  final String units;
  final double width;
  final int maxLines;
  List<String> splittedDescription;

  // Лучше, наверное, передавать параметр типа Product, вместо 2 строк
  ProductItem({
    @required this.description,
    @required this.units,
    this.width = 100,
    this.maxLines = 2,
  }) {
    this.splittedDescription = _getSplittedDescription();
  }

  /// Метод для разбиения описания по строкам, чтобы их ширина не превышала
  /// ширины контейнера. Ширина последней строки может быть любого размера,
  /// потому что в конечном итоге она обрезается (ellipsis).
  /// Этот метод можно сделать универсальным, если он понадобится в других
  /// местах приложения
  List<String> _getSplittedDescription() {
    final words = Queue.from(description.split(' '));
    List<String> lines = [];
    // Формируем все строки, кроме последней
    for (var i = 0; i < maxLines - 1; i++) {
      // Если все слова из описания распределены по строкам,
      // досрочно завершаем цикл и возвращаем результат.
      if (words.isEmpty) {
        return lines;
      }

      var lineWidth = .0;
      var line = '';
      var lastWord = '';
      // Формируем новую строку, добавляя по одному слову каждый раз.
      // Можно вынести в отдельный метод
      while (lineWidth < width && words.isNotEmpty) {
        lastWord = words.first;
        // Если в строке уже есть слова, добавляем пробел перед новым словом.
        if (line.length > 0) {
          line += ' ';
        }
        line += '$lastWord';
        words.removeFirst();
        lineWidth = _textSize(line, descriptionTextStyle).width;
      }

      // В этот момент допустимая ширина строки превышена, поэтому как бы
      // откатываем результат на одно слово, если число слов больше 1.


      // Смотрим, сколько слов в строке. Если находим пробел, значит > 1.
      final lastSpaceIndex = line.lastIndexOf(' ');
      if (lastSpaceIndex != -1) {
        line = line.substring(0, lastSpaceIndex);
        words.addFirst(lastWord);
      }
      lines.add(line);
    }

    // Если остались ещё слова, формируем последнюю строку без ограничения по
    // длине
    if (words.isNotEmpty) {
      lines.add(words.join(' '));
    }

    return lines;
  }

  /// Метод, чтобы узнавать, сколько пикселей будет занимать отрисованная строка
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.lightBlueAccent,
          width: 1,
        ),
      ),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Первые строки
          if (splittedDescription.length > 1)
            ...splittedDescription
                .sublist(0, splittedDescription.length - 1)
                .map((str) => FittedBox(
                    // Завернул в этот виджет, чтобы если вдруг встретится очень
                    // длинное слово, шрифт уменьшился. Но лучше по-другому эту
                    // проблему решать
                    fit: BoxFit.scaleDown,
                    child: Text(
                      str,
                      style: descriptionTextStyle,
                      maxLines: 1,
                    )))
                .toList(),
          // Нижняя строка
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Чтобы растягивалась, насколько позволяет текст с
              // единицами измерения.
              Expanded(
                child: Text(
                  splittedDescription.last,
                  style: descriptionTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Небольшой промежуток для красоты
              SizedBox(
                width: 3,
              ),
              Text(
                units,
                style: unitsTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
