import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileSystemSelectScreen extends StatefulWidget {
  const FileSystemSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FileSystemSelectScreenState();
}

class _FileSystemSelectScreenState extends State<FileSystemSelectScreen> {
  static const platform = MethodChannel('photoviewer/channels');
  String _directoryUri = "No directory selected";

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _launchFolderPickerIntent() async {
    final result = await platform.invokeMethod<String>('chooseDirectory');
    setState(() {
      _directoryUri = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _launchFolderPickerIntent,
          child: Text("Pick Folder"),
        ),
        Text(_directoryUri, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
