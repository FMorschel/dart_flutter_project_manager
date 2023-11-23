import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DirectorySearchingPage extends StatefulWidget {
  const DirectorySearchingPage({super.key});

  static const routeName = '/directory_searching';

  @override
  State<DirectorySearchingPage> createState() => _DirectorySearchingPageState();
}

class _DirectorySearchingPageState extends State<DirectorySearchingPage> {
  final crossAxisCount = ValueNotifier(10);
  final openDirectory = Completer<Directory?>();

  @override
  void initState() {
    super.initState();
    openDirectory.complete(_openDocumentsDirectory());
  }

  @override
  void dispose() {
    crossAxisCount.dispose();
    if (!openDirectory.isCompleted) openDirectory.complete(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const CharacterActivator('+', control: true): _decreseCrossAxisCount,
        const CharacterActivator('-', control: true): _increseCrossAxisCount,
        SingleActivator(LogicalKeyboardKey.arrowUp): _increseCrossAxisCount,
        SingleActivator(LogicalKeyboardKey.arrowDown): _decreseCrossAxisCount,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
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
                  final dirs = fses.whereType<Directory>().sorted(sort);
                  final files = fses.whereType<File>().sorted(sort);
                  return ValueListenableBuilder(
                    valueListenable: crossAxisCount,
                    builder: (context, crossAxisCount, _) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _decreseCrossAxisCount() {
    crossAxisCount.value = math.max(crossAxisCount.value - 1, 2);
  }

  void _increseCrossAxisCount() {
    crossAxisCount.value = math.min(crossAxisCount.value + 1, 15);
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
    return AspectRatio(
      aspectRatio: 1,
      child: Image.asset('assets/images/folder.png'),
    );
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
