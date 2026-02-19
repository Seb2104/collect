library;

import 'dart:io';
import 'dart:math' as math;

import 'package:collect/modules/colour/colour.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide FilterCallback, SearchCallback;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:unicode/unicode.dart' as unicode;

export 'modules/colour/colour.dart';
export 'modules/menu/menu.dart';
export 'modules/colour_picker/colour_picker.dart';


part 'core/constants/bases.dart';
part 'core/constants/colour_pickers.dart';
part 'modules/colour/constants/colours.dart';
part 'core/constants/moment.dart';
part 'core/constants/packaged_fonts.dart';
part 'core/constants/picker_style.dart';
part 'core/constants/strings.dart';
part 'core/constants/tab_view.dart';
part 'core/datatypes/moment.dart';
part 'core/datatypes/period.dart';
part 'core/extensions/build_context.dart';
part 'core/extensions/double.dart';
part 'core/extensions/int.dart';
part 'core/extensions/list.dart';
part 'core/extensions/num.dart';
part 'core/extensions/string.dart';
part 'core/extensions/widget.dart';
part 'core/helpers/collect_icons.dart';
part 'core/helpers/fonts.dart';
part 'core/presentation/action_icon.dart';
part 'core/presentation/app_theme.dart';
part 'core/presentation/box.dart';
part 'core/presentation/hover_detector.dart';
part 'core/presentation/rounded_checkmark.dart';
part 'core/presentation/tab_view.dart';
part 'core/presentation/word.dart';
part 'core/utils/notifications.dart';
part 'core/utils/radix.dart';
part 'core/utils/strings.dart';
