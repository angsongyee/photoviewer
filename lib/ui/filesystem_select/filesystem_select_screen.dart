import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_viewer/ui/gallery/gallery_screen.dart';

class FileSystemSelectScreen extends StatefulWidget {
  const FileSystemSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FileSystemSelectScreenState();
}

class _FileSystemSelectScreenState extends State<FileSystemSelectScreen> {
  static const platform = MethodChannel('photoviewer/channels');
  String? _directoryUri;

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _launchFolderPickerIntent() async {
    final result = await platform.invokeMethod<String>('chooseDirectory');
    setState(() {
      _directoryUri = result ?? _directoryUri;
    });
  }

  void _openFolder() {
    if (_directoryUri == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Select a directory first!"),
      ));
      return;
    }

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => GalleryScreen(directoryUri: _directoryUri!))
    );
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
        Text(_directoryUri ?? "No directory selected", style: Theme.of(context).textTheme.bodyLarge),
        ElevatedButton(onPressed: _openFolder, child: Text("Open Folder")),
      ],
    );
  }
}
