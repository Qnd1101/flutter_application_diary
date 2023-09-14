import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_diary/add_page.dart';
import 'package:intl/intl.dart'; // DateFormat를 import해야 함
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
  dynamic myList = const Text('준비');

  @override
  void initState() {
    super.initState();
    getPath().then((value) {
      showList();
    });
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory();
  }

  Future<void> deleteFile() async {
    try {
      var file = File(filePath());
      var result = file.delete().then((value) {
        print(value);
        showList();
      });
      print(result);
    } catch (e) {
      print('delete error');
    }
  }

  deleteContents(int index) async {
    try {
      var file = File(filePath());
      var fileContents = await file.readAsString();
      List<dynamic> dataList = jsonDecode(fileContents) as List<dynamic>;
      dataList.removeAt(index);
      var jsondata = jsonEncode(dataList);
      await file.writeAsString(jsondata).then((value) {
        showList();
      });
    } catch (e) {
      print('삭제 정보 오류');
    }
  }

  Future<void> showList() async {
    try {
      if (directory != null) {
        setState(() {
          myList = FutureBuilder(
            future: getDiaryList(), // 변경: getDiaryList 함수 호출
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dataList = snapshot.data as List<dynamic>;
                if (dataList.isEmpty) {
                  return const Text('파일 존재 X');
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = dataList[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['contents']),
                      trailing: IconButton(
                        onPressed: () {
                          deleteContents(index);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: dataList.length,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
      } else {
        setState(() {
          myList = const Text('파일 존재 X');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String filePath() {
    // 파일 경로를 생성하는 함수
    if (directory != null) {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String fileName = 'diary_$date.json';
      return '${directory!.path}/$fileName';
    } else {
      return '';
    }
  }

  Future<List<dynamic>> getDiaryList() async {
    // 변경: 날짜별로 폴더에서 파일 목록을 가져오는 함수
    List<dynamic> dataList = [];
    if (directory != null) {
      var dirList = directory!.listSync();
      for (var dir in dirList) {
        if (dir is Directory) {
          var file = File('${dir.path}/diary.json');
          if (file.existsSync()) {
            var fileContents = await file.readAsString();
            var jsonData = jsonDecode(fileContents);
            dataList.addAll(jsonData);
          }
        }
      }
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showList();
                  },
                  child: const Text('조회'),
                ),ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: ,
                        firstDate: ,
                        lastDate: ,
                      );
                    },
                    child: const Icon(Icons.date_range)),
                ElevatedButton(
                  onPressed: () {
                    deleteFile();
                  },
                  child: const Text('삭제'),
                ),
              ],
            ),
            Expanded(
              child: myList,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(
                directory: directory, // 변경: directory 정보를 AddPage로 전달
              ),
            ),
          );
          if (result == 'ok') {
            showList();
          }
        },
        child: const Icon(Icons.pest_control_outlined),
      ),
    );
  }
}
