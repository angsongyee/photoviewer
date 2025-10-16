import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_viewer/ui/view_photo/view_photo_screen.dart';
import 'package:photo_viewer/ui/filesystem_select/filesystem_select_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  debugPrintRebuildDirtyWidgets = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        textTheme: GoogleFonts.robotoMonoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: Scaffold(body: Center(child: FileSystemSelectScreen())),
    );
  }
}
