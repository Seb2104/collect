part of '../../collect.dart';

class Radix {
  /// I am assuming everyone is using a radix of 10 to start ( the normal decimal numbers )
  static String getAlphabet({required int source, required int toRadix}) {
    return base.substring(0, toRadix);
  }

  static const String base =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@%^\$&*()-_=[]{}|;:,.<>?~`\'"\\ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿЀЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя#';
}
