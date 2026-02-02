part of '../collect.dart';


class Radix {
  static dynamic base(dynamic data, Base radix) {
    return data is int
        ? _crypt(
            data: data.toString(),
            from: _base.substring(0, 10),
            to: _base.substring(0, radix.value),
          )
        : int.parse(
            _crypt(
              data: data,
              from: _base.substring(0, radix.value),
              to: _base.substring(0, 10),
            ),
          );
  }

  static dynamic toRadix(dynamic data, Base currentRadix, Base toRadix) {
    int.parse(
      _crypt(
        data: data,
        from: _base.substring(0, toRadix.value),
        to: _base.substring(0, 10),
      ),
    );
  }

  static String oct(int data) {
    return base(data, Bases.b8);
  }

  static String bin(int data) {
    return base(data, Bases.b2).toUpperCase();
  }

  static String hex(int data) {
    return base(data, Bases.b16).toUpperCase();
  }

  static String dec(int data) {
    return base(data, Bases.b10);
  }

  static String _crypt({
    dynamic data,
    required String from,
    required String to,
  }) {
    if (data.isEmpty || from == to) {
      return data;
    }

    final int sourceBase = from.length;
    final int destinationBase = to.length;
    final Map<int, int> numberMap = {};
    int divide = 0;
    int newLength = 0;
    int length = data.length;
    String result = '';

    for (int i = 0; i < length; i++) {
      final index = from.indexOf(data[i]);
      if (index == -1) {
        throw FormatException(
          'Source "$data" contains character '
          '"${data[i]}" which is outside of the defined source alphabet '
          '"$from"',
        );
      }
      numberMap[i] = from.indexOf(data[i]);
    }

    do {
      divide = 0;
      newLength = 0;
      for (int i = 0; i < length; i++) {
        divide = divide * sourceBase + (numberMap[i] as int);
        if (divide >= destinationBase) {
          numberMap[newLength++] = divide ~/ destinationBase;
          divide = divide % destinationBase;
        } else if (newLength > 0) {
          numberMap[newLength++] = 0;
        }
      }
      length = newLength;
      result = to[divide] + result;
    } while (newLength != 0);
    return result;
  }

  static int colourValue(double data) {
    return data.clamp(0, 255).round();
  }

  static int fractionToColourValue(double data) {
    return (data.clamp(0.0, 1.0) * 255).round();
  }

  static int percentToColourValue(double data) {
    return ((data.clamp(0.0, 100.0) / 100) * 255).round();
  }

  static const String _base =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@%^\$&*()-_=[]{}|;:,.<>?~`\'"\\ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿЀЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя#';
}

