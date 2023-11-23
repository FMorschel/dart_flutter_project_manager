import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DirectorySearchingPage extends StatefulWidget {
  const DirectorySearchingPage({super.key});

  static const routeName = '/directory_searching';

  @override
  State<DirectorySearchingPage> createState() => _DirectorySearchingPageState();
}

class _DirectorySearchingPageState extends State<DirectorySearchingPage> {
  final openDirectory = Completer<Directory>();

  @override
  void initState() {
    super.initState();
    openDirectory.complete(_openDocumentsDirectory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: openDirectory.future,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: list(asyncSnapshot.data!.list()),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final fses = asyncSnapshot.data!;
              final dirs = fses.whereType<Directory>();
              final files = fses.whereType<File>();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 60,
                ),
                itemCount: dirs.length + files.length,
                itemBuilder: (context, index) {
                  if (index < dirs.length) {
                    return DirectoryTile(
                      directory: dirs.elementAt(index),
                    );
                  }
                  return FileTile(
                    file: files.elementAt(index - dirs.length),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Directory> _openDocumentsDirectory() async {
    final downloads = await getDownloadsDirectory();
    if (downloads == null) {
      throw Exception('No downloads directory');
    }
    return downloads.parent
        .listSync()
        .whereType<Directory>()
        .singleWhere((fse) => p.basename(fse.path) == 'Documents');
  }

  Stream<List<FileSystemEntity>> list(Stream<FileSystemEntity> stream) async* {
    final list = <FileSystemEntity>[];
    await for (final fse in stream) {
      list.add(fse);
      yield list;
    }
    return;
  }

  int sort(FileSystemEntity a, FileSystemEntity b) {
    if ((a is Directory) && (b is File)) return -1;
    if ((a is File) && (b is Directory)) return 1;
    return a.path.compareTo(b.path);
  }
}

class DirectoryTile<D extends Directory> extends StatelessWidget {
  const DirectoryTile({
    required this.directory,
    super.key,
  });

  final D directory;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FileTile<F extends File> extends StatelessWidget {
  const FileTile({
    required this.file,
    super.key,
  });

  final F file;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
