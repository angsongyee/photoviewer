import 'package:exif/exif.dart';

class ExifData {
  final String aperture;
  final String focalLength;
  final String iso;
  final String shutterSpeed;

  ExifData(Map<String, IfdTag> rawExifValues) :
        aperture = _parseAperture(rawExifValues['EXIF FNumber'].toString()),
        focalLength = _parseFocalLength(rawExifValues['EXIF FocalLength'].toString()),
        iso = _parseISO(rawExifValues['EXIF ISOSpeedRatings'].toString()),
        shutterSpeed = rawExifValues['EXIF ExposureTime'].toString();

  static Future<ExifData> fromBytes(List<int> bytes) async {
    return ExifData(await readExifFromBytes(bytes));
  }
  
  static String _parseAperture(String input) {
    var values = input.split('/');
    var aperture = double.parse(values[0]) / double.parse(values[1]);
    return 'f/$aperture';
  }

  static String _parseISO(String input) {
    return 'ISO $input';
  }

  static String _parseFocalLength(String input) {
    return '${input}mm';
  }

  @override
  String toString() {
    return '$focalLength $aperture $shutterSpeed $iso';
  }

}
