import 'dart:io';

import 'package:convert_webp/models/filesValueNotifier.dart';
import 'package:convert_webp/models/provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  const ImageList({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  int hoverIndex = -1;
  bool isHover = false;

  setHoverIndex(int index) {
    hoverIndex = index;
    setState(() {});
  }

  setHover(bool isHover) {
    isHover = isHover;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double itemPaddingAll = 5;
    final double itemMarginAll = 10;
    final double width = 80;
    final double height = 80;

    final filesModel = ChangeNotifierProvider.of<FilesModel>(context);

    return Wrap(
      children: [
        ...filesModel.files.asMap().entries.map((entrie) {
          final index = entrie.key;
          final file = entrie.value;
          return Draggable(
            feedback: Container(
              width: width,
              height: height,
              child: Image.file(
                File(file.path),
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            ),
            childWhenDragging: Container(
              width: width + (itemPaddingAll + itemMarginAll) * 2,
              height: height + (itemPaddingAll + itemMarginAll) * 2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withAlpha(30),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            child: imageItem(
              index,
              itemMarginAll,
              itemPaddingAll,
              file,
              width,
              height,
              context,
            ),
          );
        }),
      ],
    );
  }

  MouseRegion imageItem(int index, double itemMarginAll, double itemPaddingAll,
      XFile file, double width, double height, BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setHoverIndex(index);
      },
      onExit: (event) {
        setHoverIndex(-1);
      },
      child: Stack(
        children: [
          Positioned(
            child: Text(
              index.toString(),
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
            top: itemMarginAll + 2,
            left: itemMarginAll + 5,
          ),
          Container(
            margin: EdgeInsets.all(itemMarginAll),
            padding: EdgeInsets.all(itemPaddingAll),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withAlpha(30),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Image.file(
              File(file.path),
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
          ),
          if (hoverIndex == index)
            Positioned(
              top: -5,
              right: -5,
              child: IconButton(
                onPressed: () {
                  ChangeNotifierProvider.of<FilesModel>(context).delete(index);
                },
                icon: Icon(
                  Icons.disabled_by_default_rounded,
                ),
                iconSize: 22,
                splashRadius: 1,
              ),
            ),
        ],
      ),
    );
  }
}
