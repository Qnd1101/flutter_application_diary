import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_diary/add_page.dart';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Directory? directory;
  String filePath = 'msg.json';

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    getPath();
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory(); // 모든 플랫폼에서 사용 가능하기 때문에
    if (directory != null) {
      var fileName = 'diary.json';
      filePath = '${directory!.path}/$fileName'; // 경로/경로/diary.json
      print(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('hello'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(
                filePath: 'temp',
              ),
            ),
          );

          print(result);
        },
        child: const Icon(Icons.pest_control_outlined),
      ),
    );
  }
}
