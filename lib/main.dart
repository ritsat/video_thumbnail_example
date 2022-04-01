import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _thumbnailFile;

  String? _thumbnailUrl;

  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  Future<File> copyAssetFile(String assetFileName) async {
    Directory tempDir = await getTemporaryDirectory();
    final byteData = await rootBundle.load(assetFileName);

    File videoThumbnailFile = File("${tempDir.path}/$assetFileName")
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return videoThumbnailFile;
  }

  void generateThumbnail() async {
    File videoTempFile1 = await copyAssetFile("assets/nature1.mp4");
    File videoTempFile2 = await copyAssetFile("assets/nature2.mp4");

    _thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoTempFile1.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG);

    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
        video:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP);

    _thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoTempFile2.path,
      imageFormat: ImageFormat.JPEG,
      // maxHeight: 300,
      // maxWidth: 300,
      quality: 75,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Video Thumbnail"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (_thumbnailFile != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thumbnail using thumbnail file path :"),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(File(_thumbnailFile!)),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black45,
                            child: Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_thumbnailData != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thumbnail using in memory thumbnail :"),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.memory(_thumbnailData!),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black45,
                            child: Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_thumbnailUrl != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thumbnail using Video url :"),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(File(_thumbnailUrl!)),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black45,
                            child: Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
