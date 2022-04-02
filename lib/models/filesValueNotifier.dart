
import 'dart:collection';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:image/image.dart';


class FilesModel extends ChangeNotifier {
  final List<XFile> _files;
  final List<Image> _images;

  FilesModel(this._files, this._images);

  // 禁止修改files
  UnmodifiableListView<XFile> get files => UnmodifiableListView(_files);
  UnmodifiableListView<Image> get images => UnmodifiableListView(images);

  void delete<T>(int index) {
    if (index <= _files.length) _files.removeAt(index);

    notifyListeners();
  }

  void clear() {
    _files.clear();
    _images.clear();
    notifyListeners();
  }
}

