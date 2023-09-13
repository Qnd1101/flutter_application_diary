import 'dart:convert';
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
  String fileName = 'diary.json';
  String filePath = '';
  dynamic myList = const Text('준비');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath().then((value) {
      showList();
    });
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory(); // 모든 플랫폼에서 사용 가능하기 때문에
    if (directory != null) {
      filePath = '${directory!.path}/$fileName'; // 경로/경로/diary.json
      print(filePath);
    }
  }

  Future<void> deleteFile() async {
    try {
      var file = File(filePath);
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
      // 파일을 불러옴 -> 그것을 [{},{}] -> jsondecode를 해서 List<map>으로 변환
      var file = File(filePath);
      var fileContents = await file.readAsString();
      List<dynamic> dataList = jsonDecode(fileContents) as List<dynamic>;

      // List니까 배열 조작   원하는 index번지 삭제하기
      dataList.removeAt(index);

      // List<map<dynamic>> 을 jsonencode (String으로 변경) => 다시 파일에 쓰기
      var jsondata = jsonEncode(dataList);
      await file.writeAsString(jsondata).then((value) {
        // showList()
        showList();
      });
    } catch (e) {
      print('삭제 정보 오류');
    }
  }

  Future<void> showList() async {
    try {
      var file = File(filePath);
      if (file.existsSync()) {
        setState(() {
          myList = FutureBuilder(
            future: file.readAsString(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var d = snapshot.data; // String - [{'title' : 'asd'}....]
                var dataList = jsonDecode(d!) as List<dynamic>;
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
                    ListView;
                  },
                  child: const Text('조회'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteFile();
                  },
                  child: const Text('삭제'),
                )
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
                filePath: filePath,
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
