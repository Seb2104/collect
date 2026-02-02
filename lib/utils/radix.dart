part of '../collect.dart';

final class Radix {
  static dynamic base(dynamic data, int radix) {
    return data is int
        ? _crypt(
      data: data.toString(),
      from: _base.substring(0, 10),
      to: _base.substring(0, radix),
    )
        : int.parse(
      _crypt(
        data: data,
        from: _base.substring(0, radix),
        to: _base.substring(0, 10),
      ),
    );
  }

  static dynamic toRadix(dynamic data, int currentRadix, int toRadix) {
    int.parse(
      _crypt(
        data: data,
        from: _base.substring(0, toRadix),
        to: _base.substring(0, 10),
      ),
    );
  }

  static String oct(int data) {
    return base(data, 8);
  }

  static String bin(int data) {
    return base(data, 2).toUpperCase();
  }

  static String hex(int data) {
    return base(data, 16).toUpperCase();
  }

  static String dec(int data) {
    return base(data, 10);
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
          'Source "$data" contains character ' '"${data[i]}" which is outside of the defined source alphabet ' '"$from"',
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

  static const int binary = 2;

  static const int ternary = 3;

  static const int quaternary = 4;

  static const int quinary = 5;

  static const int senary = 6;

  static const int septenary = 7;

  static const int octal = 8;

  static const int nonary = 9;

  static const int decimal = 10;

  static const int undecimal = 11;

  static const int duodecimal = 12;

  static const int tridecimal = 13;

  static const int tetradecimal = 14;

  static const int pentadecimal = 15;

  static const int hexadecimal = 16;

  static const int heptadecimal = 17;

  static const int octodecimal = 18;

  static const int enneadecimal = 19;

  static const int vigesimal = 20;

  static const int unvigesimal = 21;

  static const int duovigesimal = 22;

  static const int trivigesimal = 23;

  static const int tetravigesimal = 24;

  static const int pentavigesimal = 25;

  static const int hexavigesimal = 26;

  static const int heptavigesimal = 27;

  static const int septemvigesimal = 27;

  static const int octovigesimal = 28;

  static const int enneavigesimal = 29;

  static const int trigesimal = 30;

  static const int untrigesimal = 31;

  static const int duotrigesimal = 32;

  static const int tritrigesimal = 33;

  static const int tetratrigesimal = 34;

  static const int pentatrigesimal = 35;

  static const int hexatrigesimal = 36;

  static const int heptatrigesimal = 37;

  static const int octotrigesimal = 38;

  static const int enneatrigesimal = 39;

  static const int quadragesimal = 40;

  static const int duoquadragesimal = 42;

  static const int pentaquadragesimal = 45;

  static const int septaquadragesimal = 47;

  static const int octoquadragesimal = 48;

  static const int enneaquadragesimal = 49;

  static const int quinquagesimal = 50;

  static const int duoquinquagesimal = 52;

  static const int tetraquinquagesimal = 54;

  static const int hexaquinquagesimal = 56;

  static const int heptaquinquagesimal = 57;

  static const int octoquinquagesimal = 58;

  static const int sexagesimal = 60;

  static const int duosexagesimal = 62;

  static const int tetrasexagesimal = 64;

  static const int duoseptuagesimal = 72;

  static const int octogesimal = 80;

  static const int unoctogesimal = 81;

  static const int pentoctogesimal = 85;

  static const int enneaoctogesimal = 89;

  static const int nonagesimal = 90;

  static const int unnonagesimal = 91;

  static const int duononagesimal = 92;

  static const int trinonagesimal = 93;

  static const int tetranonagesimal = 94;

  static const int pentanonagesimal = 95;

  static const int hexanonagesimal = 96;

  static const int septanonagesimal = 97;

  static const int centesimal = 100;

  static const int centevigesimal = 120;

  static const int centeunvigesimal = 121;

  static const int centepentavigesimal = 125;

  static const int centeoctovigesimal = 128;

  static const int centetetraquadragesimal = 144;

  static const int centenovemsexagesimal = 169;

  static const int centepentoctogesimal = 185;

  static const int centehexanonagesimal = 196;

  static const int duocentesimal = 200;

  static const int duocentedecimal = 210;

  static const int duocentehexidecimal = 216;

  static const int duocentepentavigesimal = 225;

  static const int duocentehexaquinquagesimal = 25;

  static const int trecentesimal = 300;

  static const int trecentosexagesimal = 360;

  static const int b2 = 2;

  static const int b3 = 3;

  static const int b4 = 4;

  static const int b5 = 5;

  static const int b6 = 6;

  static const int b7 = 7;

  static const int b8 = 8;

  static const int b9 = 9;

  static const int b10 = 10;

  static const int b11 = 11;

  static const int b12 = 12;

  static const int b13 = 13;

  static const int b14 = 14;

  static const int b15 = 15;

  static const int b16 = 16;

  static const int b17 = 17;

  static const int b18 = 18;

  static const int b19 = 19;

  static const int b20 = 20;

  static const int b21 = 21;

  static const int b22 = 22;

  static const int b23 = 23;

  static const int b24 = 24;

  static const int b25 = 25;

  static const int b26 = 26;

  static const int b27 = 27;

  static const int b28 = 28;

  static const int b29 = 29;

  static const int b30 = 30;

  static const int b31 = 31;

  static const int b32 = 32;

  static const int b33 = 33;

  static const int b34 = 34;

  static const int b35 = 35;

  static const int b36 = 36;

  static const int b37 = 37;

  static const int b38 = 38;

  static const int b39 = 39;

  static const int b40 = 40;

  static const int b41 = 41;

  static const int b42 = 42;

  static const int b43 = 43;

  static const int b44 = 44;

  static const int b45 = 45;

  static const int b46 = 46;

  static const int b47 = 47;

  static const int b48 = 48;

  static const int b49 = 49;

  static const int b50 = 50;

  static const int b51 = 51;

  static const int b52 = 52;

  static const int b53 = 53;

  static const int b54 = 54;

  static const int b55 = 55;

  static const int b56 = 56;

  static const int b57 = 57;

  static const int b58 = 58;

  static const int b59 = 59;

  static const int b60 = 60;

  static const int b61 = 61;

  static const int b62 = 62;

  static const int b63 = 63;

  static const int b64 = 64;

  static const int b65 = 65;

  static const int b66 = 66;

  static const int b67 = 67;

  static const int b68 = 68;

  static const int b69 = 69;

  static const int b70 = 70;

  static const int b71 = 71;

  static const int b72 = 72;

  static const int b73 = 73;

  static const int b74 = 74;

  static const int b75 = 75;

  static const int b76 = 76;

  static const int b77 = 77;

  static const int b78 = 78;

  static const int b79 = 79;

  static const int b80 = 80;

  static const int b81 = 81;

  static const int b82 = 82;

  static const int b83 = 83;

  static const int b84 = 84;

  static const int b85 = 85;

  static const int b86 = 86;

  static const int b87 = 87;

  static const int b88 = 88;

  static const int b89 = 89;

  static const int b90 = 90;

  static const int b91 = 91;

  static const int b92 = 92;

  static const int b93 = 93;

  static const int b94 = 94;

  static const int b95 = 95;

  static const int b96 = 96;

  static const int b97 = 97;

  static const int b98 = 98;

  static const int b99 = 99;

  static const int b100 = 100;

  static const int b101 = 101;

  static const int b102 = 102;

  static const int b103 = 103;

  static const int b104 = 104;

  static const int b105 = 105;

  static const int b106 = 106;

  static const int b107 = 107;

  static const int b108 = 108;

  static const int b109 = 109;

  static const int b110 = 110;

  static const int b111 = 111;

  static const int b112 = 112;

  static const int b113 = 113;

  static const int b114 = 114;

  static const int b115 = 115;

  static const int b116 = 116;

  static const int b117 = 117;

  static const int b118 = 118;

  static const int b119 = 119;

  static const int b120 = 120;

  static const int b121 = 121;

  static const int b122 = 122;

  static const int b123 = 123;

  static const int b124 = 124;

  static const int b125 = 125;

  static const int b126 = 126;

  static const int b127 = 127;

  static const int b128 = 128;

  static const int b129 = 129;

  static const int b130 = 130;

  static const int b131 = 131;

  static const int b132 = 132;

  static const int b133 = 133;

  static const int b134 = 134;

  static const int b135 = 135;

  static const int b136 = 136;

  static const int b137 = 137;

  static const int b138 = 138;

  static const int b139 = 139;

  static const int b140 = 140;

  static const int b141 = 141;

  static const int b142 = 142;

  static const int b143 = 143;

  static const int b144 = 144;

  static const int b145 = 145;

  static const int b146 = 146;

  static const int b147 = 147;

  static const int b148 = 148;

  static const int b149 = 149;

  static const int b150 = 150;

  static const int b151 = 151;

  static const int b152 = 152;

  static const int b153 = 153;

  static const int b154 = 154;

  static const int b155 = 155;

  static const int b156 = 156;

  static const int b157 = 157;

  static const int b158 = 158;

  static const int b159 = 159;

  static const int b160 = 160;

  static const int b161 = 161;

  static const int b162 = 162;

  static const int b163 = 163;

  static const int b164 = 164;

  static const int b165 = 165;

  static const int b166 = 166;

  static const int b167 = 167;

  static const int b168 = 168;

  static const int b169 = 169;

  static const int b170 = 170;

  static const int b171 = 171;

  static const int b172 = 172;

  static const int b173 = 173;

  static const int b174 = 174;

  static const int b175 = 175;

  static const int b176 = 176;

  static const int b177 = 177;

  static const int b178 = 178;

  static const int b179 = 179;

  static const int b180 = 180;

  static const int b181 = 181;

  static const int b182 = 182;

  static const int b183 = 183;

  static const int b184 = 184;

  static const int b185 = 185;

  static const int b186 = 186;

  static const int b187 = 187;

  static const int b188 = 188;

  static const int b189 = 189;

  static const int b190 = 190;

  static const int b191 = 191;

  static const int b192 = 192;

  static const int b193 = 193;

  static const int b194 = 194;

  static const int b195 = 195;

  static const int b196 = 196;

  static const int b197 = 197;

  static const int b198 = 198;

  static const int b199 = 199;

  static const int b200 = 200;

  static const int b201 = 201;

  static const int b202 = 202;

  static const int b203 = 203;

  static const int b204 = 204;

  static const int b205 = 205;

  static const int b206 = 206;

  static const int b207 = 207;

  static const int b208 = 208;

  static const int b209 = 209;

  static const int b210 = 210;

  static const int b211 = 211;

  static const int b212 = 212;

  static const int b213 = 213;

  static const int b214 = 214;

  static const int b215 = 215;

  static const int b216 = 216;

  static const int b217 = 217;

  static const int b218 = 218;

  static const int b219 = 219;

  static const int b220 = 220;

  static const int b221 = 221;

  static const int b222 = 222;

  static const int b223 = 223;

  static const int b224 = 224;

  static const int b225 = 225;

  static const int b226 = 226;

  static const int b227 = 227;

  static const int b228 = 228;

  static const int b229 = 229;

  static const int b230 = 230;

  static const int b231 = 231;

  static const int b232 = 232;

  static const int b233 = 233;

  static const int b234 = 234;

  static const int b235 = 235;

  static const int b236 = 236;

  static const int b237 = 237;

  static const int b238 = 238;

  static const int b239 = 239;

  static const int b240 = 240;

  static const int b241 = 241;

  static const int b242 = 242;

  static const int b243 = 243;

  static const int b244 = 244;

  static const int b245 = 245;

  static const int b246 = 246;

  static const int b247 = 247;

  static const int b248 = 248;

  static const int b249 = 249;

  static const int b250 = 250;

  static const int b251 = 251;

  static const int b252 = 252;

  static const int b253 = 253;

  static const int b254 = 254;

  static const int b255 = 255;

  static const int b256 = 256;
}
