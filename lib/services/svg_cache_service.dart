import 'package:flutter/services.dart';

class SvgCacheService {
  static final Map<String, String> _cache = {};

  static Future<String> loadSvg(String assetPath) async {
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }

    final svgString = await rootBundle.loadString(assetPath);
    _cache[assetPath] = svgString;
    return svgString;
  }

  static void clearCache() {
    _cache.clear();
  }
} 