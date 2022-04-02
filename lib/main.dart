import 'package:convert_webp/models/filesValueNotifier.dart';
import 'package:convert_webp/models/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart' as BagImage;

import 'package:convert_webp/components/images/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'convertWebP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WebP转换'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BagImage.Image> imageList = [];
  List<XFile> imageFiles = [];
  setFiles(List<XFile> files) {
    imageFiles.addAll(files);
    files.forEach((element) async {
      final bytes = await files[0].readAsBytes();
      imageList.add(BagImage.decodeImage(bytes)!);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton.icon(
            onPressed: () {
              imageFiles.clear();
              imageList.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.restart_alt_outlined,
              color: Colors.white,
            ),
            label: Text(
              '重置',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropTarget(
                  onDragDone: (details) {
                    final files = details.files;
                    setFiles(files);
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final typeGroup = XTypeGroup(
                        label: 'images',
                        extensions: ['jpg', 'png', 'webp'],
                      );
                      final files =
                          await openFiles(acceptedTypeGroups: [typeGroup]);
                      setFiles(files);
                    },
                    child: Tooltip(
                      message: '点击选择或拖入图片',
                      waitDuration: Duration(milliseconds: 500),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(0),
                          color: Color.fromARGB(255, 136, 136, 136),
                          strokeWidth: 3,
                          dashPattern: [3, 3],
                          child: Container(
                            width: 500,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: 200,
                              color: Color.fromARGB(255, 136, 136, 136),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ChangeNotifierProvider<FilesModel>(
                  data: FilesModel(imageFiles, imageList),
                  child: ImageWrapper(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
