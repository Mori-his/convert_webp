import 'package:convert_webp/components/images/list.dart';
import 'package:convert_webp/models/filesValueNotifier.dart';
import 'package:convert_webp/models/provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class ImageWrapper extends StatefulWidget {
  ImageWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageWrapper> createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {

  @override
  Widget build(BuildContext context) {
    final filesModel = ChangeNotifierProvider.of<FilesModel>(context);

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: '已载入',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: filesModel.files.length.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '个图片',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ImageList(),
        ],
      ),
    );
  }
}
