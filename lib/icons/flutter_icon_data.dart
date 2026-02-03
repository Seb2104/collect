part of '../collect.dart';



/// A class that is used to generate IconData under different icon sets
class IconCollection extends IconData {
  const IconCollection(int codePoint, String fontFamily)
    : super(codePoint, fontFamily: fontFamily, fontPackage: "flutter_icons");

  const IconCollection.ionicons(int codePoint) : this(codePoint, "Ionicons");

  const IconCollection.antDesign(int codePoint) : this(codePoint, "AntDesign");

  const IconCollection.fontAwesome(int codePoint)
    : this(codePoint, "FontAwesome");

  const IconCollection.fontAwesome5Brands(int codePoint)
    : this(codePoint, "FontAwesome5_Brands");

  const IconCollection.fontAwesome5(int codePoint)
    : this(codePoint, "FontAwesome5");

  const IconCollection.fontAwesome5Solid(int codePoint)
    : this(codePoint, "FontAwesome5_Solid");

  const IconCollection.entypo(int codePoint) : this(codePoint, "Entypo");

  const IconCollection.evilIcons(int codePoint) : this(codePoint, "EvilIcons");

  const IconCollection.feather(int codePoint) : this(codePoint, "Feather");

  const IconCollection.foundation(int codePoint)
    : this(codePoint, "Foundation");

  const IconCollection.materialCommunityIcons(int codePoint)
    : this(codePoint, "MaterialCommunityIcons");

  const IconCollection.materialIcons(int codePoint)
    : this(codePoint, "MaterialIcons");

  const IconCollection.octicons(int codePoint) : this(codePoint, "Octicons");

  const IconCollection.simpleLineIcons(int codePoint)
    : this(codePoint, "SimpleLineIcons");

  const IconCollection.zocial(int codePoint) : this(codePoint, "Zocial");

  const IconCollection.weatherIcons(int codePoint)
    : this(codePoint, "WeatherIcons");
}
