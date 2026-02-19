part of '../../collect.dart';

typedef Font = String;

class SystemFonts {
  static final SystemFonts _instance = SystemFonts._internal();

  factory SystemFonts() {
    return _instance;
  }

  SystemFonts._internal() {
    _fontDirectories.addAll(_getFontDirectories());
  }

  final List<String> _fontDirectories = [];

  final List<String> _fontPaths = [];
  final Map<String, String> _fontMap = {};
  final List<String> _loadedFonts = [];

  List<String> _getFontDirectories() {
    if (Platform.isWindows) {
      return [
        '${Platform.environment['windir']}/fonts/',
        '${Platform.environment['USERPROFILE']}/AppData/Local/Microsoft/Windows/Fonts/',
      ];
    }
    if (Platform.isMacOS) {
      return [
        '/Library/Fonts/',
        '/System/Library/Fonts/',
        '${Platform.environment['HOME']}/Library/Fonts/',
      ];
    }
    if (Platform.isLinux) {
      return [
        '/usr/share/fonts/',
        '/usr/local/share/fonts/',
        '${Platform.environment['HOME']}/.local/share/fonts/',
      ];
    }
    return [];
  }

  List<String> getFontPaths() {
    if (_fontPaths.isEmpty) {
      final paths = _fontDirectories;
      final List<FileSystemEntity> fontFilePaths = [];

      for (final path in paths) {
        if (!Directory(path).existsSync()) {
          continue;
        }
        fontFilePaths.addAll(Directory(path).listSync());
      }

      _fontPaths.addAll(
        fontFilePaths
            .where(
              (element) =>
                  element.path.endsWith('.ttf') ||
                  element.path.endsWith('.otf'),
            )
            .map((e) => e.path)
            .toList(),
      );
    }
    return _fontPaths;
  }

  Map<String, String> getFontMap() {
    if (_fontMap.isEmpty) {
      _fontMap.addAll(
        Map.fromEntries(
          getFontPaths().map((e) => MapEntry(p.basenameWithoutExtension(e), e)),
        ),
      );
    }
    return _fontMap;
  }

  List<String> getFontList() {
    return getFontMap().keys.toList();
  }

  Future<String?> loadFont(String fontName) async {
    if (_loadedFonts.contains(fontName)) {
      return fontName;
    }

    if (!getFontMap().containsKey(fontName)) {
      return null;
    }

    final bytes = await File(getFontMap()[fontName]!).readAsBytes();
    FontLoader(fontName)
      ..addFont(Future.value(ByteData.view(bytes.buffer)))
      ..load();

    _loadedFonts.add(fontName);
    return fontName;
  }

  Future<List<String>> loadAllFonts() async {
    List<String> loadedFonts = [];
    for (final font in getFontList()) {
      loadedFonts.add((await loadFont(font))!);
    }
    return loadedFonts;
  }

  Future<String?> loadFontFromPath(String path) async {
    if (!path.endsWith('.ttf') && !path.endsWith('.otf')) {
      return null;
    }

    if (!File(path).existsSync()) {
      return null;
    }

    if (_fontMap.containsKey(p.basenameWithoutExtension(path))) {
      return null;
    }

    _fontMap[p.basenameWithoutExtension(path)] = path;

    return loadFont(p.basenameWithoutExtension(path));
  }

  void addAdditionalFontDirectory(String path) {
    if (!Directory(path).existsSync()) {
      return;
    }

    for (FileSystemEntity e in Directory(path).listSync()) {
      if (!e.path.endsWith('.ttf') && !e.path.endsWith('.otf')) {
        continue;
      }
      _fontMap[p.basenameWithoutExtension(e.path)] = e.path;
    }
  }

  void rescan() {
    _fontMap.clear();
    _fontPaths.clear();
  }
}
